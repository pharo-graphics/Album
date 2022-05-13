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
