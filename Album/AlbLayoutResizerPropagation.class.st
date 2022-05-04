Class {
	#name : #AlbLayoutResizerPropagation,
	#superclass : #Object,
	#instVars : [
		'associations'
	],
	#category : #'Album-Brick-Core-Layout Resizer - I dnu'
}

{ #category : #accessing }
AlbLayoutResizerPropagation >> childrenToPropagateFrom: aParentElement do: aBlockClosure [
	self subclassResponsibility
]

{ #category : #'api - to match parent' }
AlbLayoutResizerPropagation >> from: aFromLayoutResizerState to: aToLayoutResizerState [
	associations add: (aFromLayoutResizerState -> aToLayoutResizerState)
]

{ #category : #'api - to match parent' }
AlbLayoutResizerPropagation >> fromAll: aFromLayoutResizerStates to: aToLayoutResizerState [	
	aFromLayoutResizerStates do: [ :eachLayoutResizerStates | self from: eachLayoutResizerStates to: aToLayoutResizerState ]
]

{ #category : #initialization }
AlbLayoutResizerPropagation >> initialize [
	super initialize.
	
	associations := OrderedCollection new
]

{ #category : #accessing }
AlbLayoutResizerPropagation >> propagationAssociations [
	^ associations
]
