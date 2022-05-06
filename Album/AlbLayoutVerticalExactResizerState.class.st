Class {
	#name : #AlbLayoutVerticalExactResizerState,
	#superclass : #AlbLayoutVerticalResizerState,
	#category : #'Album-Resizer'
}

{ #category : #converting }
AlbLayoutVerticalExactResizerState >> asPropagated [
	"Exact resizer state should not be propagated, it should be converted to match parent"

	^ self shouldNotImplement
]

{ #category : #printing }
AlbLayoutVerticalExactResizerState >> printOn: aStream [
	super printOn: aStream.
	aStream
		nextPutAll: 'exact'
]
