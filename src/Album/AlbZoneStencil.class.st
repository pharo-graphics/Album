Class {
	#name : #AlbZoneStencil,
	#superclass : #OBlStencil,
	#classInstVars : [
		'uniqueInstance'
	],
	#category : #'Album-UI-Stencils'
}

{ #category : #accessing }
AlbZoneStencil class >> cleanUp [
	super cleanUp.
	
	uniqueInstance := nil
]

{ #category : #accessing }
AlbZoneStencil class >> uniqueInstance [
	^ uniqueInstance ifNil: [ uniqueInstance := self new ]
]

{ #category : #'api - instantiation' }
AlbZoneStencil >> create [
	| e |
	e := AlbVisualZone new
		background: (Color red alpha: 0.3);
		yourself.
	^ e
]

{ #category : #initialization }
AlbZoneStencil >> initialize [
	super initialize.

]
