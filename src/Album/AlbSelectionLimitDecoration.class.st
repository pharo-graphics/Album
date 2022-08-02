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

	| elements |
	elements := anItemElement children select: [ :e | 
		            (e isKindOf: AlbTextElement) and: [ 
			            e selection isNotEmpty and: [ e selection from isZero and: [ e bounds left isZero ] ] ] ].
	elements isEmpty ifTrue: [ ^ self ].
	aBlock value: (0 @ elements first bounds top corner: self computedBounds width @ elements last bounds bottom)
]
