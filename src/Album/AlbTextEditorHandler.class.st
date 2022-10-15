Class {
	#name : #AlbTextEditorHandler,
	#superclass : #AlbEditorElementHandler,
	#category : #'Album-UI-Handlers'
}

{ #category : #'api - accessing' }
AlbTextEditorHandler >> eventsToHandle [

	^ { 
		  AlbTextEditorShortcutAddedEvent.
		  AlbTextEditorShortcutRemovedEvent.
		  AlbTextEditorTextReplacedEvent.
		  AlbTextEditorTextStyleRequested.
		  AlbTextEditorTextSaveRequested.
		  AlbTextEditorTextStyledEvent }
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
AlbTextEditorHandler >> textReplacedEvent: anEvent [
	element text: anEvent text
]

{ #category : #'event handling' }
AlbTextEditorHandler >> textSaveRequestedEvent: anEvent [

	element textSaveRequested
]

{ #category : #'event handling' }
AlbTextEditorHandler >> textStyleRequestedEvent: anEvent [

	element launchTextStyle
]

{ #category : #'event handling' }
AlbTextEditorHandler >> textStyledEvent: anEvent [

	element textStyled: anEvent styledText
]
