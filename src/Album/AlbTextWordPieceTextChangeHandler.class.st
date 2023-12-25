Class {
	#name : #AlbTextWordPieceTextChangeHandler,
	#superclass : #AlbTextWordPieceUniqueHandler,
	#category : 'Album-UI-Word'
}

{ #category : #accessing }
AlbTextWordPieceTextChangeHandler >> eventClass [
	^ AlbTextEditorTextChangedRequest
]

{ #category : #'api - event managing' }
AlbTextWordPieceTextChangeHandler >> handleEvent: anEvent [
	anEvent currentTarget segmentPiece: anEvent segmentPiece.
	
	
	
]
