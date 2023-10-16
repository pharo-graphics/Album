Class {
	#name : 'AlbShortcutChangedEvent',
	#superclass : 'BlEvent',
	#instVars : [
		'shortcut'
	],
	#category : 'Album-Model-Events',
	#package : 'Album',
	#tag : 'Model-Events'
}

{ #category : 'accessing' }
AlbShortcutChangedEvent >> shortcut [
	^ shortcut
]

{ #category : 'accessing' }
AlbShortcutChangedEvent >> shortcut: aShortcut [
	shortcut := aShortcut
]
