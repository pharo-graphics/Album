Class {
	#name : #AlbLayoutResizerChildPropagation,
	#superclass : #AlbLayoutResizerPropagation,
	#instVars : [
		'childElement'
	],
	#category : #'Album-Brick-Core-Layout Resizer'
}

{ #category : #accessing }
AlbLayoutResizerChildPropagation >> childElement [
	^ childElement
]

{ #category : #accessing }
AlbLayoutResizerChildPropagation >> childElement: anObject [
	childElement := anObject
]

{ #category : #'as yet unclassified' }
AlbLayoutResizerChildPropagation >> childrenToPropagateFrom: aParentElement do: aBlockClosure [
	aBlockClosure value: self childElement
]
