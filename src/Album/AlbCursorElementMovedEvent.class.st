Class {
	#name : #AlbCursorElementMovedEvent,
	#superclass : #BlEvent,
	#category : #'Album-UI'
}

{ #category : #sending }
AlbCursorElementMovedEvent >> sendTo: anObject [

	anObject cursorElementMovedEvent: self
]
