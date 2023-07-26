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
	
	^ map keys
]

{ #category : #accessing }
AlbTextEditorLineSegmentPieceMap >> at: aBrTextEditorLineSegmentPiece pieceAndElementsDo: thePieceAndElementsBlock ifAbsent: anAbsentBlock [

	^ map
		associationAt: aBrTextEditorLineSegmentPiece
		ifPresent: [ :anAssociation |
			thePieceAndElementsBlock
				value: anAssociation key
				value: anAssociation value ]
		ifAbsent: anAbsentBlock
]

{ #category : #accessing }
AlbTextEditorLineSegmentPieceMap >> atPiece: aTextEditorLineSegmentPiece putElements: aCollectionOfElements [

	map at: aTextEditorLineSegmentPiece put: aCollectionOfElements
]

{ #category : #initialization }
AlbTextEditorLineSegmentPieceMap >> initialize [

	super initialize.

	map := Dictionary new
]

{ #category : #accessing }
AlbTextEditorLineSegmentPieceMap >> pieceForElement: aBlElement ifAbsent: anAbsentBlock [
	<return: #AlbTextEditorAbstractSegmentPiece or: #Object>
	map associations do: [ :eachAssociation |
		(eachAssociation value includes: aBlElement) 
			ifTrue: [ ^ eachAssociation key ] ].

	^ anAbsentBlock value
]

{ #category : #accessing }
AlbTextEditorLineSegmentPieceMap >> pieceForElement: aBlElement ifPresent: aBlock ifAbsent: anAbsentBlock [
	<return: #AlbTextEditorAbstractSegmentPiece or: #Object>
	map associations do: [ :eachAssociation |
		(eachAssociation value includes: aBlElement) 
			ifTrue: [ ^ aBlock value: eachAssociation key ] ].

	^ anAbsentBlock value
]

{ #category : #accessing }
AlbTextEditorLineSegmentPieceMap >> piecesAndTheirElementsDo: aBlock [

	map keysAndValuesDo: [ :aPiece :thePieceElements |
		thePieceElements do: [ :aPieceElement |
			aBlock value: aPiece value: aPieceElement ] ]
]
