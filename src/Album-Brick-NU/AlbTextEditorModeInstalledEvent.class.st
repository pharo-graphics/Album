Class {
	#name : #AlbTextEditorModeInstalledEvent,
	#superclass : #AlbTextEditorModeChangedEvent,
	#category : #'Album-Brick-NU-Album-Model-Events'
}

{ #category : #sending }
AlbTextEditorModeInstalledEvent >> sendTo: anEventHandler [

	anEventHandler modeInstalledEvent: self
]
