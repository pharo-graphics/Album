Class {
	#name : #AlbLayoutResizerChildByIdPropagation,
	#superclass : #AlbLayoutResizerPropagation,
	#instVars : [
		'childId'
	],
	#category : #'Album-Brick-NU-Layout Resizer'
}

{ #category : #accessing }
AlbLayoutResizerChildByIdPropagation >> childId [
	<return: #BlElementId>

	^ childId
]

{ #category : #accessing }
AlbLayoutResizerChildByIdPropagation >> childId: aBlElementId [
	childId := aBlElementId asBlocElementId
]

{ #category : #accessing }
AlbLayoutResizerChildByIdPropagation >> childrenToPropagateFrom: aParentElement do: aBlockClosure [
	aParentElement
		childWithId: self childId
		ifFound: [ :aPotentialChild |
			(aParentElement hasChild: aPotentialChild)
				ifTrue: [ aBlockClosure value: aPotentialChild ] ]
		ifNone: [ ]
]
