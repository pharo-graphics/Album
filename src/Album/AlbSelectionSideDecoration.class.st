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

	| top bottom |
	"here anItemElement is a logical line"
	(anItemElement children noneSatisfy: [ :e | 
		 (e isKindOf: BlTextElement) and: [ e selection isNotEmpty or: [ e hasCursor ] ] ]) ifTrue: [ ^ nil ].
	top := 0.
	bottom := 0.
	anItemElement childrenDo: [ :child | 
		top := top min: child bounds top.
		bottom := bottom max: child bounds bottom ].
	^ 0 @ top corner: self computedBounds width - self gap @ bottom
]

{ #category : #geometry }
AlbSelectionSideDecoration >> selectionLimitRectangleOf: anItemElement in: anInfiniteElement do: aBlock [

	(self selectionLimitRectangleOf: anItemElement in: anInfiniteElement) ifNotNil: [ :bnds | aBlock value: bnds ]
]
