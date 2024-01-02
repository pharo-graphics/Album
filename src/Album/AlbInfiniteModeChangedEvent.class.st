Class {
	#name : #AlbInfiniteModeChangedEvent,
	#superclass : #AlbInfiniteEvent,
	#category : #'Album-UI'
}

{ #category : #sending }
AlbInfiniteModeChangedEvent >> sendTo: anObject [

	anObject infiniteModeChangedEvent: self
]
