Class {
	#name : #AlbLineNumberDecoration,
	#superclass : #BlInfiniteDecoration,
	#instVars : [
		'actualWidth'
	],
	#category : #'Album-UI'
}

{ #category : #geometry }
AlbLineNumberDecoration >> backgroundRectangleIn: anInfiniteElement [

	^(Rectangle origin: 0 @ 0 corner: self width @ anInfiniteElement height) 
]

{ #category : #geometry }
AlbLineNumberDecoration >> cursorBackgroundRectangleOf: anItemElement in: anInfiniteElement [

	| w |
	w := self width - anInfiniteElement border width.
	^ Rectangle origin: anInfiniteElement border width @ 0 corner: w @ anItemElement height
]

{ #category : #initialization }
AlbLineNumberDecoration >> defaultWidth [
	^ 25
]

{ #category : #initialization }
AlbLineNumberDecoration >> initialize [
	super initialize.
	actualWidth := self defaultWidth
]

{ #category : #geometry }
AlbLineNumberDecoration >> itemInsets: aBlInsets of: anItemElement in: anInfiniteElement [

	^ (BlInsets left: self width) + aBlInsets
]

{ #category : #geometry }
AlbLineNumberDecoration >> onActualWidthChangeWith: anInteger do: aBlock [

	anInteger <= actualWidth ifTrue: [ ^ self ].
	actualWidth := anInteger.
	aBlock value
]

{ #category : #geometry }
AlbLineNumberDecoration >> width [

	^ actualWidth + 6
]
