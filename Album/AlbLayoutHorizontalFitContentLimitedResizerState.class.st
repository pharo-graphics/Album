Class {
	#name : #AlbLayoutHorizontalFitContentLimitedResizerState,
	#superclass : #AlbLayoutHorizontalResizerState,
	#category : #'Album-Resizer'
}

{ #category : #comparing }
AlbLayoutHorizontalFitContentLimitedResizerState >> = anotherState [
	^ anotherState isKindOf: AlbLayoutHorizontalFitContentLimitedResizerState
]

{ #category : #converting }
AlbLayoutHorizontalFitContentLimitedResizerState >> asPropagated [
	^ AlbLayoutHorizontalFitContentLimitedResizerPropagatedState uniqueInstance
]

{ #category : #comparing }
AlbLayoutHorizontalFitContentLimitedResizerState >> hash [
	^ AlbLayoutHorizontalFitContentLimitedResizerState hash
]

{ #category : #printing }
AlbLayoutHorizontalFitContentLimitedResizerState >> printOn: aStream [
	super printOn: aStream.
	aStream
		nextPutAll: 'fit content limited'
]
