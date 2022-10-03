Class {
	#name : #AlbTextEditorShortcutHandler,
	#superclass : #AlbTextEditorToElementHandler,
	#category : #'Album-UI-Handlers'
}

{ #category : #'api - accessing' }
AlbTextEditorShortcutHandler >> eventsToHandle [

	^ { 
		  AlbTextEditorShortcutAddedEvent.
		  AlbTextEditorShortcutRemovedEvent }
]

{ #category : #'event handling' }
AlbTextEditorShortcutHandler >> shortcutAddedEvent: anEvent [

	element removeShortcutsWithCombination: anEvent shortcut combination.
	element addShortcut: anEvent shortcut asShortcut
]

{ #category : #'event handling' }
AlbTextEditorShortcutHandler >> shortcutRemovedEvent: anEvent [

	element removeShortcutsWithCombination: anEvent shortcut combination
]
