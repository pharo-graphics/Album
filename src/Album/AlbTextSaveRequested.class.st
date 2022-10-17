Class {
	#name : #AlbTextSaveRequested,
	#superclass : #BlEvent,
	#category : #'Album-Model-Events'
}

{ #category : #sending }
AlbTextSaveRequested >> sendTo: anEventHandler [

	anEventHandler textSaveRequestedEvent: self
]
