Class {
	#name : #AlbTextEditorShortcutRemovedEvent,
	#superclass : #AlbTextEditorShortcutChangedEvent,
	#category : #'Album-Model-Events'
}

{ #category : #sending }
AlbTextEditorShortcutRemovedEvent >> sendTo: anEventHandler [

	anEventHandler shortcutRemovedEvent: self
]
