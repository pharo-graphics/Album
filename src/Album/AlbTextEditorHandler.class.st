Class {
	#name : #AlbTextEditorHandler,
	#superclass : #AlbEditorElementHandler,
	#category : #'Album-UI-Handlers'
}

{ #category : #'api - accessing' }
AlbTextEditorHandler >> eventsToHandle [

	^ { 
		  AlbShortcutAddedEvent.
		  AlbShortcutRemovedEvent.
		  AlbTextReplacedEvent.
		  AlbTextModifiedEvent }
]

{ #category : #'event handling' }
AlbTextEditorHandler >> shortcutAddedEvent: anEvent [

	element removeShortcutsWithCombination: anEvent shortcut combination.
	element addShortcut: anEvent shortcut asShortcut
]

{ #category : #'event handling' }
AlbTextEditorHandler >> shortcutRemovedEvent: anEvent [

	element removeShortcutsWithCombination: anEvent shortcut combination
]

{ #category : #'event handling' }
AlbTextEditorHandler >> textModifiedEvent: anEvent [

	element textModified
]

{ #category : #'event handling' }
AlbTextEditorHandler >> textReplacedEvent: anEvent [

	element text: anEvent text
]
