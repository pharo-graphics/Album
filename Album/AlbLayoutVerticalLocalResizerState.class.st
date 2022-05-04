Class {
	#name : #AlbLayoutVerticalLocalResizerState,
	#superclass : #AlbLayoutVerticalResizerState,
	#category : #'Album-Brick-Core-Layout Resizer - I dnu'
}

{ #category : #converting }
AlbLayoutVerticalLocalResizerState >> asPropagated [
	^ self shouldNotImplement
]

{ #category : #printing }
AlbLayoutVerticalLocalResizerState >> printOn: aStream [
	super printOn: aStream.
	aStream
		nextPutAll: 'local'
]
