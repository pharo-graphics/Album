Class {
	#name : #AlbSelectionLimitDecoration,
	#superclass : #AlbSelectionSideDecoration,
	#category : #'Album-UI'
}

{ #category : #geometry }
AlbSelectionLimitDecoration >> cursorLimitRectangleOf: anItemElement in: anInfiniteElement [ 

	anInfiniteElement selection ifEmpty: [ ^ nil ].
	anInfiniteElement selection from isZero ifFalse: [ ^ nil ].
	^ super cursorLimitRectangleOf: anItemElement in: anInfiniteElement 
]

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
	^ 4
]

{ #category : #accessing }
AlbSelectionLimitDecoration >> selectionBackgroundColorOf: anItemElement in: anInfiniteElement [
	^ anInfiniteElement selectionColor 
]
