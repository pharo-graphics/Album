Class {
	#name : #AlbLayoutResizerElementPropagations,
	#superclass : #AlbLayoutResizerPropagations,
	#instVars : [
		'element'
	],
	#category : #'Album-Brick-Core-Layout Resizer - I dnu'
}

{ #category : #'adding / removing' }
AlbLayoutResizerElementPropagations >> addPropagation: aAlbLayoutResizerPropagation [
	super addPropagation: aAlbLayoutResizerPropagation.
	
	self element requestStyle
]

{ #category : #'adding / removing' }
AlbLayoutResizerElementPropagations >> addPropagations: aAlbLayoutResizerPropagations [
	super addPropagations: aAlbLayoutResizerPropagations.
	
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
AlbLayoutResizerElementPropagations >> removePropagation: aAlbLayoutResizerPropagation [
	super removePropagation: aAlbLayoutResizerPropagation.
	
	self element requestStyle
]

{ #category : #'adding / removing' }
AlbLayoutResizerElementPropagations >> removePropagations: aAlbLayoutResizerPropagations [
	super removePropagations: aAlbLayoutResizerPropagations.
	
	self element requestStyle
]
