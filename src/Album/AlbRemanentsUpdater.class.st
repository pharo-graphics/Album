Class {
	#name : #AlbRemanentsUpdater,
	#superclass : #AlbTextPortionUpdater,
	#instVars : [
		'oppositeEcho',
		'textReplacedHandler'
	],
	#category : 'Album-UI-Text-Portion'
}

{ #category : #'opposite delimiter' }
AlbRemanentsUpdater >> closeOppositeDelimiter: oppositeTextElement at: localIdx in: anEditorElement [

	| bnds origin corner width |
	localIdx isZero ifTrue: [ ^ nil ].
	width := oppositeTextElement characterWidthAtIndex: localIdx.
	origin := (oppositeTextElement screenOriginAt: localIdx)
	          - (width @ 0).
	corner := oppositeTextElement screenCornerAt: localIdx.
	bnds := ((origin corner: corner) translateBy:
		         oppositeTextElement positionInEditor) expandBy:
		        (1 @ 2 corner: 0 @ 2).
	^ AlbOppositeDelimiterElement new
		  position: bnds origin;
		  size: bnds extent
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
							 in: anEditorElement) ifNotNil: [ :o | ^ o ] ] ].
			"after open delimiter"
			interval first = cursorPos ifTrue: [
				anEditorElement infinite
					atTextIndex: interval last + 1
					do: [ :textElement :localIdx |
						(self
							 closeOppositeDelimiter: textElement
							 at: localIdx
							 in: anEditorElement) ifNotNil: [ :o | ^ o ] ] ] ]
		ifAbsent: [  ].
	^ nil
]

{ #category : #'infinite element changes' }
AlbRemanentsUpdater >> cursorMovedIn: anEditorElement [ 

	super cursorMovedIn: anEditorElement.
	self updateOppositeDelimiterIn: anEditorElement

]

{ #category : #'infinite element changes' }
AlbRemanentsUpdater >> extentChangedIn: anEditorElement [ 

	self resetPortionsIn: anEditorElement..
	super extentChangedIn: anEditorElement.
	self updateOppositeDelimiterIn: anEditorElement

]

{ #category : #'api - install/uninstall  hook' }
AlbRemanentsUpdater >> onInstalledIn: anEditorElement [

	super onInstalledIn: anEditorElement.
	anEditorElement infinite whenModeChangedDo: [ self onUninstalledIn: anEditorElement ].
	textReplacedHandler := BlEventHandler
		                       on: AlbTextEditorReplacedEvent
		                       do: [ :evt | self onUninstalledIn: anEditorElement ].
	anEditorElement infinite addEventHandler: textReplacedHandler
]

{ #category : #'api - install/uninstall  hook' }
AlbRemanentsUpdater >> onUninstalledIn: anEditorElement [

	anEditorElement infinite removeEventHandler: textReplacedHandler.
	super onUninstalledIn: anEditorElement.

]

{ #category : #'opposite delimiter' }
AlbRemanentsUpdater >> openOppositeDelimiter: oppositeTextElement at: localIdx in: anEditorElement [

	| bnds origin corner width |
	localIdx isZero ifTrue: [ ^ nil ].
	origin := oppositeTextElement screenOriginAt: localIdx - 1.
	width := oppositeTextElement characterWidthAtIndex: localIdx.
	corner := (oppositeTextElement screenCornerAt: localIdx - 1)
	          + (width @ 0).
	bnds := ((origin corner: corner) translateBy:
		         oppositeTextElement positionInEditor) expandBy:
		        (1 @ 2 corner: 0 @ 2).
	^ AlbOppositeDelimiterElement new
		  position: bnds origin;
		  size: bnds extent
]

{ #category : #'infinite element changes' }
AlbRemanentsUpdater >> scrollEventIn: anEditorElement [ 

	self resetPortionsIn: anEditorElement.
	super scrollEventIn: anEditorElement.
	self updateOppositeDelimiterIn: anEditorElement

]

{ #category : #'infinite element changes' }
AlbRemanentsUpdater >> selectionChangedIn: anEditorElement [

	super selectionChangedIn: anEditorElement.
	self updatePortionsIn: anEditorElement.
	self updateOppositeDelimiterIn: anEditorElement
]

{ #category : #'opposite delimiter' }
AlbRemanentsUpdater >> updateOppositeDelimiterIn: anEditorElement [

	oppositeEcho ifNotNil: [
		oppositeEcho removeFromParent.
		oppositeEcho := nil ].
	anEditorElement selection ifNotEmpty: [ ^ self ].
	oppositeEcho := self createOppositeDelimiterIn: anEditorElement.
	oppositeEcho ifNotNil: [	anEditorElement addChild: oppositeEcho]
]

{ #category : #private }
AlbRemanentsUpdater >> updatePortionsIn: anEditorElement [

	self terminateUpdater.
	anEditorElement selectedText ifEmpty: [
		^ self resetPortionsIn: anEditorElement ].
	updaterProcess := [
	                  | builder |
	                  builder := AlbSubtextPortionBuilder new
		                             parentElement: anEditorElement;
		                             fullText: anEditorElement enlargedSubTextOnScreen;
		                             subtext: anEditorElement selectedText;
		                             yourself.
	                  builder createDecorations.
	                  self resetPortionsIn: anEditorElement.
	                  portions := builder decorations.
	                  self setPortionsIn: anEditorElement.
	                  updaterProcess := nil ]
		                  forkAt: Processor systemBackgroundPriority
		                  named: 'Album decoration builder task'
]
