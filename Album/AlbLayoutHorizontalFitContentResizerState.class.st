Class {
	#name : #AlbLayoutHorizontalFitContentResizerState,
	#superclass : #AlbLayoutHorizontalResizerState,
	#category : #'Album-Resizer'
}

{ #category : #comparing }
AlbLayoutHorizontalFitContentResizerState >> = anotherState [
	^ anotherState isKindOf: AlbLayoutHorizontalFitContentResizerState
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
