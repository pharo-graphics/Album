Class {
	#name : #AlbEditorSegmentStream,
	#superclass : #Object,
	#traits : 'TBlDebug',
	#classTraits : 'TBlDebug classTrait',
	#instVars : [
		'limit',
		'skip',
		'stream'
	],
	#category : #'Album-Model-Segment'
}

{ #category : #accessing }
AlbEditorSegmentStream >> collection [

	^ stream contents 
]

{ #category : #accessing }
AlbEditorSegmentStream >> collection: anObject [
	stream reset.
	stream nextPutAll: anObject
]

{ #category : #initialization }
AlbEditorSegmentStream >> defaultLimit [ 
	^500

]

{ #category : #initialization }
AlbEditorSegmentStream >> initialize [
	super initialize.
	
	stream := WriteStream on: (Array new: 50).
	limit := self defaultLimit.
	skip := 0
]

{ #category : #accessing }
AlbEditorSegmentStream >> limit [
	^ limit
]

{ #category : #accessing }
AlbEditorSegmentStream >> limit: aNumber [
	limit := aNumber
]

{ #category : #streaming }
AlbEditorSegmentStream >> nextPut: aTextEditorSegment [
	self
		assert: [ self wantsMore ]
		description: [ 'Stream is full, can not add more!' ].
		
	skip isZero
		ifTrue: [ stream nextPut: aTextEditorSegment ]
		ifFalse: [ skip := skip - 1 ]
]

{ #category : #accessing }
AlbEditorSegmentStream >> segments [
	"Return a collection of streamed text segments.
	I am an alias to #collection allowing us to increase readability"
	<return: #Collection of: #AblTextEditorSegment>

	^ self collection
]

{ #category : #accessing }
AlbEditorSegmentStream >> size [
	^ stream size
]

{ #category : #accessing }
AlbEditorSegmentStream >> skip [
	^ skip
]

{ #category : #accessing }
AlbEditorSegmentStream >> skip: aNumber [

	self
		assert: [ aNumber isInteger ]
		description: [ 'Skip count must be integer' ].
	self
		assert: [ skip >= 0 ]
		description: [ 'Skip count must not be negative' ].

	skip := aNumber
]

{ #category : #testing }
AlbEditorSegmentStream >> wantsMore [
	^ true
]
