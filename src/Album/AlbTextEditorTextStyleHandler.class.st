Class {
	#name : #AlbTextEditorTextStyleHandler,
	#superclass : #AlbTextEditorHandler,
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
