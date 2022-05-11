Class {
	#name : #AlbCursorStencil,
	#superclass : #OblStencil,
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
	^ AlbCursorElement new
		constraintsDo: [ :c |
			c horizontal exact: 2.
			c vertical matchParent ];
		background: Color black
]
