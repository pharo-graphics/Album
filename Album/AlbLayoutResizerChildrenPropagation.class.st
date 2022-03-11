Class {
	#name : #AlbLayoutResizerChildrenPropagation,
	#superclass : #AlbLayoutResizerPropagation,
	#instVars : [
		'childrenElements'
	],
	#category : #'Album-Brick-Core-Layout Resizer'
}

{ #category : #accessing }
AlbLayoutResizerChildrenPropagation >> childrenElements [
	^ childrenElements
]

{ #category : #accessing }
AlbLayoutResizerChildrenPropagation >> childrenElements: anObject [
	childrenElements := anObject
]

{ #category : #'as yet unclassified' }
AlbLayoutResizerChildrenPropagation >> childrenToPropagateFrom: aParentElement do: aBlockClosure [
	self childrenElements do: aBlockClosure
]
