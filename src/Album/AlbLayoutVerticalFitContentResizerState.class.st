Class {
	#name : #AlbLayoutVerticalFitContentResizerState,
	#superclass : #AlbLayoutVerticalResizerState,
	#category : #'Album-Resizer'
}

{ #category : #comparing }
AlbLayoutVerticalFitContentResizerState >> = anotherState [
	^ anotherState isKindOf: AlbLayoutVerticalFitContentResizerState
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
