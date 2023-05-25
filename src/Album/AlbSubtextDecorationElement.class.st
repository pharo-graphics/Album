Class {
	#name : #AlbSubtextDecorationElement,
	#superclass : #AlbSubtextElement,
	#instVars : [
		'interval'
	],
	#category : #'Album-UI'
}

{ #category : #private }
AlbSubtextDecorationElement >> computedAdjacentRectangles [

	| startIdx endIdx |
	startIdx := self interval first.
	endIdx := self interval last.
	^ Array streamContents: [ :stream | 
		         editorElement
			         textPiecesAndTheirElementsWithinIndexInterval: (startIdx to: endIdx)
			         do: [ :piece :pieceElement | 
				         | first last origin corner bnds |
				         ((piece textStart to: piece textEnd) includesAll: (startIdx to: endIdx))
					         ifTrue: [ 
						         first := startIdx.
						         last := endIdx ]
					         ifFalse: [ 
						         startIdx > piece textStart
							         ifTrue: [ 
								         first := startIdx.
								         last := piece textEnd ]
							         ifFalse: [ 
								         first := piece textStart. 
								         last := endIdx min: piece textEnd ] ].
				         				origin := pieceElement screenOriginAt: first - piece textStart - 1.
				         				corner := pieceElement screenCornerAt: last - piece textStart.
										bnds := BlBounds fromRectangle: (origin corner: corner).
										bnds := (editorElement infinite localBoundsToMine: bnds fromChild: pieceElement).
				         				stream nextPut: bnds ] ]
]

{ #category : #initialization }
AlbSubtextDecorationElement >> initialize [

	super initialize.
	interval := 0 to: 0
]

{ #category : #accessing }
AlbSubtextDecorationElement >> interval [

	^ interval
]

{ #category : #accessing }
AlbSubtextDecorationElement >> interval: anInterval [

	interval := anInterval.
	self updateVertices 
]

{ #category : #initialization }
AlbSubtextDecorationElement >> updateVertices [

	editorElement ifNil: [ ^ self ].
	self adjacentRectangles: self computedAdjacentRectangles
]
