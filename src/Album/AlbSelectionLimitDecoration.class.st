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

	| first last withSelection |
	anInfiniteElement selection isEmpty ifTrue: [ ^ self ].

	withSelection := anItemElement children select: [ :e | e selection isNotEmpty ].
	first := withSelection detect: [ :e | e bounds left isZero ] ifNone: [  ].
	first ifNil: [ first := last := anItemElement firstChild ] ifNotNil: [ last := withSelection last ].
	((first hasCursor and: [ first cursorElement bounds left isZero ]) or: [ 
		 first selection isNotEmpty and: [ first selection from isZero ] ]) ifFalse: [ ^ self ].
	aBlock value: (0 @ first bounds top corner: self computedBounds width - 1 @ last bounds bottom)
]
