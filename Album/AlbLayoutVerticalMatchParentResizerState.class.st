Class {
	#name : #AlbLayoutVerticalMatchParentResizerState,
	#superclass : #AlbLayoutVerticalResizerState,
	#category : #'Album-Resizer'
}

{ #category : #comparing }
AlbLayoutVerticalMatchParentResizerState >> = anotherState [
	^ anotherState isKindOf: AlbLayoutVerticalMatchParentResizerState
]

{ #category : #comparing }
AlbLayoutVerticalMatchParentResizerState >> hash [
	^ AlbLayoutVerticalMatchParentResizerState hash
]

{ #category : #printing }
AlbLayoutVerticalMatchParentResizerState >> printOn: aStream [
	super printOn: aStream.
	aStream
		nextPutAll: 'match parent'
]
