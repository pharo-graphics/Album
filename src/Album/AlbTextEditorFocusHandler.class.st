Class {
	#name : #AlbTextEditorFocusHandler,
	#superclass : #AlbEditorElementHandler,
	#category : 'Album-UI-Handlers'
}

{ #category : #'event handling' }
AlbTextEditorFocusHandler >> blurEvent: anEvent [

	element onLostFocus
]

{ #category : #'api - accessing' }
AlbTextEditorFocusHandler >> eventsToHandle [

	^ { 
		  BlFocusEvent.
		  BlBlurEvent }
]

{ #category : #'event handling' }
AlbTextEditorFocusHandler >> focusEvent: anEvent [

	element onGotFocus
]
