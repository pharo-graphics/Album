Class {
	#name : #AlbRemanentUpdater,
	#superclass : #Object,
	#instVars : [
		'extentChangeHandler',
		'cursorMoveHandler',
		'scrollHandler',
		'remanents',
		'remanentString',
		'monitor',
		'updateRequestHandler',
		'updaterProcess',
		'textEditionHandler',
		'infiniteEditorChangeHandler',
		'selectionColor',
		'selectionHandler'
	],
	#category : #'Album-UI'
}

{ #category : #'infinite element changes' }
AlbRemanentUpdater >> extentChangedIn: anInfiniteElement [

	self updateRemanentsIn: anInfiniteElement
]

{ #category : #'private - remanent selection' }
AlbRemanentUpdater >> highlightRemanent: aPieceElement from: startIdx to: endIdx [

	aPieceElement
		highlightCategory: #remanent
		with: (BlTextParagraphHighlight paint: self remanentBackgroundColor from: startIdx to: endIdx)
]

{ #category : #initialization }
AlbRemanentUpdater >> initialize [ 

	super initialize.
	monitor := Monitor new.
	remanents := OrderedCollection new
]

{ #category : #'api - install/uninstall  hook' }
AlbRemanentUpdater >> onInstalledIn: anEditorElement [


	selectionColor := anEditorElement selectionColor. 
	selectionHandler := BlEventHandler on: AlbSelectionChangedEvent do: [ self selectionChangedIn: anEditorElement ].

	extentChangeHandler := BlEventHandler
		                       on: BlElementExtentChangedEvent
		                       do: [ :evt | 
		                       self extentChangedIn: anEditorElement ].

	scrollHandler := BlEventHandler
		                 on: BlElementScrolledEvent
		                 do: [ :evt | self scrollEventIn: anEditorElement ].

	updateRequestHandler := BlEventHandler
		                        on: AlbRemanentUpdateRequest
		                        do: [ :evt | 
		                        self remanentUpdateRequestIn:
			                        anEditorElement ].

	textEditionHandler := BlEventHandler
		                      on: AlbTextEditedEvent
		                      do: [ :evt | 
		                      self textEditedIn: anEditorElement ].

	infiniteEditorChangeHandler := BlEventHandler
		                               on: AlbTextEditorReplacedEvent
		                               do: [ :event | 
			event previous ifNotNil: [ :prev | 
				prev removeEventHandler: updateRequestHandler.
				prev removeEventHandler: textEditionHandler ].
			event current ifNotNil: [ :curr | 
				curr addEventHandler: updateRequestHandler.
				curr addEventHandler: textEditionHandler ] ].

	anEditorElement editor addEventHandler: selectionHandler.
	anEditorElement addEventHandler: extentChangeHandler.
	anEditorElement editor addEventHandler: updateRequestHandler.
	anEditorElement editor addEventHandler: textEditionHandler.
	anEditorElement infinite addEventHandler: scrollHandler.
	anEditorElement infinite addEventHandler: infiniteEditorChangeHandler
]

{ #category : #'api - install/uninstall  hook' }
AlbRemanentUpdater >> onUninstalledIn: anEditorElement [

	anEditorElement editor removeEventHandler: selectionHandler.
	anEditorElement removeEventHandler: extentChangeHandler.
	anEditorElement editor removeEventHandler: updateRequestHandler.
	anEditorElement editor removeEventHandler: textEditionHandler.
	anEditorElement infinite removeEventHandler: scrollHandler.
	anEditorElement infinite removeEventHandler: infiniteEditorChangeHandler


]

{ #category : #accessing }
AlbRemanentUpdater >> remanentBackgroundColor [

	^ selectionColor alpha: 0.3
]

{ #category : #'private - remanent selection' }
AlbRemanentUpdater >> remanentInterval: anInterval in: anEditorElement [

	| startIdx endIdx |
	startIdx := anInterval first.
	endIdx := anInterval last.
	anEditorElement infinite
		textPiecesAndTheirElementsWithinIndexInterval: (startIdx to: endIdx)
		do: [ :piece :pieceElement | 
			| first last |
			((piece textStart to: piece textEnd) includesAll:
				 (startIdx to: endIdx))
				ifTrue: [ 
					first := startIdx.
					last := endIdx ]
				ifFalse: [ 
					startIdx > piece textStart
						ifTrue: [ 
							first := startIdx.
							last := piece textEnd ]
						ifFalse: [ 
							first := piece textStart.
							last := endIdx min: piece textEnd ] ].
			((startIdx -1 to: endIdx) = (anEditorElement selection from to: anEditorElement selection to)) 
				ifFalse: [ 
					self
						highlightRemanent: pieceElement
						from: first - piece textStart - 1
						to: last - piece textStart.
					remanents add: pieceElement ] ]
]

{ #category : #'infinite element changes' }
AlbRemanentUpdater >> remanentUpdateRequestIn: anEditorElement [

	self setRemanentsIn: anEditorElement

]

{ #category : #'private - remanent selection' }
AlbRemanentUpdater >> remanentsUpdatedIn: anEditorElement [

	updaterProcess := nil
]

{ #category : #'private - remanent selection' }
AlbRemanentUpdater >> resetRemanents [

	remanents do: [ :r | r resetHighlightsOfCategory: #remanent ].
	remanents reset
]

{ #category : #'infinite element changes' }
AlbRemanentUpdater >> scrollEventIn: anInfiniteElement [

	self updateRemanentsIn: anInfiniteElement
]

{ #category : #'infinite element changes' }
AlbRemanentUpdater >> selectionChangedIn: anInfiniteElement [

	self remanentUpdateRequestIn: anInfiniteElement
]

{ #category : #'private - remanent selection' }
AlbRemanentUpdater >> setRemanentsIn: anEditorElement [

	remanentString := anEditorElement selectedText asString.
	self terminateRemanentsUpdater.
	self resetRemanents.
	remanentString ifEmpty: [ ^ self ].
	self updateRemanentsIn: anEditorElement 
 
]

{ #category : #'private - remanent selection' }
AlbRemanentUpdater >> terminateRemanentsUpdater [

	updaterProcess ifNotNil: #terminate.
	updaterProcess := nil
]

{ #category : #'infinite element changes' }
AlbRemanentUpdater >> textEditedIn: anInfiniteElement [

	anInfiniteElement whenLayoutedDoOnce: [ self updateRemanentsIn: anInfiniteElement ]
]

{ #category : #'private - remanent selection' }
AlbRemanentUpdater >> updateRemanentsIn: anEditorElement [

	| collector subTextOnScreen founds | 
	monitor critical: [
		self terminateRemanentsUpdater.
		self resetRemanents.
		remanentString ifNil: [ ^ self ].
		remanentString ifEmpty: [ ^ self ].
		subTextOnScreen := anEditorElement subTextOnScreen.
		collector := BlIntervalCollector new text: subTextOnScreen asString.
		updaterProcess := [ (Delay forMilliseconds: 200) wait.
		                   founds := collector searchAll: remanentString.
		                   founds do: [ :interval | self remanentInterval: interval + subTextOnScreen textOffset in: anEditorElement ].
		                   self remanentsUpdatedIn: anEditorElement ]
			                   forkAt: Processor userBackgroundPriority
			                   named: 'Album remanent selection updater task' ]
]
