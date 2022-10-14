Class {
	#name : #AlbumLayer,
	#superclass : #BlOverlayElement,
	#instVars : [
		'delegator'
	],
	#category : #'Album-UI'
}

{ #category : #'api - attaching / detaching' }
AlbumLayer >> attachTo: anElement [

	super attachTo: anElement.
	delegator := BlEventDelegator delegate: BlEvent to: anElement. 
	self addEventHandler: delegator
]

{ #category : #'api - attaching / detaching' }
AlbumLayer >> detach [

	self removeEventHandler: delegator.
	delegator := nil.
	super detach
]
