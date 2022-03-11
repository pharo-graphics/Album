Class {
	#name : #AlbLayoutResizerDynamicPropagation,
	#superclass : #AlbLayoutResizerPropagation,
	#instVars : [
		'childrenBlock'
	],
	#category : #'Album-Brick-Core-Layout Resizer'
}

{ #category : #accessing }
AlbLayoutResizerDynamicPropagation >> childrenBlock [
	^ childrenBlock
]

{ #category : #accessing }
AlbLayoutResizerDynamicPropagation >> childrenBlock: anObject [
	childrenBlock := anObject
]

{ #category : #accessing }
AlbLayoutResizerDynamicPropagation >> childrenToPropagateFrom: aParentElement do: aBlockClosure [
	childrenBlock argumentCount isZero
		ifTrue: [
			| theChildElements |
			
			theChildElements := childrenBlock cull: aParentElement.
			theChildElements isCollection
				ifTrue: [ theChildElements do: aBlockClosure ]
				ifFalse: [ aBlockClosure value: theChildElements ] ]
		ifFalse: [ childrenBlock value: aBlockClosure ]
]
