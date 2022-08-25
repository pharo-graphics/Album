Class {
	#name : #AlbSelectionLimitDecoration,
	#superclass : #BlInfiniteDecoration,
	#category : #'Album-UI'
}

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

{ #category : #geometry }
AlbSelectionLimitDecoration >> selectionLimitRectangleOf: anItemElement in: anInfiniteElement do: aBlock [

	| first |
	anInfiniteElement selection isEmpty ifTrue: [ ^ self ].
	first := anItemElement firstChild.
	(first isKindOf: AlbTextElement) ifFalse: [ ^ self ].

	((first hasCursor and: [ first cursorElement bounds left isZero ]) or: [ 
		 first selection isNotEmpty and: [ first selection from isZero ] ]) ifFalse: [ ^ self ].
	aBlock value: (0 @ first bounds top corner: self computedBounds width - 1 @ first bounds bottom)
]
