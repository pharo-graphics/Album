Class {
	#name : #AlbTextEditorTextReplaceHandler,
	#superclass : #AlbTextEditorHandler,
	#category : #'Album-UI-Handlers'
}

{ #category : #'api - accessing' }
AlbTextEditorTextReplaceHandler >> eventsToHandle [

	^ { AlbTextEditorTextReplacedEvent }
]

{ #category : #'event handling' }
AlbTextEditorTextReplaceHandler >> textReplacedEvent: anEvent [
	element viewModel text: anEvent text
]
