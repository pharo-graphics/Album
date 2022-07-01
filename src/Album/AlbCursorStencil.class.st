Class {
	#name : #AlbCursorStencil,
	#superclass : #OBlStencil,
	#instVars : [
		'blinking'
	],
	#classInstVars : [
		'uniqueInstance'
	],
	#category : #'Album-UI-Stencils'
}

{ #category : #accessing }
AlbCursorStencil class >> cleanUp [
	super cleanUp.
	
	uniqueInstance := nil
]

{ #category : #accessing }
AlbCursorStencil class >> uniqueInstance [
	^ uniqueInstance ifNil: [ uniqueInstance := self new ]
]

{ #category : #accessing }
AlbCursorStencil >> beBlinking: aBoolean [

	blinking := aBoolean
]

{ #category : #accessing }
AlbCursorStencil >> blinking: anObject [

	blinking := anObject
]

{ #category : #'api - instantiation' }
AlbCursorStencil >> create [
	| e |
	e := AlbCursorElement new
		constraintsDo: [ :c |
			c horizontal exact: 2.
			c vertical matchParent ];
		background: Color red;
		yourself.
	blinking ifTrue: [e addAnimation: AlbBlinkAnimation new].
	^ e
]

{ #category : #initialization }
AlbCursorStencil >> initialize [
	super initialize.
	blinking := false
]
