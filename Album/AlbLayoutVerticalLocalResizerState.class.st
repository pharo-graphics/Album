Class {
	#name : #AlbLayoutVerticalLocalResizerState,
	#superclass : #AlbLayoutVerticalResizerState,
	#category : #'Album-Resizer'
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
