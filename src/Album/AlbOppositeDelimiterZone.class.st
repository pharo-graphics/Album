Class {
	#name : #AlbOppositeDelimiterZone,
	#superclass : #AlbVisualZone,
	#instVars : [
		'previousCursorPosition'
	],
	#category : #'Album-UI'
}

{ #category : #sparta }
AlbOppositeDelimiterZone >> drawOnSpartaCanvasOver: aSpartaCanvas in: anInfiniteElement [
	"self updateFrom: anInfiniteElement.
	
	self zone ifNil: [ ^ self ].
	""anInfiniteElement selection isEmpty ifFalse: [ ^ self ].""

	aSpartaCanvas figure
		path: (self zone asRectangle expandBy: (Margin
						  left: 1
						  right: 1
						  top: 0
						  bottom: 0));
		background: self frameColor;
		backgroundAlpha: 0.4;
		border: self frameColor;
		borderAlpha: 1.0;
		width: 1;
		draw"
]

{ #category : #sparta }
AlbOppositeDelimiterZone >> frameColor [

	^ AlbCursorSelectionZone selectionColor
]

{ #category : #updating }
AlbOppositeDelimiterZone >> updateFrom: anEditor [

	| globalCursorPos subtext |
	globalCursorPos := anEditor cursor position.
	globalCursorPos isZero ifTrue: [ ^ self ].
self zone: nil.
	"previousCursorPosition = globalCursorPos ifTrue: [ ^ self ]."
	" check on the actual cached subtex and use the global cursor "
	subtext := anEditor textOnScreen.
	anEditor editor limitedSurroundMap
		intervalBetweenDelimitersIn: subtext
		at: globalCursorPos
		ifPresent: [ :interval | 
			interval first = globalCursorPos ifFalse: [ 
				anEditor
					atTextIndex: interval first + subtext start - 1
					do: [ :opposite :localIdx | 
						localIdx isZero ifFalse: [ 
							(anEditor text from: interval first + subtext start + localIdx  to: interval first + subtext start + localIdx +1) attribute: (BlTextHighlightAttribute paint: Color orange).
							^ self ] ] ].
			interval last = globalCursorPos ifFalse: [ 
				anEditor
					atTextIndex: interval last + subtext start
					do: [ :opposite :localIdx | 
						localIdx isZero ifFalse: [ 
							(anEditor text from: interval last + subtext start + localIdx -1 to: interval last + subtext start + localIdx) attribute: (BlTextHighlightAttribute paint: Color orange).
							^ self ] ] ] ]
		ifAbsent: [  ].
	previousCursorPosition := globalCursorPos.
	self zone: nil
]
