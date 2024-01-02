Class {
	#name : #AlbSubtextElementEventHandler,
	#superclass : #BlCustomEventHandler,
	#category : #'Album-UI-Text-Portion'
}

{ #category : #'api - accessing' }
AlbSubtextElementEventHandler >> eventsToHandle [

	^  { AlbSubtextElementInvalidateEvent }
]

{ #category : #'event handling' }
AlbSubtextElementEventHandler >> subtextElementInvalidateEvent: anEvent [

	anEvent currentTarget updateVertices
]
