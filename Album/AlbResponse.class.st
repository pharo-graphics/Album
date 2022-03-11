Class {
	#name : #AlbResponse,
	#superclass : #BlEvent,
	#category : #'Album-Brick-Core-Events'
}

{ #category : #initialization }
AlbResponse >> reply: anObject [
	self subclassResponsibility
]
