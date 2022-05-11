Class {
	#name : #AlbNullLayoutResizerPropagations,
	#superclass : #Object,
	#instVars : [
		'propagations',
		'propagationMap'
	],
	#category : #'Album-Brick-NU-Layout Resizer'
}

{ #category : #accessing }
AlbNullLayoutResizerPropagations >> clearPropagationRules: aParentElement [

]

{ #category : #accessing }
AlbNullLayoutResizerPropagations >> element [
	^ nil
]

{ #category : #accessing }
AlbNullLayoutResizerPropagations >> element: anElement [

]

{ #category : #accessing }
AlbNullLayoutResizerPropagations >> precomputePropagationRules: aParentElement [
	
]

{ #category : #accessing }
AlbNullLayoutResizerPropagations >> propagateState: aAlbLayoutResizerState from: aParentElement to: aChildElement [

	^ BlElementState default
]
