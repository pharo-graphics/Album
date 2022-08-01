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
AlbSelectionLimitDecoration >> width [
	^ 3
]
