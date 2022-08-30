Class {
	#name : #AlbSelectionSideDecoration,
	#superclass : #BlInfiniteDecoration,
	#category : #'Album-UI'
}

{ #category : #geometry }
AlbSelectionSideDecoration >> gap [
	^ 0
]

{ #category : #geometry }
AlbSelectionSideDecoration >> requiredInsetsOfChildElement: anElement [
	^ self subclassResponsibility 
]

{ #category : #geometry }
AlbSelectionSideDecoration >> requiredWidth [
	^ self subclassResponsibility 
]

{ #category : #accessing }
AlbSelectionSideDecoration >> selectionBackgroundColorOf: anItemElement in: anInfiniteElement [
	^ anInfiniteElement selectionColor alpha: 0.6
]

{ #category : #geometry }
AlbSelectionSideDecoration >> selectionLimitRectangleOf: anItemElement in: anInfiniteElement [

	| first last withSelectionOrCursor |
	"here anItemElement is a logical line"
	withSelectionOrCursor := anItemElement children select: [ :e | 
		                         (e isKindOf: BlTextElement) and: [ e selection isNotEmpty or: [ e hasCursor ] ] ].
	withSelectionOrCursor ifEmpty: [ ^ nil ].
	first := withSelectionOrCursor first.
	last := withSelectionOrCursor last.
	^ 0 @ first bounds top corner: self computedBounds width - self gap @ (last bounds top + last textFlow assignedLine height)
]

{ #category : #geometry }
AlbSelectionSideDecoration >> selectionLimitRectangleOf: anItemElement in: anInfiniteElement do: aBlock [

	(self selectionLimitRectangleOf: anItemElement in: anInfiniteElement) ifNotNil: [ :bnds | aBlock value: bnds ]
]
