Class {
	#name : #AlbTextEditorLineSegmentPieces,
	#superclass : #Object,
	#instVars : [
		'pieces',
		'pieceElements',
		'textElements',
		'adornmentElements'
	],
	#category : #'Album-Editor-Model - Segment-Text-Line'
}

{ #category : #initialization }
AlbTextEditorLineSegmentPieces >> initialize [
	super initialize.
	
	pieces := OrderedCollection new.
	
	pieceElements := OrderedCollection new.
	textElements := OrderedCollection new.
	adornmentElements := OrderedCollection new
]

{ #category : #accessing }
AlbTextEditorLineSegmentPieces >> pieces: aCollectionOfPieces [
	
]
