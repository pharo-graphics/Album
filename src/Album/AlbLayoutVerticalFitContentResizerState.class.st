Class {
	#name : #AlbLayoutVerticalFitContentResizerState,
	#superclass : #AlbLayoutVerticalResizerState,
	#category : #'Album-Resizer'
}

{ #category : #comparing }
AlbLayoutVerticalFitContentResizerState >> = anotherState [
	^ anotherState isKindOf: AlbLayoutVerticalFitContentResizerState
]

{ #category : #comparing }
AlbLayoutVerticalFitContentResizerState >> hash [
	^ AlbLayoutVerticalFitContentResizerState hash
]
