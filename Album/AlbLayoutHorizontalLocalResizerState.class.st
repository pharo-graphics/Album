Class {
	#name : #AlbLayoutHorizontalLocalResizerState,
	#superclass : #AlbLayoutHorizontalResizerState,
	#category : #'Album-Brick-Core-Layout Resizer - I dnu'
}

{ #category : #converting }
AlbLayoutHorizontalLocalResizerState >> asPropagated [
	^ self shouldNotImplement
]

{ #category : #printing }
AlbLayoutHorizontalLocalResizerState >> printOn: aStream [
	super printOn: aStream.
	aStream
		nextPutAll: 'local'
]
