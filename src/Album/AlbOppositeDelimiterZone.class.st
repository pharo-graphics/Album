Class {
	#name : #AlbOppositeDelimiterZone,
	#superclass : #AlbVisualZone,
	#instVars : [
		'previousCursorPosition'
	],
	#category : #'Album-UI'
}

{ #category : #sparta }
AlbOppositeDelimiterZone >> drawFrom: anElement onSpartaCanvas: aCanvas [

	self zone ifNil: [ ^ self ].
	aCanvas figure
		path: (self zone asRectangle expandBy: (Margin
						  left: 2
						  right: 2
						  top: 0
						  bottom: 6));
		background: Color yellow;
		backgroundAlpha: 0.2;
		border: Color yellow;
		borderAlpha: 1.0;
		width: 1;
		in: [ :aPainter | aPainter borderOutside ];
		draw.

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
