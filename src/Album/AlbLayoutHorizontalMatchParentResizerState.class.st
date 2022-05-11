Class {
	#name : #AlbLayoutHorizontalMatchParentResizerState,
	#superclass : #AlbLayoutHorizontalResizerState,
	#category : #'Album-Resizer'
}

{ #category : #comparing }
AlbLayoutHorizontalMatchParentResizerState >> = anotherState [
	^ anotherState isKindOf: AlbLayoutHorizontalMatchParentResizerState
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