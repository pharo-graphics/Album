Class {
	#name : #AlbLayoutHorizontalExactResizerState,
	#superclass : #AlbLayoutHorizontalResizerState,
	#category : #'Album-Brick-NU-Layout Resizer'
}

{ #category : #converting }
AlbLayoutHorizontalExactResizerState >> asPropagated [
	"Exact resizer state should not be propagated, it should be converted to match parent"

	^ self shouldNotImplement
]

{ #category : #printing }
AlbLayoutHorizontalExactResizerState >> printOn: aStream [
	super printOn: aStream.
	aStream
		nextPutAll: 'exact'
]
