Class {
	#name : #AlbLayoutHorizontalMatchParentResizerState,
	#superclass : #AlbLayoutHorizontalResizerState,
	#category : #'Album-Brick-Core-Layout Resizer - I dnu'
}

{ #category : #comparing }
AlbLayoutHorizontalMatchParentResizerState >> = anotherState [
	^ anotherState isKindOf: AlbLayoutHorizontalMatchParentResizerState
]

{ #category : #converting }
AlbLayoutHorizontalMatchParentResizerState >> asPropagated [
	^ AlbLayoutHorizontalMatchParentResizerPropagatedState uniqueInstance
]

{ #category : #comparing }
AlbLayoutHorizontalMatchParentResizerState >> hash [
	^ AlbLayoutHorizontalMatchParentResizerState hash
]

{ #category : #printing }
AlbLayoutHorizontalMatchParentResizerState >> printOn: aStream [
	super printOn: aStream.
	aStream
		nextPutAll: 'match parent'
]
