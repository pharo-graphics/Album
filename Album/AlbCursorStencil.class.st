Class {
	#name : #AlbCursorStencil,
	#superclass : #BrStencil,
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

{ #category : #'api - instantiation' }
AlbCursorStencil >> create [
	^ BrCursorElement new
		constraintsDo: [ :c |
			c horizontal exact: 1.
			c vertical matchParent ];
		background: Color black
]
