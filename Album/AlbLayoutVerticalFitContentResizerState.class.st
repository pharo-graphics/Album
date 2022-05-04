Class {
	#name : #AlbLayoutVerticalFitContentResizerState,
	#superclass : #AlbLayoutVerticalResizerState,
	#category : #'Album-Brick-Core-Layout Resizer - I dnu'
}

{ #category : #comparing }
AlbLayoutVerticalFitContentResizerState >> = anotherState [
	^ anotherState isKindOf: AlbLayoutVerticalFitContentResizerState
]

{ #category : #converting }
AlbLayoutVerticalFitContentResizerState >> asPropagated [
	^ AlbLayoutVerticalFitContentResizerPropagatedState uniqueInstance
]

{ #category : #comparing }
AlbLayoutVerticalFitContentResizerState >> hash [
	^ AlbLayoutVerticalFitContentResizerState hash
]

{ #category : #printing }
AlbLayoutVerticalFitContentResizerState >> printOn: aStream [
	super printOn: aStream.
	aStream
		nextPutAll: 'fit content'
]
