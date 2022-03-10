Class {
	#name : #AlbTextEditorLineSegmentPieceMap,
	#superclass : #Object,
	#category : #'Album-Editor-Model - Segment-Text-Line'
}

{ #category : #accessing }
AlbTextEditorLineSegmentPieceMap >> allPieces [
	"Return all current line segment pieces"
	<return: #Collection of: #BrTextEditorLineSegmentPiece>
	
	^ self subclassResponsibility
]

{ #category : #accessing }
AlbTextEditorLineSegmentPieceMap >> at: aBrTextEditorLineSegmentPiece pieceAndElementsDo: thePieceAndElementsBlock ifAbsent: anAbsentBlock [
	^ self subclassResponsibility
]

{ #category : #accessing }
AlbTextEditorLineSegmentPieceMap >> atPiece: aBrTextEditorLineSegmentPiece putElements: aCollectionOfElements [
	self subclassResponsibility
]

{ #category : #accessing }
AlbTextEditorLineSegmentPieceMap >> pieceForElement: aBlElement ifAbsent: anAbsentBlock [
	<return: #BrTextEditorLineSegmentPiece or: #Object>
	
	^ self subclassResponsibility
]

{ #category : #accessing }
AlbTextEditorLineSegmentPieceMap >> piecesAndTheirElementsDo: aBlock [
	self subclassResponsibility
]
