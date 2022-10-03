Class {
	#name : #AlbTextEditorModeHandler,
	#superclass : #AlbTextEditorToElementHandler,
	#category : #'Album-UI-Handlers'
}

{ #category : #'api - accessing' }
AlbTextEditorModeHandler >> eventsToHandle [

	^ { 
		  AlbTextEditorModeInstalledEvent.
		  AlbTextEditorModeUninstalledEvent }
]

{ #category : #'event handling' }
AlbTextEditorModeHandler >> modeInstalledEvent: anEvent [

	anEvent mode installOnEditorElement: element
]

{ #category : #'event handling' }
AlbTextEditorModeHandler >> modeUninstalledEvent: anEvent [

	anEvent mode uninstallFromEditorElement: element
]
