Class {
	#name : #AlbLayoutHorizontalExactResizerPropagatedState,
	#superclass : #AlbLayoutHorizontalExactResizerState,
	#instVars : [
		'width'
	],
	#category : #'Album-Resizer'
}

{ #category : #converting }
AlbLayoutHorizontalExactResizerPropagatedState >> asNotPropagated [
	^ AlbLayoutHorizontalResizerState exact
]

{ #category : #converting }
AlbLayoutHorizontalExactResizerPropagatedState >> asPropagated [
	^ self
]

{ #category : #initialization }
AlbLayoutHorizontalExactResizerPropagatedState >> initialize [
	super initialize.
	
	width := 50
]

{ #category : #enumerating }
AlbLayoutHorizontalExactResizerPropagatedState >> optionalOnAddedTo: anElement [
	anElement properties hExact: self width
]

{ #category : #printing }
AlbLayoutHorizontalExactResizerPropagatedState >> printOn: aStream [
	super printOn: aStream.
	aStream space;
		nextPutAll: '(propagated)'
]

{ #category : #testing }
AlbLayoutHorizontalExactResizerPropagatedState >> shouldOverwriteChildState [
	^ true
]

{ #category : #accessing }
AlbLayoutHorizontalExactResizerPropagatedState >> width [
	^ width
]

{ #category : #accessing }
AlbLayoutHorizontalExactResizerPropagatedState >> width: anObject [
	width := anObject
]
