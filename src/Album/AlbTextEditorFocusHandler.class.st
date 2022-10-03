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

{ #category : #'api - accessing' }
AlbTextEditorFocusHandler >> focusInEvent: anEvent [

	element hasFocus: true
]

{ #category : #'api - accessing' }
AlbTextEditorFocusHandler >> focusOutEvent: anEvent [

	element hasFocus: false
]
