Class {
	#name : #AlbLayoutVerticalFitContentLimitedResizerState,
	#superclass : #AlbLayoutVerticalResizerState,
	#category : #'Album-Brick-Core-Layout Resizer'
}

{ #category : #comparing }
AlbLayoutVerticalFitContentLimitedResizerState >> = anotherState [
	^ anotherState isKindOf: AlbLayoutVerticalFitContentLimitedResizerState
]

{ #category : #converting }
AlbLayoutVerticalFitContentLimitedResizerState >> asPropagated [
	^ AlbLayoutVerticalFitContentLimitedResizerPropagatedState uniqueInstance
]

{ #category : #comparing }
AlbLayoutVerticalFitContentLimitedResizerState >> hash [
	^ AlbLayoutVerticalFitContentLimitedResizerState hash
]

{ #category : #printing }
AlbLayoutVerticalFitContentLimitedResizerState >> printOn: aStream [
	super printOn: aStream.
	aStream
		nextPutAll: 'fit content limited'
]
