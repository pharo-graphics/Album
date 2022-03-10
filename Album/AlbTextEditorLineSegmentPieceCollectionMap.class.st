Class {
	#name : #AlbTextEditorLineSegmentPieceCollectionMap,
	#superclass : #AlbTextEditorLineSegmentPieceMap,
	#instVars : [
		'map'
	],
	#category : #'Album-Model-Segment-Text-Line'
}

{ #category : #accessing }
AlbTextEditorLineSegmentPieceCollectionMap >> allPieces [
	"Return all current line segment pieces"
	<return: #Collection of: #BrTextEditorLineSegmentPiece>

	^ map collect: [ :eachAssociation | eachAssociation key ]
]

{ #category : #accessing }
AlbTextEditorLineSegmentPieceCollectionMap >> at: aBrTextEditorLineSegmentPiece pieceAndElementsDo: thePieceAndElementsBlock ifAbsent: anAbsentBlock [
	^ map
		detect: [ :eachAssociation | eachAssociation key = aBrTextEditorLineSegmentPiece ]
		ifFound: [ :eachAssociation | thePieceAndElementsBlock value: eachAssociation key value: eachAssociation value ]
		ifNone: anAbsentBlock
]

{ #category : #accessing }
AlbTextEditorLineSegmentPieceCollectionMap >> atPiece: aBrTextEditorLineSegmentPiece putElements: aCollectionOfElements [
	map add: (aBrTextEditorLineSegmentPiece -> aCollectionOfElements)
]

{ #category : #initialization }
AlbTextEditorLineSegmentPieceCollectionMap >> initialize [
	super initialize.
	
	map := OrderedCollection new.
]

{ #category : #accessing }
AlbTextEditorLineSegmentPieceCollectionMap >> pieceForElement: aBlElement ifAbsent: anAbsentBlock [
	map do: [ :eachAssociation |
		(eachAssociation value includes: aBlElement) 
			ifTrue: [ ^ eachAssociation key ] ].
	^ anAbsentBlock value
]

{ #category : #accessing }
AlbTextEditorLineSegmentPieceCollectionMap >> piecesAndTheirElementsDo: aBlock [
	map do: [ :eachAssociation |
		| aPiece thePieceElements |
		aPiece := eachAssociation key.
		thePieceElements := eachAssociation value.
		thePieceElements do: [ :aPieceElement | aBlock value: aPiece value: aPieceElement ] ]
]
