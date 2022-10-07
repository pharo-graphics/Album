Class {
	#name : #AlbCursorBlinkAnimation,
	#superclass : #BlAnimation,
	#instVars : [
		'lastTime',
		'targetPaint'
	],
	#category : #'Album-UI-Stencils'
}

{ #category : #pulse }
AlbCursorBlinkAnimation >> applyValue: aValue [

	aValue ifNil: [ ^ self ].
	self target background: aValue asBlBackground
]

{ #category : #initialization }
AlbCursorBlinkAnimation >> defaultBlinkingDelay [

	"in ms"

	^ 500
]

{ #category : #initialization }
AlbCursorBlinkAnimation >> initialize [ 
	super initialize.
	lastTime := DateAndTime now.
	self beInfinite 
]

{ #category : #starting }
AlbCursorBlinkAnimation >> restart [

	lastTime := DateAndTime now.
	self target background: targetPaint asBlBackground
]

{ #category : #accessing }
AlbCursorBlinkAnimation >> target: aBlElement [

	super target: aBlElement.
	targetPaint := self target background paint
]

{ #category : #pulse }
AlbCursorBlinkAnimation >> valueForStep: aDelta [

	| now |
	self target parent ifNil: [ ^ nil ].
	now := DateAndTime now.
	(now - lastTime) asMilliSeconds >= self defaultBlinkingDelay ifFalse: [ ^ nil ].
	lastTime := now.
	^ self target background paint = targetPaint
		  ifTrue: [ Color transparent ]
		  ifFalse: [ targetPaint ]
]
