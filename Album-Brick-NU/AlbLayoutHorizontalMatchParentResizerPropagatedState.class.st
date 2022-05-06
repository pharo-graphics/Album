Class {
	#name : #AlbLayoutHorizontalMatchParentResizerPropagatedState,
	#superclass : #AlbLayoutHorizontalMatchParentResizerState,
	#category : #'Album-Brick-NU'
}

{ #category : #converting }
AlbLayoutHorizontalMatchParentResizerPropagatedState >> asNotPropagated [
	^ AlbLayoutHorizontalResizerState matchParent
]

{ #category : #converting }
AlbLayoutHorizontalMatchParentResizerPropagatedState >> asPropagated [
	^ self
]

{ #category : #enumerating }
AlbLayoutHorizontalMatchParentResizerPropagatedState >> optionalOnAddedTo: anElement [
	anElement properties hMatchParent
]

{ #category : #printing }
AlbLayoutHorizontalMatchParentResizerPropagatedState >> printOn: aStream [
	super printOn: aStream.
	aStream space;
		nextPutAll: '(propagated)'
]

{ #category : #testing }
AlbLayoutHorizontalMatchParentResizerPropagatedState >> shouldOverwriteChildState [
	^ true
]
