Class {
	#name : #AlbTextEditorModeInstallHandler,
	#superclass : #AlbTextEditorHandler,
	#category : #'Album-UI-Handlers'
}

{ #category : #'api - accessing' }
AlbTextEditorModeInstallHandler >> eventsToHandle [

	^ { 
		  AlbTextEditorModeInstalledEvent.
		  AlbTextEditorModeUninstalledEvent }
]

{ #category : #'event handling' }
AlbTextEditorModeInstallHandler >> modeInstalledEvent: anEvent [

	anEvent mode installOnEditorElement: element
]

{ #category : #'event handling' }
AlbTextEditorModeInstallHandler >> modeUninstalledEvent: anEvent [

	anEvent mode uninstallFromEditorElement: element
]
