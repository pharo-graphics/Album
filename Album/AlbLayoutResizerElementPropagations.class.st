Class {
	#name : #AlbLayoutResizerElementPropagations,
	#superclass : #AlbLayoutResizerPropagations,
	#instVars : [
		'element'
	],
	#category : #'Album-Core-Layout Resizer'
}

{ #category : #'adding / removing' }
AlbLayoutResizerElementPropagations >> addPropagation: aBrLayoutResizerPropagation [
	super addPropagation: aBrLayoutResizerPropagation.
	
	self element requestStyle
]

{ #category : #'adding / removing' }
AlbLayoutResizerElementPropagations >> addPropagations: aBrLayoutResizerPropagations [
	super addPropagations: aBrLayoutResizerPropagations.
	
	self element requestStyle
]

{ #category : #accessing }
AlbLayoutResizerElementPropagations >> element [
	^ element
]

{ #category : #accessing }
AlbLayoutResizerElementPropagations >> element: anObject [
	element := anObject
]

{ #category : #'adding / removing' }
AlbLayoutResizerElementPropagations >> removePropagation: aBrLayoutResizerPropagation [
	super removePropagation: aBrLayoutResizerPropagation.
	
	self element requestStyle
]

{ #category : #'adding / removing' }
AlbLayoutResizerElementPropagations >> removePropagations: aBrLayoutResizerPropagations [
	super removePropagations: aBrLayoutResizerPropagations.
	
	self element requestStyle
]
