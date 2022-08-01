Class {
	#name : #AlbSelectionLimitDecoration,
	#superclass : #BlInfiniteDecoration,
	#category : #'Album-UI'
}

{ #category : #geometry }
AlbSelectionLimitDecoration >> itemInsets: aBlInsets of: anItemElement in: anInfiniteElement [

	^ (BlInsets left: self width) + aBlInsets
]

{ #category : #geometry }
AlbSelectionLimitDecoration >> selectionLimitRectangleOf: anItemElement [ 

	^ Rectangle origin: 0 @ 0 corner: self width @ anItemElement height

]

{ #category : #testing }
AlbSelectionLimitDecoration >> shouldDraw: anItemElement in: anInfiniteElement [

	| firstTextElement |
	anItemElement hasChildren ifFalse: [ ^ false ].
	firstTextElement := anItemElement firstChild.
	(firstTextElement hasSelection or: [firstTextElement hasCursor]) ifFalse: [ ^ false ].
	"(firstTextElement hasSelection not and: [firstTextElement hasCursor and: [firstTextElement cursorElement bounds left > 0]]) ifTrue: [ ^self ]."
	(firstTextElement hasSelection and: [firstTextElement selection from > 0]) ifTrue: [ ^false ].
	^ true
]

{ #category : #geometry }
AlbSelectionLimitDecoration >> width [
	^ 3
]
