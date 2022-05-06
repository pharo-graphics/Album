Class {
	#name : #AlbLayoutHorizontalFitContentLimitedResizerPropagatedState,
	#superclass : #AlbLayoutHorizontalFitContentLimitedResizerState,
	#category : #'Album-Brick-NU'
}

{ #category : #converting }
AlbLayoutHorizontalFitContentLimitedResizerPropagatedState >> asNotPropagated [
	^ AlbLayoutHorizontalResizerState fitContentLimited
]

{ #category : #converting }
AlbLayoutHorizontalFitContentLimitedResizerPropagatedState >> asPropagated [
	^ self
]

{ #category : #enumerating }
AlbLayoutHorizontalFitContentLimitedResizerPropagatedState >> optionalOnAddedTo: anElement [
	anElement properties hFitContentLimited
]

{ #category : #printing }
AlbLayoutHorizontalFitContentLimitedResizerPropagatedState >> printOn: aStream [
	super printOn: aStream.
	aStream space;
		nextPutAll: '(propagated)'
]

{ #category : #testing }
AlbLayoutHorizontalFitContentLimitedResizerPropagatedState >> shouldOverwriteChildState [
	^ true
]
