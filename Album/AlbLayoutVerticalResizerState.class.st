Class {
	#name : #AlbLayoutVerticalResizerState,
	#superclass : #AlbLayoutResizerState,
	#classInstVars : [
		'any'
	],
	#category : #'Album-Brick-Core-Layout Resizer - I dnu'
}

{ #category : #accessing }
AlbLayoutVerticalResizerState class >> any [
	^ any ifNil: [ any := self exact or: (self fitContent or: (self fitContentLimited or: self matchParent)) ]
]

{ #category : #cleanup }
AlbLayoutVerticalResizerState class >> cleanUp [
	any := nil
]

{ #category : #'instance creation' }
AlbLayoutVerticalResizerState class >> exact [
	^ AlbLayoutVerticalExactResizerState uniqueInstance
]

{ #category : #'instance creation' }
AlbLayoutVerticalResizerState class >> fitContent [
	^ AlbLayoutVerticalFitContentResizerState uniqueInstance
]

{ #category : #'instance creation' }
AlbLayoutVerticalResizerState class >> fitContentLimited [
	^ AlbLayoutVerticalFitContentLimitedResizerState uniqueInstance
]

{ #category : #'instance creation' }
AlbLayoutVerticalResizerState class >> local [
	^ AlbLayoutVerticalLocalResizerState uniqueInstance
]

{ #category : #'instance creation' }
AlbLayoutVerticalResizerState class >> matchParent [
	^ AlbLayoutVerticalMatchParentResizerState uniqueInstance
]

{ #category : #printing }
AlbLayoutVerticalResizerState >> printOn: aStream [
	aStream
		nextPutAll: 'vertical resizer - '
]

{ #category : #accessing }
AlbLayoutVerticalResizerState >> type [
	"Return an object used to compare two states when adding to the collection of states in order to prevent
	elements from having duplicated states"
	<return: #Object>

	^ AlbLayoutVerticalResizerState
]
