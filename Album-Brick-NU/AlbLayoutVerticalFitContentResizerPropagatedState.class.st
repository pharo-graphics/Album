Class {
	#name : #AlbLayoutVerticalFitContentResizerPropagatedState,
	#superclass : #AlbLayoutVerticalFitContentResizerState,
	#category : #'Album-Brick-NU-Layout Resizer'
}

{ #category : #converting }
AlbLayoutVerticalFitContentResizerPropagatedState >> asNotPropagated [
	^ AlbLayoutVerticalResizerState fitContent
]

{ #category : #converting }
AlbLayoutVerticalFitContentResizerPropagatedState >> asPropagated [
	^ self
]

{ #category : #enumerating }
AlbLayoutVerticalFitContentResizerPropagatedState >> optionalOnAddedTo: anElement [
	anElement properties vFitContent
]

{ #category : #printing }
AlbLayoutVerticalFitContentResizerPropagatedState >> printOn: aStream [
	super printOn: aStream.
	aStream space;
		nextPutAll: '(propagated)'
]

{ #category : #testing }
AlbLayoutVerticalFitContentResizerPropagatedState >> shouldOverwriteChildState [
	^ true
]
