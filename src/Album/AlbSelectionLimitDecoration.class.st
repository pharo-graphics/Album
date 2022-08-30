Class {
	#name : #AlbSelectionLimitDecoration,
	#superclass : #AlbSelectionSideDecoration,
	#category : #'Album-UI'
}

{ #category : #geometry }
AlbSelectionLimitDecoration >> gap [
	^ 0
]

{ #category : #initialization }
AlbSelectionLimitDecoration >> initialize [
	super initialize.
	"lowest priority"
	priority := SmallInteger maxVal
]

{ #category : #geometry }
AlbSelectionLimitDecoration >> requiredInsetsOfChildElement: anElement [

	^ BlInsets left: self requiredWidth
]

{ #category : #geometry }
AlbSelectionLimitDecoration >> requiredWidth [
	^ 2
]

{ #category : #accessing }
AlbSelectionLimitDecoration >> selectionBackgroundColorOf: anItemElement in: anInfiniteElement [
	^ anInfiniteElement selectionColor 
]

{ #category : #geometry }
AlbSelectionLimitDecoration >> selectionLimitRectangleOf: anItemElement in: anInfiniteElement do: aBlock [
	anInfiniteElement selection ifEmpty: [ ^ self ].
	super selectionLimitRectangleOf: anItemElement in: anInfiniteElement do: aBlock
]
