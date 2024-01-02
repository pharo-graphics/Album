Class {
	#name : #AlbOppositeDelimiterUpdater,
	#superclass : #BlCustomEventHandler,
	#instVars : [
		'oppositeDelim'
	],
	#category : #'Album-UI-Text-Portion'
}

{ #category : #'opposite delimiter' }
AlbOppositeDelimiterUpdater >> closeOppositeDelimiter: oppositeTextElement at: localIdx in: anEditorElement [

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
AlbOppositeDelimiterUpdater >> createOppositeDelimiterIn: anEditorElement [

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

{ #category : #'api - accessing' }
AlbOppositeDelimiterUpdater >> eventsToHandle [

	^ { AlbSubtextElementInvalidateEvent. AlbInfiniteModeChangedEvent }
]

{ #category : #'event handling' }
AlbOppositeDelimiterUpdater >> infiniteModeChangedEvent: anEvent [

	anEvent currentTarget removeEventHandler: self
]

{ #category : #'api - hooks' }
AlbOppositeDelimiterUpdater >> onUninstalledIn: anElement [

	super onUninstalledIn: anElement.
	oppositeDelim ifNotNil: [
		oppositeDelim removeFromParent.
		oppositeDelim := nil ]
]

{ #category : #'opposite delimiter' }
AlbOppositeDelimiterUpdater >> openOppositeDelimiter: oppositeTextElement at: localIdx in: anEditorElement [

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

{ #category : #'event handling' }
AlbOppositeDelimiterUpdater >> subtextElementInvalidateEvent: anEvent [

	self updateOppositeDelimiterIn: anEvent currentTarget.
]

{ #category : #'opposite delimiter' }
AlbOppositeDelimiterUpdater >> updateOppositeDelimiterIn: anEditorElement [

	oppositeDelim ifNotNil: [
		oppositeDelim removeFromParent.
		oppositeDelim := nil ].
	anEditorElement selection ifNotEmpty: [ ^ self ].
	oppositeDelim := self createOppositeDelimiterIn: anEditorElement.
	oppositeDelim ifNotNil: [	anEditorElement addChild: oppositeDelim]
]
