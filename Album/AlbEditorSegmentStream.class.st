Class {
	#name : #AlbEditorSegmentStream,
	#superclass : #Object,
	#traits : 'TBlDebug',
	#classTraits : 'TBlDebug classTrait',
	#instVars : [
		'limit',
		'collection',
		'skip'
	],
	#category : #'Album-Editor-Model - Segment'
}

{ #category : #accessing }
AlbEditorSegmentStream >> collection [
	^ collection
]

{ #category : #accessing }
AlbEditorSegmentStream >> collection: anObject [
	collection := anObject
]

{ #category : #initialization }
AlbEditorSegmentStream >> initialize [
	super initialize.
	
	collection := OrderedCollection new.
	limit := 100.
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
	
	self
		assert: [ skip >= 0 ]
		description: [ 'Skip count must not be negative' ].
	
	skip isZero
		ifTrue: [ collection add: aTextEditorSegment ]
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
	^ collection size
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

	skip := aNumber
]

{ #category : #testing }
AlbEditorSegmentStream >> wantsMore [
	^ self size < self limit
]
