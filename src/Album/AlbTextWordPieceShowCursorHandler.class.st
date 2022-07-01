Class {
	#name : #AlbTextWordPieceShowCursorHandler,
	#superclass : #AlbTextWordPieceUniqueHandler,
	#category : #'Album-UI-Word'
}

{ #category : #accessing }
AlbTextWordPieceShowCursorHandler >> eventClass [
	^ AlbTextEditorShowCursorRequest
]

{ #category : #'api - event managing' }
AlbTextWordPieceShowCursorHandler >> handleEvent: anEvent [

	| aCursorElement |
	aCursorElement := anEvent currentTarget addCursorAt: anEvent cursorPosition.
	anEvent editorElement dispatchEvent: (AlbTextEditorCursorElementAddedEvent new cursorElement: aCursorElement).
	anEvent hasFocus
		ifTrue: [ anEvent currentTarget showCursor ]
		ifFalse: [ anEvent currentTarget hideCursor ].
	



]
