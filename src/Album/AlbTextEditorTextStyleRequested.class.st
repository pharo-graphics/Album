Class {
	#name : #AlbTextEditorTextStyleRequested,
	#superclass : #AlbTextEditorEvent,
	#category : #'Album-Model-Events'
}

{ #category : #sending }
AlbTextEditorTextStyleRequested >> sendTo: anEventHandler [

	anEventHandler textStyleRequestedEvent: self
]
