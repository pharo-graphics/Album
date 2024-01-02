Class {
	#name : #AlbPrimarySelectionElementClassChangedEvent,
	#superclass : #BlEvent,
	#category : #'Album-UI'
}

{ #category : #sending }
AlbPrimarySelectionElementClassChangedEvent >> sendTo: anObject [

	anObject primarySelectionElementClassChangedEvent: self
]
