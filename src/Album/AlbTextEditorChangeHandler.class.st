Class {
	#name : #AlbTextEditorChangeHandler,
	#superclass : #AlbTextEditorToElementHandler,
	#category : #'Album-UI-Handlers'
}

{ #category : #'api - accessing' }
AlbTextEditorChangeHandler >> eventsToHandle [
	^ {
		AlbEditorTextChangedEvent.
		AlbEditorStylerChangedEvent.
		AlbEditorModeChangedEvent.
	}
]

{ #category : #'event handling' }
AlbTextEditorChangeHandler >> modeChangedEvent: anEvent [

	element modeChanged: anEvent mode
]

{ #category : #'event handling' }
AlbTextEditorChangeHandler >> stylerChangedEvent: anEvent [

	element stylerChanged: anEvent styler
]

{ #category : #'event handling' }
AlbTextEditorChangeHandler >> textChangedEvent: anEvent [

	element textChanged: anEvent text
]
