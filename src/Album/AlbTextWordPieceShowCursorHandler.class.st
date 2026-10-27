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

	anEvent currentTarget
		addCursorAt: anEvent cursorPosition
		inEditorElement: anEvent editorElement
		primary: anEvent isPrimary.
	(anEvent hasFocus and: [ anEvent editorElement selection isEmpty ])
		ifTrue: [ anEvent currentTarget showCursor ]
		ifFalse: [ anEvent currentTarget hideCursor ]
]
