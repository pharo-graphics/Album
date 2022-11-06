Class {
	#name : #AlbLineNumberDecoration,
	#superclass : #AlbSelectionSideDecoration,
	#instVars : [
		'actualWidth'
	],
	#category : #'Album-UI'
}

{ #category : #initialization }
AlbLineNumberDecoration >> defaultMaxAtRight [
	^ 12
]

{ #category : #initialization }
AlbLineNumberDecoration >> defaultWidth [
	^ 17
]

{ #category : #initialization }
AlbLineNumberDecoration >> initialize [
	super initialize.
	actualWidth := self defaultWidth.
	"highest priority"
	priority := 0
]

{ #category : #geometry }
AlbLineNumberDecoration >> onActualWidthChangeWith: anInteger do: aBlock [

	anInteger <= actualWidth ifTrue: [ ^ self ].
	actualWidth := anInteger.
	aBlock value
]

{ #category : #geometry }
AlbLineNumberDecoration >> requiredInsetsOfChildElement: anElement in: anInfiniteElement [

	^ BlInsets left: self requiredWidth + anInfiniteElement margin left
]

{ #category : #geometry }
AlbLineNumberDecoration >> requiredWidth [

	^ (actualWidth + self defaultMaxAtRight - (actualWidth \\ self defaultMaxAtRight)) + 5
]
