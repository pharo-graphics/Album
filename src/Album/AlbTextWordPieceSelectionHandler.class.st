Class {
	#name : #AlbTextWordPieceSelectionHandler,
	#superclass : #AlbTextWordPieceUniqueHandler,
	#category : #'Album-UI-Word'
}

{ #category : #accessing }
AlbTextWordPieceSelectionHandler >> eventClass [
	^ AlbTextEditorSelectRequest
]

{ #category : #'api - event managing' }
AlbTextWordPieceSelectionHandler >> handleEvent: anEvent [
	anEvent currentTarget select: anEvent fromIndex to: anEvent toIndex
]
