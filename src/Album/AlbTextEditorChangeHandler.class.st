Class {
	#name : #AlbTextEditorChangeHandler,
	#superclass : #AlbTextEditorHandler,
	#category : #'Album-UI-Handlers'
}

{ #category : #'api - accessing' }
AlbTextEditorChangeHandler >> eventsToHandle [
	^ {
		AlbEditorTextChangedEvent.
		AlbEditorStylerChangedEvent.
		AlbEditorTextStyledEvent.
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

{ #category : #'event handling' }
AlbTextEditorChangeHandler >> textStyledEvent: anEvent [

	element editor textStyled: anEvent text
]
