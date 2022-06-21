"
An AlbEditorSegmentStreamTest is a test class for testing the behavior of AlbEditorSegmentStream
"
Class {
	#name : #AlbEditorSegmentStreamTest,
	#superclass : #TestCase,
	#instVars : [
		'stream'
	],
	#category : #'Album-Tests-Model-Segment'
}

{ #category : #initialization }
AlbEditorSegmentStreamTest >> setUp [ 
	stream := AlbEditorSegmentStream new
]

{ #category : #tests }
AlbEditorSegmentStreamTest >> test_basic_nextPut [

	self assert: stream size isZero.
	stream nextPut: $A.
	self assert: stream size equals: 1.
	self assert: stream size < stream limit.
	self assert: stream wantsMore
	
]

{ #category : #tests }
AlbEditorSegmentStreamTest >> test_nextPut_beyond_limit [
	| lim |
	lim := 10.
	self assert: stream size isZero.
	stream limit: lim.
	self assert: stream limit equals: lim.
	lim timesRepeat: [ stream nextPut: $A ].
	self assert: stream size equals: lim.
	self assert: stream wantsMore not.
	self should: [stream nextPut: $B] raise: Error.
	
]

{ #category : #tests }
AlbEditorSegmentStreamTest >> test_nextPut_with_skip [
	| lim skip |
	lim := 10.
	skip := 5.
	self assert: stream size isZero.
	stream limit: lim.
	stream skip: skip.
	self assert: stream limit equals: lim.
	self assert: stream skip equals: skip.
	lim timesRepeat: [ stream nextPut: $A ].
	self assert: stream size equals: lim - skip.
	lim - skip timesRepeat: [ stream nextPut: $B ].
	self assert: stream wantsMore not.
	self should: [stream nextPut: $C] raise: Error.
	
]
