Class {
	#name : #AlbLayoutHorizontalFitContentResizerPropagatedState,
	#superclass : #AlbLayoutHorizontalFitContentResizerState,
	#category : #'Album-Brick-NU'
}

{ #category : #converting }
AlbLayoutHorizontalFitContentResizerPropagatedState >> asNotPropagated [
	^ AlbLayoutHorizontalResizerState fitContent
]

{ #category : #converting }
AlbLayoutHorizontalFitContentResizerPropagatedState >> asPropagated [
	^ self
]

{ #category : #enumerating }
AlbLayoutHorizontalFitContentResizerPropagatedState >> optionalOnAddedTo: anElement [
	anElement properties hFitContent
]

{ #category : #printing }
AlbLayoutHorizontalFitContentResizerPropagatedState >> printOn: aStream [
	super printOn: aStream.
	aStream space;
		nextPutAll: '(propagated)'
]

{ #category : #testing }
AlbLayoutHorizontalFitContentResizerPropagatedState >> shouldOverwriteChildState [
	^ true
]
