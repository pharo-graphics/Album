Class {
	#name : #AlbShortcutAddedEvent,
	#superclass : #AlbShortcutChangedEvent,
	#category : #'Album-Model-Events'
}

{ #category : #sending }
AlbShortcutAddedEvent >> sendTo: anEventHandler [

	anEventHandler shortcutAddedEvent: self
]
