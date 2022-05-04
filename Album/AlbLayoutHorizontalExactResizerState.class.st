Class {
	#name : #AlbLayoutHorizontalExactResizerState,
	#superclass : #AlbLayoutHorizontalResizerState,
	#category : #'Album-Brick-Core-Layout Resizer - I dnu'
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
