Class {
	#name : #AlbTextEditorShortcutChangedEvent,
	#superclass : #AlbTextEditorEvent,
	#instVars : [
		'shortcut'
	],
	#category : #'Album-Model-Events'
}

{ #category : #accessing }
AlbTextEditorShortcutChangedEvent >> shortcut [
	^ shortcut
]

{ #category : #accessing }
AlbTextEditorShortcutChangedEvent >> shortcut: aShortcut [
	shortcut := aShortcut
]
