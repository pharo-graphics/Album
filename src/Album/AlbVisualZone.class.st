Class {
	#name : #AlbVisualZone,
	#superclass : #Object,
	#instVars : [
		'zone',
		'needRefresh'
	],
	#category : #'Album-UI'
}

{ #category : #sparta }
AlbVisualZone >> drawOnSpartaCanvas: aSpartaCanvas in: anInfiniteElement [
	^ self subclassResponsibility  
]

{ #category : #sparta }
AlbVisualZone >> drawOnSpartaCanvasOver: aSpartaCanvas in: anInfiniteElement [
	^ self subclassResponsibility  
]

{ #category : #accessing }
AlbVisualZone >> itemOffset: anItemElement in: anInfiniteElement [
	"Retrieve any offsets for the given item element.
	If this ItemDecoration does not affect the positioning of item element, it should return empty insets"
	<return: #BlInsets>
	
	^ BlInsets empty
]

{ #category : #accessing }
AlbVisualZone >> zone [

	^ zone
]

{ #category : #accessing }
AlbVisualZone >> zone: anObject [
	zone := anObject.

]
