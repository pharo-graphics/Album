Class {
	#name : #AlbLayoutResizerChildrenPropagation,
	#superclass : #AlbLayoutResizerPropagation,
	#instVars : [
		'childrenElements'
	],
	#category : #'Album-Brick-NU-Layout Resizer'
}

{ #category : #accessing }
AlbLayoutResizerChildrenPropagation >> childrenElements [
	^ childrenElements
]

{ #category : #accessing }
AlbLayoutResizerChildrenPropagation >> childrenElements: anObject [
	childrenElements := anObject
]

{ #category : #accessing }
AlbLayoutResizerChildrenPropagation >> childrenToPropagateFrom: aParentElement do: aBlockClosure [
	self childrenElements do: aBlockClosure
]
