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
AlbSelectionLimitDecoration >> selectionLimitRectangleOf: anItemElement in: anInfiniteElement do: aBlock [

	| elements |
	elements := anItemElement children select: [ :e | 
		            (e isKindOf: AlbTextElement) and: [ 
			            e selection isNotEmpty and: [ e selection from isZero and: [ e bounds left isZero ] ] ] ].
	"(firstTextElement hasSelection or: [firstTextElement hasCursor]) ifFalse: [ ^ false ]."
	"(firstTextElement hasSelection not and: [firstTextElement hasCursor and: [firstTextElement cursorElement bounds left > 0]]) ifTrue: [ ^self ]."
	elements isEmpty ifTrue: [ ^ self ].
	aBlock value: (elements first bounds topLeft corner: self width @ elements last bounds bottom)
]

{ #category : #geometry }
AlbSelectionLimitDecoration >> width [
	^ 4
]
