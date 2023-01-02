Class {
	#name : #AlbSelectionLimitDecoration,
	#superclass : #OBlInfinteSideDecoration,
	#category : #'Album-UI'
}

{ #category : #initialization }
AlbSelectionLimitDecoration >> initialize [
	super initialize.
	"lowest priority"
	priority := SmallInteger maxVal
]

{ #category : #geometry }
AlbSelectionLimitDecoration >> requiredInsetsOfChildElement: anElement in: anInfiniteElement [

	^ BlInsets left: self requiredWidth
]

{ #category : #geometry }
AlbSelectionLimitDecoration >> requiredWidth [
	^ 3
]

{ #category : #accessing }
AlbSelectionLimitDecoration >> selectionBackgroundColorOf: anItemElement in: anInfiniteElement [
	^ anInfiniteElement selectionColor 
]
