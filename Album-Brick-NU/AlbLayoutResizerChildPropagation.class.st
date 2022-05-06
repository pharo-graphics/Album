Class {
	#name : #AlbLayoutResizerChildPropagation,
	#superclass : #AlbLayoutResizerPropagation,
	#instVars : [
		'childElement'
	],
	#category : #'Album-Brick-NU-Layout Resizer'
}

{ #category : #accessing }
AlbLayoutResizerChildPropagation >> childElement [
	^ childElement
]

{ #category : #accessing }
AlbLayoutResizerChildPropagation >> childElement: anObject [
	childElement := anObject
]

{ #category : #accessing }
AlbLayoutResizerChildPropagation >> childrenToPropagateFrom: aParentElement do: aBlockClosure [
	aBlockClosure value: self childElement
]
