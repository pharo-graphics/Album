Class {
	#name : #AlbCursorElement,
	#superclass : #OBlElement,
	#instVars : [
		'textPosition',
		'blinking',
		'blinkTask'
	],
	#category : #'Album-UI'
}

{ #category : #accessing }
AlbCursorElement >> beBlinking: aBoolean [

	blinking := aBoolean
]

{ #category : #initialization }
AlbCursorElement >> defaultBackground [

	^ Color red 
]

{ #category : #initialization }
AlbCursorElement >> defaultBlinking [

	^ true
]

{ #category : #initialization }
AlbCursorElement >> defaultBlurredBackground [

	^ Color brown 
]

{ #category : #initialization }
AlbCursorElement >> initialize [

	super initialize.
	
	self background: self defaultBackground.
	textPosition := 0.
	self beBlinking: self defaultBlinking.
	self focusability: BlFocusability none.
	self elevation: (BlRelativeElevation elevation: SmallInteger maxVal).
	self preventMouseEvents.
	self constraintsDo: [ :c | 
		c horizontal exact: 2.
		c vertical matchParent ]
]

{ #category : #initialization }
AlbCursorElement >> newBlinkingTask [

	^ AlbCursorBlinkingTask new cursor: self
]

{ #category : #'private - focus' }
AlbCursorElement >> onGotFocus [

	self background: self defaultBackground.
	self startBlinkingTask 
	 
]

{ #category : #'private - focus' }
AlbCursorElement >> onLostFocus [

	self background: self defaultBlurredBackground.
	self stopBlinkingTask 
]

{ #category : #initialization }
AlbCursorElement >> startBlinkingTask [

	self stopBlinkingTask.
	
	blinking ifFalse: [ ^ self ].

	self enqueueTask: (blinkTask := self newBlinkingTask)
]

{ #category : #initialization }
AlbCursorElement >> stopBlinkingTask [

	blinkTask ifNotNil: [ 
		blinkTask stop.
		self dequeueTask: blinkTask ].


]

{ #category : #accessing }
AlbCursorElement >> textPosition [
	^ textPosition
]

{ #category : #accessing }
AlbCursorElement >> textPosition: anInteger [

	textPosition := anInteger
]
