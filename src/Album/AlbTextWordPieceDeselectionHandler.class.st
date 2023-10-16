Class {
	#name : 'AlbTextWordPieceDeselectionHandler',
	#superclass : 'AlbTextWordPieceUniqueHandler',
	#category : 'Album-UI-Word',
	#package : 'Album',
	#tag : 'UI-Word'
}

{ #category : 'accessing' }
AlbTextWordPieceDeselectionHandler >> eventClass [
	^ AlbTextEditorDeselectRequest
]

{ #category : 'api - event managing' }
AlbTextWordPieceDeselectionHandler >> handleEvent: anEvent [
	anEvent currentTarget selectNone
]
