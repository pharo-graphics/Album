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
