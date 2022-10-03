Class {
	#name : #AlbTextEditorShortcutAddedEvent,
	#superclass : #AlbTextEditorShortcutChangedEvent,
	#category : #'Album-Model-Events'
}

{ #category : #sending }
AlbTextEditorShortcutAddedEvent >> sendTo: anEventHandler [

	anEventHandler shortcutAddedEvent: self
]
