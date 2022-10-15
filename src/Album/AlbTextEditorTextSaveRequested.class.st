Class {
	#name : #AlbTextEditorTextSaveRequested,
	#superclass : #AlbTextEditorEvent,
	#category : #'Album-Model-Events'
}

{ #category : #sending }
AlbTextEditorTextSaveRequested >> sendTo: anEventHandler [

	anEventHandler textSaveRequestedEvent: self
]
