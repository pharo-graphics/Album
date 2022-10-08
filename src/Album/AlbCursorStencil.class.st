Class {
	#name : #AlbCursorStencil,
	#superclass : #OBlStencil,
	#instVars : [
		'blinking',
		'current',
		'animation'
	],
	#category : #'Album-UI-Stencils'
}

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

	"Pay attention: a CursorElement ** must be a singleton **. 
	If not, dbl clicking will not work"

	current ifNotNil: [ 
		animation ifNotNil: [ animation restart ].
		^ current ].
	current := AlbCursorElement new
		           constraintsDo: [ :c | 
			           c horizontal exact: 2.
			           c vertical matchParent ];
		           border: (BlBorder paint: Color red width: 0);
		           outskirts: BlOutskirts centered;
		           background: (Color red alpha: 0.5);
		           yourself.
	blinking ifTrue: [ 
		current addAnimation: (animation := AlbCursorBlinkAnimation new) ].
	^ current
]

{ #category : #initialization }
AlbCursorStencil >> initialize [
	super initialize.
	blinking := true
]
