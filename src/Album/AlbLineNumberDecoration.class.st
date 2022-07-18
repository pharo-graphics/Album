Class {
	#name : #AlbLineNumberDecoration,
	#superclass : #BlInfiniteDecoration,
	#category : #'Album-UI'
}

{ #category : #geometry }
AlbLineNumberDecoration >> invalidationBoundsIn: anEditorElement [
	^ BlBounds origin: 0@0 extent: self width @ anEditorElement height
]

{ #category : #geometry }
AlbLineNumberDecoration >> itemInsets: aBlInsets of: anItemElement in: anInfiniteElement [

	^ (BlInsets left: self width) + aBlInsets
]

{ #category : #geometry }
AlbLineNumberDecoration >> width [
	^ 50
]
