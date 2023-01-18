Class {
	#name : #AlbRemanentUpdateRequest,
	#superclass : #BlEvent,
	#category : #'Album-UI-Requests'
}

{ #category : #sending }
AlbRemanentUpdateRequest >> sendTo: anHandler [

	anHandler remanentUpdateRequest: self
]
