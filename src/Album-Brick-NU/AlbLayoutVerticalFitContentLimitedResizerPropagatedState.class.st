Class {
	#name : #AlbLayoutVerticalFitContentLimitedResizerPropagatedState,
	#superclass : #AlbLayoutVerticalFitContentLimitedResizerState,
	#category : #'Album-Brick-NU-Layout Resizer'
}

{ #category : #converting }
AlbLayoutVerticalFitContentLimitedResizerPropagatedState >> asNotPropagated [
	^ AlbLayoutVerticalResizerState fitContentLimited
]

{ #category : #converting }
AlbLayoutVerticalFitContentLimitedResizerPropagatedState >> asPropagated [
	^ self
]

{ #category : #enumerating }
AlbLayoutVerticalFitContentLimitedResizerPropagatedState >> optionalOnAddedTo: anElement [
	anElement properties vFitContentLimited
]

{ #category : #printing }
AlbLayoutVerticalFitContentLimitedResizerPropagatedState >> printOn: aStream [
	super printOn: aStream.
	aStream space;
		nextPutAll: '(propagated)'
]

{ #category : #testing }
AlbLayoutVerticalFitContentLimitedResizerPropagatedState >> shouldOverwriteChildState [
	^ true
]