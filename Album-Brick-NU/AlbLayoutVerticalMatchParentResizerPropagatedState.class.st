Class {
	#name : #AlbLayoutVerticalMatchParentResizerPropagatedState,
	#superclass : #AlbLayoutVerticalMatchParentResizerState,
	#category : #'Album-Brick-NU'
}

{ #category : #converting }
AlbLayoutVerticalMatchParentResizerPropagatedState >> asNotPropagated [
	^ AlbLayoutVerticalResizerState matchParent
]

{ #category : #converting }
AlbLayoutVerticalMatchParentResizerPropagatedState >> asPropagated [
	^ self
]

{ #category : #enumerating }
AlbLayoutVerticalMatchParentResizerPropagatedState >> optionalOnAddedTo: anElement [
	anElement properties vMatchParent
]

{ #category : #printing }
AlbLayoutVerticalMatchParentResizerPropagatedState >> printOn: aStream [
	super printOn: aStream.
	aStream space;
		nextPutAll: '(propagated)'
]

{ #category : #testing }
AlbLayoutVerticalMatchParentResizerPropagatedState >> shouldOverwriteChildState [
	^ true
]
