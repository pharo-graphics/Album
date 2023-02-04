Class {
	#name : #AlbRemanentSelectionUpdater,
	#superclass : #AlbTextPortionUpdater,
	#instVars : [
		'selectionColor',
		'selectionHandler',
		'remanentText'
	],
	#category : #'Album-UI'
}

{ #category : #private }
AlbRemanentSelectionUpdater >> createPortionsIn: anEditorElement [

	| collector subTextOnScreen founds |
	monitor critical: [ 
		self terminateUpdater.
		self resetPortions.
		self remanentText ifNil: [ ^ self ].
		self remanentText ifEmpty: [ ^ self ].
		subTextOnScreen := anEditorElement subTextOnScreen.

		updaterProcess := [ 
		                  (Delay forMilliseconds: self updateDelay) wait.
		                  collector := BlIntervalCollector new text: subTextOnScreen asString.
		                  founds := collector searchAll: self remanentString.
		                  founds do: [ :interval | 
			                  self
				                  portionInterval:
				                  interval + subTextOnScreen textOffset
				                  in: anEditorElement ].
		                  anEditorElement frontLayer addChildren: (portions select: [ :r | r hasParent not ]).
		                  updaterProcess := nil ]
			                  forkAt: Processor systemBackgroundPriority
			                  named: 'Album remanent selection updater task' ]
]

{ #category : #'api - install/uninstall  hook' }
AlbRemanentSelectionUpdater >> onInstalledIn: anEditorElement [

	super onInstalledIn: anEditorElement.
	selectionColor := anEditorElement selectionColor. 
	selectionHandler := BlEventHandler on: AlbSelectionChangedEvent do: [ self selectionChangedIn: anEditorElement ].
	anEditorElement editor addEventHandler: selectionHandler.

]

{ #category : #'api - install/uninstall  hook' }
AlbRemanentSelectionUpdater >> onUninstalledIn: anEditorElement [

	super onUninstalledIn: anEditorElement.
	anEditorElement editor removeEventHandler: selectionHandler

]

{ #category : #private }
AlbRemanentSelectionUpdater >> portionInterval: anInterval in: anEditorElement [

	| startIdx endIdx rects rem |
	startIdx := anInterval first.
	endIdx := anInterval last.
	rects := Array streamContents: [ :stream | 
		         anEditorElement
			         textPiecesAndTheirElementsWithinIndexInterval: (startIdx to: endIdx)
			         do: [ :piece :pieceElement | 
				         | first last origin corner bnds |
				         ((piece textStart to: piece textEnd) includesAll: (startIdx to: endIdx))
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
				         			origin := pieceElement screenOriginAt: first - piece textStart - 1.
				         			corner := pieceElement screenCornerAt: last - piece textStart.
				         			bnds := (origin corner: corner) translateBy: pieceElement positionInEditor.
				         			stream nextPut: bnds ] ] ].
	rects ifEmpty: [ ^ self ].
	rem := AlbRemanentElement new adjacentRectangles: rects; text: self remanentText; interval: anInterval; yourself.
	portions add: rem 
]

{ #category : #accessing }
AlbRemanentSelectionUpdater >> remanentString [

	^ self remanentText asString
]

{ #category : #accessing }
AlbRemanentSelectionUpdater >> remanentText [

	^ remanentText
]

{ #category : #'infinite element changes' }
AlbRemanentSelectionUpdater >> selectionChangedIn: anInfiniteElement [

	remanentText := anInfiniteElement selectedText.
	self createPortionsIn: anInfiniteElement 
]

{ #category : #private }
AlbRemanentSelectionUpdater >> updatePortionsIn: anEditorElement [

	self createPortionsIn: anEditorElement 
]
