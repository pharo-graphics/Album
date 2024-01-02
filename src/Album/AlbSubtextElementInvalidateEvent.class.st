Class {
	#name : #AlbSubtextElementInvalidateEvent,
	#superclass : #BlEvent,
	#category : #'Album-UI-Text-Portion'
}

{ #category : #sending }
AlbSubtextElementInvalidateEvent >> sendTo: anObject [

	anObject subtextElementInvalidateEvent: self
]
