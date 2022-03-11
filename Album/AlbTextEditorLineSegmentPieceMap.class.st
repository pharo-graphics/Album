Class {
	#name : #AlbTextEditorLineSegmentPieceMap,
	#superclass : #Object,
	#category : #'Album-Model-Segment-Text-Line'
}

{ #category : #accessing }
AlbTextEditorLineSegmentPieceMap >> allPieces [
	"Return all current line segment pieces"
	<return: #Collection of: #AlbTextEditorLineSegmentPiece>
	
	^ self subclassResponsibility
]

{ #category : #accessing }
AlbTextEditorLineSegmentPieceMap >> at: aTextEditorLineSegmentPiece pieceAndElementsDo: thePieceAndElementsBlock ifAbsent: anAbsentBlock [
	^ self subclassResponsibility
]

{ #category : #accessing }
AlbTextEditorLineSegmentPieceMap >> atPiece: aTextEditorLineSegmentPiece putElements: aCollectionOfElements [
	self subclassResponsibility
]

{ #category : #accessing }
AlbTextEditorLineSegmentPieceMap >> pieceForElement: aBlElement ifAbsent: anAbsentBlock [
	<return: #AlbTextEditorLineSegmentPiece or: #Object>
	
	^ self subclassResponsibility
]

{ #category : #accessing }
AlbTextEditorLineSegmentPieceMap >> piecesAndTheirElementsDo: aBlock [
	self subclassResponsibility
]
