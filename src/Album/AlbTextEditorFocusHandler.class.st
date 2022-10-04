Class {
	#name : #AlbTextEditorFocusHandler,
	#superclass : #AlbTextEditorToElementHandler,
	#category : #'Album-UI-Handlers'
}

{ #category : #'api - accessing' }
AlbTextEditorFocusHandler >> eventsToHandle [

	^ { 
		  BlFocusInEvent.
		  BlFocusOutEvent }
]

{ #category : #'event handling' }
AlbTextEditorFocusHandler >> focusInEvent: anEvent [

	element hasFocus: true
]

{ #category : #'event handling' }
AlbTextEditorFocusHandler >> focusOutEvent: anEvent [

	element hasFocus: false
]
