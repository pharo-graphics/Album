Class {
	#name : #AlbRemanentsUpdater,
	#superclass : #AlbTextPortionUpdater,
	#instVars : [
		'selectionColor',
		'remanentText',
		'oppositeEcho'
	],
	#category : #'Album-UI'
}

{ #category : #'opposite delimiter' }
AlbRemanentsUpdater >> closeOppositeDelimiter: oppositeTextElement at: localIdx in: anEditorElement [

	| bnds origin corner width |
	localIdx isZero ifTrue: [ ^ nil ].
	width := oppositeTextElement characterWidthAtIndex: localIdx.
	origin := (oppositeTextElement screenOriginAt: localIdx) - (width @ 0).
	corner := oppositeTextElement screenCornerAt: localIdx.
	bnds := ((origin corner: corner) translateBy: oppositeTextElement positionInEditor) expandBy: (1@2 corner: 0@2).
	^ AlbOppositeDelimiter new relocate: bnds origin; size: bnds extent
]

{ #category : #'opposite delimiter' }
AlbRemanentsUpdater >> createOppositeDelimiterIn: anEditorElement [

	| cursorPos text |
	cursorPos := anEditorElement cursor position.
	cursorPos isZero ifTrue: [ ^ nil ].
	text := anEditorElement text.
	anEditorElement editor limitedSurroundMap
		intervalBetweenDelimitersIn: text
		at: cursorPos
		ifPresent: [ :interval | "
			interval first -> on left delim
			interval last + 1 -> on right delim
			""before  close delimiter"
			interval last = cursorPos ifTrue: [
				anEditorElement infinite
					atTextIndex: interval first
					do: [ :textElement :localIdx |
						(self
							 openOppositeDelimiter: textElement
							 at: localIdx
							 in: anEditorElement) ifNotNil: [ :o |
							o subtext: (anEditorElement text from: interval first to: interval first).
							o interval: (interval first to: interval first).
							^ o ] ] ].
			"after open delimiter"
			interval first = cursorPos ifTrue: [
				anEditorElement infinite
					atTextIndex: interval last + 1
					do: [ :textElement :localIdx |
						(self
							 closeOppositeDelimiter: textElement
							 at: localIdx
							 in: anEditorElement) ifNotNil: [ :o |
							o subtext: (anEditorElement text from: interval last + 1 to: interval last + 1).
							o interval: (interval last + 1 to: interval last + 1).
							^ o ] ] ] ]
		ifAbsent: [  ].
	^ nil
]

{ #category : #private }
AlbRemanentsUpdater >> createPortionsIn: anEditorElement [

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

{ #category : #'infinite element changes' }
AlbRemanentsUpdater >> cursorMovedIn: anEditorElement [ 

	super cursorMovedIn: anEditorElement.
	self updateOppositeDelimiterIn: anEditorElement

]

{ #category : #'infinite element changes' }
AlbRemanentsUpdater >> extentChangedIn: anEditorElement [ 

	super extentChangedIn: anEditorElement.
	self updateOppositeDelimiterIn: anEditorElement

]

{ #category : #'api - install/uninstall  hook' }
AlbRemanentsUpdater >> onInstalledIn: anEditorElement [

	super onInstalledIn: anEditorElement.
	selectionColor := anEditorElement selectionColor. 

]

{ #category : #'api - install/uninstall  hook' }
AlbRemanentsUpdater >> onUninstalledIn: anEditorElement [

	super onUninstalledIn: anEditorElement
]

{ #category : #'opposite delimiter' }
AlbRemanentsUpdater >> openOppositeDelimiter: oppositeTextElement at: localIdx in: anEditorElement [

	| bnds origin corner width |
	localIdx isZero ifTrue: [ ^ nil ].
	origin := oppositeTextElement screenOriginAt: localIdx - 1.
	width := oppositeTextElement characterWidthAtIndex: localIdx.
	corner := (oppositeTextElement screenCornerAt: localIdx - 1) + (width @ 0).
	bnds := ((origin corner: corner) translateBy: oppositeTextElement positionInEditor) expandBy: (1@2 corner: 0@2).
	^ AlbOppositeDelimiter new relocate: bnds origin; size: bnds extent
]

{ #category : #private }
AlbRemanentsUpdater >> portionInterval: anInterval in: anEditorElement [

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
	rem := AlbSelectionEcho new adjacentRectangles: rects; subtext: self remanentText; interval: anInterval; yourself.
	portions add: rem 
]

{ #category : #accessing }
AlbRemanentsUpdater >> remanentString [

	^ self remanentText asString
]

{ #category : #accessing }
AlbRemanentsUpdater >> remanentText [

	^ remanentText
]

{ #category : #'infinite element changes' }
AlbRemanentsUpdater >> scrollEventIn: anEditorElement [ 

	super scrollEventIn: anEditorElement.
	self updateOppositeDelimiterIn: anEditorElement

]

{ #category : #'infinite element changes' }
AlbRemanentsUpdater >> selectionChangedIn: anInfiniteElement [

	super selectionChangedIn: anInfiniteElement.
	remanentText := anInfiniteElement selectedText.
	self createPortionsIn: anInfiniteElement.
]

{ #category : #'opposite delimiter' }
AlbRemanentsUpdater >> updateOppositeDelimiterIn: anEditorElement [

	oppositeEcho ifNotNil: [
		oppositeEcho removeFromParent.
		oppositeEcho := nil ].
	oppositeEcho := self createOppositeDelimiterIn: anEditorElement.
	oppositeEcho ifNotNil: [	anEditorElement addChild: oppositeEcho]
]

{ #category : #private }
AlbRemanentsUpdater >> updatePortionsIn: anEditorElement [

	self createPortionsIn: anEditorElement.

]