Class {
	#name : #AlbTextEditorLineSegmentPieceDictionaryMap,
	#superclass : #AlbTextEditorLineSegmentPieceMap,
	#instVars : [
		'map'
	],
	#category : #'Album-Model-Segment-Text-Line'
}

{ #category : #accessing }
AlbTextEditorLineSegmentPieceDictionaryMap >> allPieces [
	"Return all current line segment pieces"
	<return: #Collection of: #AlbTextEditorLineSegmentPiece>
	
	^ map keys
]

{ #category : #accessing }
AlbTextEditorLineSegmentPieceDictionaryMap >> at: aTextEditorLineSegmentPiece pieceAndElementsDo: thePieceAndElementsBlock ifAbsent: anAbsentBlock [
	^ map
		associationAt: aTextEditorLineSegmentPiece
		ifPresent: [ :anAssociation | thePieceAndElementsBlock value: anAssociation key value: anAssociation value ]
		ifAbsent: anAbsentBlock
]

{ #category : #accessing }
AlbTextEditorLineSegmentPieceDictionaryMap >> atPiece: aTextEditorLineSegmentPiece putElements: aCollectionOfElements [
	map at: aTextEditorLineSegmentPiece put: aCollectionOfElements
]

{ #category : #initialization }
AlbTextEditorLineSegmentPieceDictionaryMap >> initialize [
	super initialize.
	
	map := OrderedDictionary new
]

{ #category : #accessing }
AlbTextEditorLineSegmentPieceDictionaryMap >> pieceForElement: aBlElement ifAbsent: anAbsentBlock [
	<return: #AlbTextEditorLineSegmentPiece or: #Object>

	map associations do: [ :eachAssociation |
		(eachAssociation value includes: aBlElement) 
			ifTrue: [ ^ eachAssociation key ] ].

	^ anAbsentBlock value
]

{ #category : #accessing }
AlbTextEditorLineSegmentPieceDictionaryMap >> piecesAndTheirElementsDo: aBlock [
	map associations do: [ :eachAssociation |
		| aPiece thePieceElements |
		aPiece := eachAssociation key.
		thePieceElements := eachAssociation value.
		thePieceElements do: [ :aPieceElement | aBlock value: aPiece value: aPieceElement ] ]
]
