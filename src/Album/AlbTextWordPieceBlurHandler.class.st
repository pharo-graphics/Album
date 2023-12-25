Class {
	#name : #AlbTextWordPieceBlurHandler,
	#superclass : #AlbTextWordPieceUniqueHandler,
	#category : 'Album-UI-Word'
}

{ #category : #'api - event managing' }
AlbTextWordPieceBlurHandler >> eventClass [
	^ AlbTextEditorBlurRequest
]

{ #category : #'api - event managing' }
AlbTextWordPieceBlurHandler >> handleEvent: anEvent [
	anEvent currentTarget hideCursor
]
