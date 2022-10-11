Class {
	#name : #AlbTextEditorModeUninstalledEvent,
	#superclass : #AlbTextEditorModeChangedEvent,
	#category : #'Album-Brick-NU-Album-Model-Events'
}

{ #category : #sending }
AlbTextEditorModeUninstalledEvent >> sendTo: anEventHandler [

	anEventHandler modeUninstalledEvent: self
]
