Class {
	#name : #AlbTextEditorTextStyleHandler,
	#superclass : #AlbTextEditorToElementHandler,
	#category : #'Album-UI-Handlers'
}

{ #category : #'api - accessing' }
AlbTextEditorTextStyleHandler >> eventsToHandle [

	^ { AlbTextEditorTextStyleRequested }
]

{ #category : #'event handling' }
AlbTextEditorTextStyleHandler >> textStyleRequestedEvent: anEvent [

	element launchTextStyle
]
