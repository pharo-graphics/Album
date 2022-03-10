Class {
	#name : #AlbTextWordPieceDeselectionHandler,
	#superclass : #AlbTextWordPieceUniqueHandler,
	#category : #'Album-UI-Word'
}

{ #category : #accessing }
AlbTextWordPieceDeselectionHandler >> eventClass [
	^ BrTextEditorDeselectRequest
]

{ #category : #'api - event managing' }
AlbTextWordPieceDeselectionHandler >> handleEvent: anEvent [
	anEvent currentTarget selectNone
]
