Class {
	#name : #AlbLayoutHorizontalFitContentResizerState,
	#superclass : #AlbLayoutHorizontalResizerState,
	#category : #'Album-Brick-Core-Layout Resizer - I dnu'
}

{ #category : #comparing }
AlbLayoutHorizontalFitContentResizerState >> = anotherState [
	^ anotherState isKindOf: AlbLayoutHorizontalFitContentResizerState
]

{ #category : #converting }
AlbLayoutHorizontalFitContentResizerState >> asPropagated [
	^ AlbLayoutHorizontalFitContentResizerPropagatedState uniqueInstance
]

{ #category : #comparing }
AlbLayoutHorizontalFitContentResizerState >> hash [
	^ AlbLayoutHorizontalFitContentResizerState hash
]

{ #category : #printing }
AlbLayoutHorizontalFitContentResizerState >> printOn: aStream [
	super printOn: aStream.
	aStream
		nextPutAll: 'fit content'
]
