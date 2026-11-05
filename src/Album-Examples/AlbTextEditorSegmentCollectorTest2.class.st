Class {
	#name : #AlbTextEditorSegmentCollectorTest2,
	#superclass : #TestCase,
	#instVars : [
		'largeFile'
	],
	#category : #'Album-Examples-Editor'
}

{ #category : #private }
AlbTextEditorSegmentCollectorTest2 >> deleteLargeFile [

	largeFile ifNotNil: 
		[ largeFile ensureDelete.
		largeFile := nil ].
]

{ #category : #accessing }
AlbTextEditorSegmentCollectorTest2 >> largeFile [

	^ largeFile ifNil: [
			  largeFile := FileSystem memory / 'largeFile.txt'.
			  largeFile writeStreamDo: [ :stream |
					  1 to: 10000 do: [ :l |
							  1 to: 9 do: [ :i | stream << (l - 1 * 10 + i - 1 printPaddedWith: $0 to: 10) ].
							  stream
								  << 'abcdefghi';
								  lf ] ].
			  largeFile ]
]

{ #category : #accessing }
AlbTextEditorSegmentCollectorTest2 >> largeFileRope [

	^ BlRopedText file: self largeFile
	
]

{ #category : #accessing }
AlbTextEditorSegmentCollectorTest2 >> segmentCollector [
	"Answer a segment collector whose cache limit is small enough that the large file (10000 lines) holds more than 2.62 times the cache limit, as required by the tests"

	^ self textEditor segmentCollector
		  cacheLimit: 1000;
		  yourself
]

{ #category : #private }
AlbTextEditorSegmentCollectorTest2 >> tearDown [ 
	
	self deleteLargeFile.
	super tearDown
]

{ #category : #examples }
AlbTextEditorSegmentCollectorTest2 >> testSegmentAt142 [
	"Retrieve the segment at 1.42 times the cache limit.
	This tests accessing the cache outside its initial contents.
	Assumptions:
	- The test file size has at least twice the number of lines in the cache"
	
	| segmentCollector limit expected actual |

	segmentCollector := self segmentCollector.
	limit := (segmentCollector cacheLimit * 1.42) rounded.
	expected := ((limit - 1) * 10) printPaddedWith: $0 to: 10.
	actual := (segmentCollector segmentAt: limit) text asString copyFrom: 1 to: 10.
	self assert: actual equals: expected.
]

{ #category : #examples }
AlbTextEditorSegmentCollectorTest2 >> testSegmentAt200and262 [
	"Retrieve the segment at line 200, followed by the segment at line 262.
	This tests re-using part of the previously cached items where the index of the segments collection is not the same as the line number"
	
	| segmentCollector expected actual limit |

	segmentCollector := self segmentCollector.

	limit := (segmentCollector cacheLimit * 2) rounded.
	expected := ((limit - 1) * 10) printPaddedWith: $0 to: 10.
	actual := (segmentCollector segmentAt: limit) text asString copyFrom: 1 to: 10.
	self assert: actual equals: expected.

	limit := (segmentCollector cacheLimit * 2.62) rounded.
	expected := ((limit - 1) * 10) printPaddedWith: $0 to: 10.
	actual := (segmentCollector segmentAt: limit) text asString copyFrom: 1 to: 10.
	self assert: actual equals: expected.

]

{ #category : #examples }
AlbTextEditorSegmentCollectorTest2 >> testSegmentAt242and42 [
	"Retrieve the segment at line 2.42 times the cache limit, followed by the segment at line 42.
	This tests #computeBackwardAt:."

	| expected actual segmentCollector limit |

	segmentCollector := self segmentCollector.

	"Retrieve several segments leading up to 2.42 times to populate the map entries"
	expected := '0000000410'.
	actual := (segmentCollector segmentAt: 42) text asString copyFrom: 1 to: 10.
	self assert: actual equals: expected.

	limit := (segmentCollector cacheLimit * 1.42) rounded.
	expected := ((limit - 1) * 10) printPaddedWith: $0 to: 10.
	actual := (segmentCollector segmentAt: limit) text asString copyFrom: 1 to: 10.
	self assert: actual equals: expected.

	limit := (segmentCollector cacheLimit * 2.42) rounded.
	expected := ((limit - 1) * 10) printPaddedWith: $0 to: 10.
	actual := (segmentCollector segmentAt: limit) text asString copyFrom: 1 to: 10.
	self assert: actual equals: expected.

	limit := (segmentCollector cacheLimit * 0.42) rounded.
	expected := ((limit - 1) * 10) printPaddedWith: $0 to: 10.
	actual := (segmentCollector segmentAt: limit) text asString copyFrom: 1 to: 10.
	self assert: actual equals: expected.

]

{ #category : #examples }
AlbTextEditorSegmentCollectorTest2 >> testSegmentAt42 [
	"Retrieve the segment at line 42.
	Assumes the cache limit is always greater than 42."
	
	| expected actual |

	expected := '0000000410'.
	actual := (self segmentCollector segmentAt: 42) text asString copyFrom: 1 to: 10.
	self assert: actual equals: expected.
]

{ #category : #examples }
AlbTextEditorSegmentCollectorTest2 >> testSegmentAt80and120 [
	"Retrieve the segment at 0.8 times the cache limit, followed by the segment at 1.2 times the cache limit.
	This tests re-using part of the previously cached items"
	
	| segmentCollector expected actual limit |

	segmentCollector := self segmentCollector.

	limit := (segmentCollector cacheLimit * 0.8) rounded.
	expected := (limit - 1 * 10) printPaddedWith: $0 to: 10.
	actual := (segmentCollector segmentAt: limit) text asString copyFrom: 1 to: 10.
	self assert: actual equals: expected.

	limit := (segmentCollector cacheLimit * 1.2) rounded.
	expected := (limit - 1 * 10) printPaddedWith: $0 to: 10.
	actual := (segmentCollector segmentAt: limit) text asString copyFrom: 1 to: 10.
	self assert: actual equals: expected.

]

{ #category : #accessing }
AlbTextEditorSegmentCollectorTest2 >> textEditor [

	^ AlbTextEditor new text: self largeFileRope
]
