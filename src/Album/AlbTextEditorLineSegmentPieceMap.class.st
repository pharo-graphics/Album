Class {
	#name : #AlbTextEditorLineSegmentPieceMap,
	#superclass : #Object,
	#instVars : [
		'map'
	],
	#category : #'Album-Model-Segment-Text-Line'
}

{ #category : #accessing }
AlbTextEditorLineSegmentPieceMap >> allPieces [
	"Return all current line segment pieces"
	<return: #Collection of: #BrTextEditorLineSegmentPiece>
	
	^ map keys
]

{ #category : #accessing }
AlbTextEditorLineSegmentPieceMap >> at: aBrTextEditorLineSegmentPiece pieceAndElementsDo: thePieceAndElementsBlock ifAbsent: anAbsentBlock [
	^ map
		associationAt: aBrTextEditorLineSegmentPiece
		ifPresent: [ :anAssociation | thePieceAndElementsBlock value: anAssociation key value: anAssociation value ]
		ifAbsent: anAbsentBlock
]

{ #category : #accessing }
AlbTextEditorLineSegmentPieceMap >> atPiece: aBrTextEditorLineSegmentPiece putElements: aCollectionOfElements [
	map at: aBrTextEditorLineSegmentPiece put: aCollectionOfElements
]

{ #category : #initialization }
AlbTextEditorLineSegmentPieceMap >> initialize [
	super initialize.
	
	map := IdentityDictionary new
]

{ #category : #accessing }
AlbTextEditorLineSegmentPieceMap >> pieceForElement: aBlElement ifAbsent: anAbsentBlock [
	<return: #BrTextEditorLineSegmentPiece or: #Object>

	map associations do: [ :eachAssociation |
		(eachAssociation value includes: aBlElement) 
			ifTrue: [ ^ eachAssociation key ] ].

	^ anAbsentBlock value
]

{ #category : #accessing }
AlbTextEditorLineSegmentPieceMap >> piecesAndTheirElementsDo: aBlock [
	map associations do: [ :eachAssociation |
		| aPiece thePieceElements |
		aPiece := eachAssociation key.
		thePieceElements := eachAssociation value.
		thePieceElements do: [ :aPieceElement | aBlock value: aPiece value: aPieceElement ] ]
]
