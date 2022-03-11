Class {
	#name : #AlbLayoutHorizontalResizerState,
	#superclass : #AlbLayoutResizerState,
	#classInstVars : [
		'any'
	],
	#category : #'Album-Brick-Core-Layout Resizer'
}

{ #category : #'instance creation' }
AlbLayoutHorizontalResizerState class >> any [
	^ any ifNil: [ any := self exact or: (self fitContent or: (self fitContentLimited or: self matchParent)) ]
]

{ #category : #cleanup }
AlbLayoutHorizontalResizerState class >> cleanUp [
	any := nil
]

{ #category : #'instance creation' }
AlbLayoutHorizontalResizerState class >> exact [
	^ AlbLayoutHorizontalExactResizerState uniqueInstance
]

{ #category : #'instance creation' }
AlbLayoutHorizontalResizerState class >> fitContent [
	^ AlbLayoutHorizontalFitContentResizerState uniqueInstance
]

{ #category : #'instance creation' }
AlbLayoutHorizontalResizerState class >> fitContentLimited [
	^ AlbLayoutHorizontalFitContentLimitedResizerState uniqueInstance
]

{ #category : #'instance creation' }
AlbLayoutHorizontalResizerState class >> local [
	^ AlbLayoutHorizontalLocalResizerState uniqueInstance
]

{ #category : #'instance creation' }
AlbLayoutHorizontalResizerState class >> matchParent [
	^ AlbLayoutHorizontalMatchParentResizerState uniqueInstance
]

{ #category : #printing }
AlbLayoutHorizontalResizerState >> printOn: aStream [
	aStream
		nextPutAll: 'horizontal resizer - '
]

{ #category : #accessing }
AlbLayoutHorizontalResizerState >> type [
	"Return an object used to compare two states when adding to the collection of states in order to prevent
	elements from having duplicated states"
	<return: #Object>

	^ AlbLayoutHorizontalResizerState
]
