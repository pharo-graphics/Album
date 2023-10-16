Class {
	#name : 'AlbShortcutRemovedEvent',
	#superclass : 'AlbShortcutChangedEvent',
	#category : 'Album-Model-Events',
	#package : 'Album',
	#tag : 'Model-Events'
}

{ #category : 'sending' }
AlbShortcutRemovedEvent >> sendTo: anEventHandler [

	anEventHandler shortcutRemovedEvent: self
]
