Class {
	#name : #AlbOppositeDelimiterZone,
	#superclass : #AlbVisualZone,
	#instVars : [
		'previousCursorPosition'
	],
	#category : #'Album-UI'
}

{ #category : #sparta }
AlbOppositeDelimiterZone >> drawOnSpartaCanvas: aSpartaCanvas in: anInfiniteElement [

	
]

{ #category : #sparta }
AlbOppositeDelimiterZone >> drawOnSpartaCanvasOver: aSpartaCanvas in: anInfiniteElement [

	self zone ifNil: [ ^ self ].
	anInfiniteElement selection isEmpty ifFalse: [ ^ self ].

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
		"in: [ :aPainter | aPainter borderOutside ];"draw
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

	previousCursorPosition = globalCursorPos ifTrue: [ ^ self ].
	" check on the actual cached subtex and use the global cursor "
	subtext := anEditor editor segmentCollector subText.
	anEditor editor limitedSurroundMap
		intervalBetweenDelimitersIn: subtext
		at: globalCursorPos
		ifPresent: [ :interval | 
			interval first = globalCursorPos ifFalse: [ 
				anEditor
					atTextIndex: interval first + subtext start - 1
					do: [ :opposite :localIdx | 
						localIdx isZero ifFalse: [ 
							previousCursorPosition := globalCursorPos.
							^ self zone: (opposite characterBoundsAtIndex: localIdx) ] ] ].
			interval last = globalCursorPos ifFalse: [ 
				anEditor
					atTextIndex: interval last + subtext start
					do: [ :opposite :localIdx | 
						localIdx isZero ifFalse: [ 
							previousCursorPosition := globalCursorPos.
							^ self zone: (opposite characterBoundsAtIndex: localIdx) ] ] ] ]
		ifAbsent: [  ].
	previousCursorPosition := globalCursorPos.
	self zone: nil
]
