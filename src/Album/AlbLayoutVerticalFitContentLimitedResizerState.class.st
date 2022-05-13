Class {
	#name : #AlbLayoutVerticalFitContentLimitedResizerState,
	#superclass : #AlbLayoutVerticalResizerState,
	#category : #'Album-Resizer'
}

{ #category : #comparing }
AlbLayoutVerticalFitContentLimitedResizerState >> = anotherState [
	^ anotherState isKindOf: AlbLayoutVerticalFitContentLimitedResizerState
]

{ #category : #comparing }
AlbLayoutVerticalFitContentLimitedResizerState >> hash [
	^ AlbLayoutVerticalFitContentLimitedResizerState hash
]
