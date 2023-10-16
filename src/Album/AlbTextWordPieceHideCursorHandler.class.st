Class {
	#name : 'AlbTextWordPieceHideCursorHandler',
	#superclass : 'AlbTextWordPieceUniqueHandler',
	#category : 'Album-UI-Word',
	#package : 'Album',
	#tag : 'UI-Word'
}

{ #category : 'accessing' }
AlbTextWordPieceHideCursorHandler >> eventClass [
	^ AlbTextEditorHideCursorRequest
]

{ #category : 'api - event managing' }
AlbTextWordPieceHideCursorHandler >> handleEvent: anEvent [
	| aTextElement aCursorElement |
	
	aTextElement := anEvent currentTarget.
	
	(aTextElement hasCursorAt: anEvent cursorPosition)
		ifFalse: [ ^ self ].

	aCursorElement := aTextElement removeCursorAt: anEvent cursorPosition
]
