Class {
	#name : #AlbSubtextDecorationBuilder,
	#superclass : #Object,
	#instVars : [
		'subtext',
		'fullText',
		'parentElement',
		'decorations'
	],
	#category : #'Album-UI'
}

{ #category : #building }
AlbSubtextDecorationBuilder >> createDecorations [

	| collector founds |
	subtext ifNil: [ ^ self ].
	subtext ifEmpty: [ ^ self ].
	collector := BlIntervalCollector new text: fullText asString.
	founds := collector searchAll: subtext asString.
	founds do: [ :interval | self decorationInterval: interval + fullText textOffset ]
]

{ #category : #private }
AlbSubtextDecorationBuilder >> decorationInterval: anInterval [

	| startIdx endIdx rects rem selInterval |
	startIdx := anInterval first.
	endIdx := anInterval last.
	selInterval := parentElement selection from to: parentElement selection to.
	rects := Array streamContents: [ :stream | 
		         parentElement
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
								(selInterval intersection: (startIdx + 1 to: endIdx )) ifEmpty: [ 
									((startIdx -1 to: endIdx) = selInterval) ifFalse: [ 
				         				origin := pieceElement screenOriginAt: first - piece textStart - 1.
				         				corner := pieceElement screenCornerAt: last - piece textStart.
										bnds := BlBounds fromRectangle: (origin corner: corner).
										bnds := (parentElement infinite localBoundsToMine: bnds fromChild: pieceElement).
				         				stream nextPut: bnds ] ] ] ].
	rects ifEmpty: [ ^ self ].
	rem := AlbSelectionEcho new adjacentRectangles: rects; subtext: (parentElement text from: anInterval first to: anInterval last); yourself.
	decorations add: rem 
]

{ #category : #accessing }
AlbSubtextDecorationBuilder >> decorations [

	^ decorations

]

{ #category : #accessing }
AlbSubtextDecorationBuilder >> fullText: aSubtext [

	fullText := aSubtext
]

{ #category : #initialization }
AlbSubtextDecorationBuilder >> initialize [ 

	super initialize.
	decorations := OrderedCollection new
]

{ #category : #accessing }
AlbSubtextDecorationBuilder >> parentElement: anObject [

	parentElement := anObject
]

{ #category : #accessing }
AlbSubtextDecorationBuilder >> subtext: aSubtext [

	subtext := aSubtext
]
