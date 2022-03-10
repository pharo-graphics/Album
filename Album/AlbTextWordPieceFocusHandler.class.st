Class {
	#name : #AlbTextWordPieceFocusHandler,
	#superclass : #AlbTextWordPieceUniqueHandler,
	#category : #'Album-UI-Word'
}

{ #category : #accessing }
AlbTextWordPieceFocusHandler >> eventClass [
	^ BrTextEditorFocusRequest
]

{ #category : #'api - event managing' }
AlbTextWordPieceFocusHandler >> handleEvent: anEvent [
	anEvent currentTarget showCursors
]
