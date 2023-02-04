Class {
	#name : #AlbRemanentWithHighlightsUpdater,
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

{ #category : #'private - remanent selection' }
AlbRemanentWithHighlightsUpdater >> createPortionsIn: anEditorElement [

	remanentString := anEditorElement selectedText asString.
	self terminateUpdater.
	self resetPortions.
	remanentString ifEmpty: [ ^ self ].
	self updatePortionsIn: anEditorElement 
 
]

{ #category : #'infinite element changes' }
AlbRemanentWithHighlightsUpdater >> extentChangedIn: anInfiniteElement [

	self updatePortionsIn: anInfiniteElement
]

{ #category : #'private - remanent selection' }
AlbRemanentWithHighlightsUpdater >> highlightRemanent: aPieceElement from: startIdx to: endIdx [

	aPieceElement
		highlightCategory: #remanent
		with: (BlTextParagraphHighlight paint: self remanentBackgroundColor from: startIdx to: endIdx)
]

{ #category : #initialization }
AlbRemanentWithHighlightsUpdater >> initialize [ 

	super initialize.
	monitor := Monitor new.
	remanents := OrderedCollection new
]

{ #category : #'api - install/uninstall  hook' }
AlbRemanentWithHighlightsUpdater >> onInstalledIn: anEditorElement [


	selectionColor := anEditorElement selectionColor. 
	selectionHandler := BlEventHandler on: AlbSelectionChangedEvent do: [ self selectionChangedIn: anEditorElement ].

	extentChangeHandler := BlEventHandler
		                       on: BlElementExtentChangedEvent
		                       do: [ :evt | 
		                       self extentChangedIn: anEditorElement ].

	scrollHandler := BlEventHandler
		                 on: BlElementScrolledEvent
		                 do: [ :evt | self scrollEventIn: anEditorElement ].

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
AlbRemanentWithHighlightsUpdater >> onUninstalledIn: anEditorElement [

	anEditorElement editor removeEventHandler: selectionHandler.
	anEditorElement removeEventHandler: extentChangeHandler.
	anEditorElement editor removeEventHandler: updateRequestHandler.
	anEditorElement editor removeEventHandler: textEditionHandler.
	anEditorElement infinite removeEventHandler: scrollHandler.
	anEditorElement infinite removeEventHandler: infiniteEditorChangeHandler


]

{ #category : #accessing }
AlbRemanentWithHighlightsUpdater >> remanentBackgroundColor [

	^ selectionColor alpha: 0.3
]

{ #category : #'private - remanent selection' }
AlbRemanentWithHighlightsUpdater >> remanentInterval: anInterval in: anEditorElement [

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

{ #category : #'private - remanent selection' }
AlbRemanentWithHighlightsUpdater >> resetPortions [

	remanents do: [ :r | r resetHighlightsOfCategory: #remanent ].
	remanents reset
]

{ #category : #'private - remanent selection' }
AlbRemanentWithHighlightsUpdater >> resetRemanents [

	remanents do: [ :r | r resetHighlightsOfCategory: #remanent ].
	remanents reset
]

{ #category : #'infinite element changes' }
AlbRemanentWithHighlightsUpdater >> scrollEventIn: anInfiniteElement [

	self updatePortionsIn: anInfiniteElement
]

{ #category : #'infinite element changes' }
AlbRemanentWithHighlightsUpdater >> selectionChangedIn: anInfiniteElement [

	self updatePortionsIn: anInfiniteElement
]

{ #category : #'private - remanent selection' }
AlbRemanentWithHighlightsUpdater >> terminateUpdater [

	updaterProcess ifNotNil: #terminate.
	updaterProcess := nil
]

{ #category : #'infinite element changes' }
AlbRemanentWithHighlightsUpdater >> textEditedIn: anInfiniteElement [

	anInfiniteElement whenLayoutedDoOnce: [ self updatePortionsIn: anInfiniteElement ]
]

{ #category : #'private - remanent selection' }
AlbRemanentWithHighlightsUpdater >> updatePortionsIn: anEditorElement [

	| collector subTextOnScreen founds | 
	monitor critical: [
		self terminateUpdater.
		self resetPortions.
		remanentString ifNil: [ ^ self ].
		remanentString ifEmpty: [ ^ self ].
		subTextOnScreen := anEditorElement subTextOnScreen.
		collector := BlIntervalCollector new text: subTextOnScreen asString.
		updaterProcess := [ (Delay forMilliseconds: 200) wait.
		                   founds := collector searchAll: remanentString.
		                   founds do: [ :interval | self remanentInterval: interval + subTextOnScreen textOffset in: anEditorElement ].
		                   updaterProcess := nil ]
			                   forkAt: Processor userBackgroundPriority
			                   named: 'Album remanent selection updater task' ]
]
