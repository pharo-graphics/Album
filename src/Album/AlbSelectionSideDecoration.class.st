Class {
	#name : #AlbSelectionSideDecoration,
	#superclass : #BlInfiniteDecoration,
	#category : #'Album-UI'
}

{ #category : #geometry }
AlbSelectionSideDecoration >> cursorLimitRectangleOf: anItemElement in: anInfiniteElement [ 

	| withCursor |
	withCursor := anItemElement children detect: [ :e | e hasCursor ] ifNone: [ ^ nil ].
	^ (0 @ withCursor bounds top corner: self computedBounds width - self gap @ withCursor bounds bottom).
]

{ #category : #geometry }
AlbSelectionSideDecoration >> cursorLimitRectangleOf: anItemElement in: anInfiniteElement do: aBlock [

	(self cursorLimitRectangleOf: anItemElement in: anInfiniteElement) ifNotNil: [ :bnds | aBlock value: bnds ]
]

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

	| first last withSelectionOrCursor holder index |
	"here anItemElement is a logical line"
	holder := anInfiniteElement childHolderOf: anItemElement.
	index := holder layoutPosition.
	withSelectionOrCursor := anItemElement children select: [ :e | e selection isNotEmpty or: [ e hasCursor ] ].
	first := withSelectionOrCursor
		         detect: [ :e | e bounds left isZero and: [ e selection isNotEmpty and: [ e selection from isZero ] ] ]
		         ifNone: [ withSelectionOrCursor detect: [ :e | e hasCursor ] ifNone: [  ] ].

	first ifNil: [ first := last := anItemElement firstChild ] ifNotNil: [ last := withSelectionOrCursor last ].
	((first hasCursor and: [ first cursorElement bounds left isZero ]) or: [ 
		 first selection isNotEmpty and: [ first selection from isZero ] ]) ifTrue: [ 
		^ 0 @ first bounds top corner: self computedBounds width - self gap @ last bounds bottom ].
	^ nil
]

{ #category : #geometry }
AlbSelectionSideDecoration >> selectionLimitRectangleOf: anItemElement in: anInfiniteElement do: aBlock [

	(self selectionLimitRectangleOf: anItemElement in: anInfiniteElement) ifNotNil: [ :bnds | aBlock value: bnds ]
]
