Class {
	#name : #AlbTextWordPieceFocusHandler,
	#superclass : #AlbTextWordPieceUniqueHandler,
	#category : #'Album-UI-Word'
}

{ #category : #accessing }
AlbTextWordPieceFocusHandler >> eventClass [
	^ AlbTextEditorFocusRequest
]

{ #category : #'api - event managing' }
AlbTextWordPieceFocusHandler >> handleEvent: anEvent [
	anEvent currentTarget showCursors
]
