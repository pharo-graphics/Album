Class {
	#name : #AlbLayoutHorizontalFitContentLimitedResizerState,
	#superclass : #AlbLayoutHorizontalResizerState,
	#category : #'Album-Resizer'
}

{ #category : #comparing }
AlbLayoutHorizontalFitContentLimitedResizerState >> = anotherState [
	^ anotherState isKindOf: AlbLayoutHorizontalFitContentLimitedResizerState
]

{ #category : #comparing }
AlbLayoutHorizontalFitContentLimitedResizerState >> hash [
	^ AlbLayoutHorizontalFitContentLimitedResizerState hash
]
