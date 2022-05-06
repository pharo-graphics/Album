Class {
	#name : #AlbLayoutResizerState,
	#superclass : #BlElementUniqueState,
	#category : #'Album-Resizer'
}

{ #category : #converting }
AlbLayoutResizerState >> asNotPropagated [
	^ self
]

{ #category : #converting }
AlbLayoutResizerState >> asPropagated [
	^ self subclassResponsibility
]

{ #category : #propagation }
AlbLayoutResizerState >> finishedPropagateFrom: aParentElement [
	aParentElement layoutResizerPropagations clearPropagationRules: aParentElement
]

{ #category : #propagation }
AlbLayoutResizerState >> prepareToPropagateFrom: aParentElement [
	aParentElement layoutResizerPropagations precomputePropagationRules: aParentElement
]

{ #category : #accessing }
AlbLayoutResizerState >> priority [
	^ UserPriority
]

{ #category : #propagation }
AlbLayoutResizerState >> propagatedStateFrom: aParentElement to: aChildElement [
	"Return a state that should be propagated from a given parent element to the child instead of me"
	<return: #BlElementState>

	^ aParentElement layoutResizerPropagations
		propagateState: self
		from: aParentElement
		to: aChildElement
]

{ #category : #testing }
AlbLayoutResizerState >> shouldPropagateToChildren [
	^ true
]
