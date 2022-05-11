Extension { #name : #AlbLayoutResizerState }

{ #category : #'*Album-Brick-NU' }
AlbLayoutResizerState >> asNotPropagated [
	^ self
]

{ #category : #'*Album-Brick-NU' }
AlbLayoutResizerState >> finishedPropagateFrom: aParentElement [
	aParentElement layoutResizerPropagations clearPropagationRules: aParentElement
]

{ #category : #'*Album-Brick-NU' }
AlbLayoutResizerState >> prepareToPropagateFrom: aParentElement [
	aParentElement layoutResizerPropagations precomputePropagationRules: aParentElement
]

{ #category : #'*Album-Brick-NU' }
AlbLayoutResizerState >> propagatedStateFrom: aParentElement to: aChildElement [
	"Return a state that should be propagated from a given parent element to the child instead of me"
	<return: #BlElementState>

	^ aParentElement layoutResizerPropagations
		propagateState: self
		from: aParentElement
		to: aChildElement
]

{ #category : #'*Album-Brick-NU' }
AlbLayoutResizerState >> shouldPropagateToChildren [
	^ true
]
