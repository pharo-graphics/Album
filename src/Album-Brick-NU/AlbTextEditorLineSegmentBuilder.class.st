Class {
	#name : #AlbTextEditorLineSegmentBuilder,
	#superclass : #Object,
	#traits : 'TBlDebug',
	#classTraits : 'TBlDebug classTrait',
	#instVars : [
		'lineSplitter',
		'wordStencilBuilder'
	],
	#category : #'Album-Brick-NU-Model-Segment-Text'
}

{ #category : #'text - modifications' }
AlbTextEditorLineSegmentBuilder >> addedAttribute: anAttribute from: aFromIndex to: aToIndex in: aTextEditor [

	"Is sent after an attribute was added in provided text editor"

	| aFromSegment aToSegment |
	self halt.
	self assert: [ aFromIndex <= (aToIndex + 1) ] description: [ '`From` index must be less or equal to `to` index' ].

	aTextEditor segmentCollector
		cachedSegmentAt: aFromIndex
		ifFound: [ :aSegment | aFromSegment := aSegment ]
		ifNotFound: [  ].

	aTextEditor segmentCollector cachedSegmentAt: aToIndex ifFound: [ :aSegment | aToSegment := aSegment ] ifNotFound: [  ].

	"we add attribute to something completely outside of the cached segments, just ignore it"
	(aFromSegment isNil or: [ aToSegment isNil ]) ifTrue: [ ^ self ].

	aTextEditor updater
		from: aFromSegment textStart to: aToSegment textEnd;
		update
]

{ #category : #accessing }
AlbTextEditorLineSegmentBuilder >> beEditable [
self halt.
	self wordStencil: AlbTextWordPieceStencil editable
]

{ #category : #accessing }
AlbTextEditorLineSegmentBuilder >> beReadOnly [
self halt.
	self wordStencil: AlbTextWordPieceStencil readOnly 
]

{ #category : #initialization }
AlbTextEditorLineSegmentBuilder >> defaultSplitter [
self halt.
	^ AlbTextEditorLineSplitter new
]

{ #category : #'private - deletion' }
AlbTextEditorLineSegmentBuilder >> deleteFrom: aFromIndex segment: aFromSegment to: aToIndex segment: aToSegment in: aTextEditor [
	"I do the hard work of updating segment structure after deleting a piece of text within provided interval and segments"
	| shouldMergeWithPrevious aTargetSegment removedLength aNewEnd aNewStart |
self halt.	
	shouldMergeWithPrevious := self
		shouldMergeDeletingFrom: aFromIndex
		segment: aFromSegment
		in: aTextEditor.

	aTargetSegment := shouldMergeWithPrevious
		ifTrue: [ aTextEditor segmentCollector segments at: (aFromSegment index - 1) ]
		ifFalse: [ aFromSegment ].

	removedLength := aToIndex - aFromIndex + 1.

	"New end can be zero, in this case we should make new start zero too"
	aNewEnd := aToSegment textEnd - removedLength.
	aNewStart := aTargetSegment textStart min: aNewEnd.

	aTargetSegment
		scopeText: aNewStart
		end: aNewEnd.
		
	((aTargetSegment ~= aFromSegment) or: [ aFromSegment ~= aToSegment ])
		ifTrue: [
			| removeSegmentStart removeSegmentEnd |
			
			removeSegmentStart := (aTargetSegment ~= aFromSegment)
				ifTrue: [ aFromSegment index ]
				ifFalse: [ (aFromSegment index + 1) min: aToSegment index ].
			removeSegmentEnd := aToSegment index.

			aTextEditor segmentCollector removeSegmentInterval: (removeSegmentStart to: removeSegmentEnd) in: aTextEditor ].
	
	aTargetSegment moveTextPiecesBy: removedLength negated at: aFromIndex.
	aTextEditor segmentCollector
		moveTextBy: removedLength negated
		after: aTargetSegment.
		
	^ aTargetSegment
]

{ #category : #'text - modifications' }
AlbTextEditorLineSegmentBuilder >> deletedFrom: aFromIndex to: aToIndex in: aTextEditor [
	| aFromSegment aToSegment aTargetSegment |
self halt.
	self
		assert: [ aFromIndex <= aToIndex ]
		description: [ '`From` index must be less or equal to `to` index' ].

	aTextEditor segmentCollector
		cachedSegmentAt: aFromIndex
		ifFound: [ :aSegment | aFromSegment := aSegment ]
		ifNotFound: [ ].

	aTextEditor segmentCollector
		cachedSegmentAt: aToIndex
		ifFound: [ :aSegment | aToSegment := aSegment ]
		ifNotFound: [ ].

	(aFromSegment isNil or: [ aToSegment isNil ])	ifTrue: [ | interval |
			"Either aFromIndex or aToIndex are outside the segment collector's cache.
			It looks like the text editor's text has already been updated, 
			simply reset the cache and notify the editor"
			interval := aTextEditor segmentCollector cachedInterval.
			aTextEditor segmentCollector resetCache.
			aTextEditor notifyItemsRemoved: interval.
			^ self ].

	aTargetSegment := self deleteFrom: aFromIndex segment: aFromSegment to: aToIndex segment: aToSegment in: aTextEditor.

	aTextEditor updater
		from: aTargetSegment textStart to: aTargetSegment textEnd;
		update
]

{ #category : #initialization }
AlbTextEditorLineSegmentBuilder >> initialize [
	super initialize.

	

]

{ #category : #'text - modifications' }
AlbTextEditorLineSegmentBuilder >> insertedString: aString at: aTextIndex in: aTextEditor [
	"I am doing a hard work updating editor's segment cache due to inserted string.
	Note: This is an *algorithm* that should be very performant, that is why we don't see
	a point in doing it in OOP style, procedural way fits quite well"
	| aCurrentSegment aStream theNewSegments |
self halt.
	self
		assert: [ aTextEditor text isNotEmpty ]
		description: [ 'Text can not be empty here' ].
	self
		assert: [ aString isNotEmpty ]
		description: [ 'String must not be empty' ].

	aStream := aTextEditor segmentCollector newSegmentStream .

	self
		split: (aTextEditor text from: aTextIndex + 1 to: aTextIndex + aString size)
		in: aStream
		offset: aTextIndex.

	aTextEditor segmentCollector
		cachedSegmentAt: aTextIndex
		ifFound: [ :aSegment | aCurrentSegment := aSegment ]
		ifNotFound: [ ^ self ].

	theNewSegments := aCurrentSegment insert: aStream collection.
	theNewSegments size > 1
		ifTrue: [ aTextEditor segmentCollector addSegments: theNewSegments allButFirst after: aCurrentSegment in: aTextEditor ].

	aCurrentSegment moveTextPiecesBy: aString size at: aTextIndex.
	aTextEditor segmentCollector moveTextBy: aString size after: theNewSegments last.
	
	aTextEditor updater
		from: aCurrentSegment textStart to: aCurrentSegment textEnd;
		update
]

{ #category : #'text - modifications' }
AlbTextEditorLineSegmentBuilder >> removedAttributesFrom: aFromIndex to: aToIndex in: aTextEditor [

	"Is sent after an attributes were removed in provided text editor"

	| aFromSegment aToSegment |
	self halt.
	self assert: [ aFromIndex <= (aToIndex + 1) ] description: [ '`From` index must be less or equal to `to` index' ].

	aTextEditor segmentCollector
		cachedSegmentAt: aFromIndex
		ifFound: [ :aSegment | aFromSegment := aSegment ]
		ifNotFound: [  ].

	aTextEditor segmentCollector cachedSegmentAt: aToIndex ifFound: [ :aSegment | aToSegment := aSegment ] ifNotFound: [  ].

	"we remove attributes from something completely outside of the cached segments, just ignore it"
	(aFromSegment isNil or: [ aToSegment isNil ]) ifTrue: [ ^ self ].

	aTextEditor updater
		from: aFromSegment textStart to: aToSegment textEnd;
		update
]

{ #category : #'private - deletion' }
AlbTextEditorLineSegmentBuilder >> shouldMergeDeletingFrom: aFromIndex segment: aFromSegment in: aTextEditor [

	"Return true if we should merge a given segment with the previous if we delete a piece of
	text in a given editor starting from a provided index, false otherwise"

	<return: #Boolean>
	| aPreviousSegment |
	self halt.
	"A given segment is already the first one, there is no previous to merge with"
	aFromSegment index = 1 ifTrue: [ ^ false ].

	"when from index is less then segment start index it means we delete a line break symbol and therefore must merge"
	aFromIndex < aFromSegment textStart ifTrue: [ ^ true ].

	aPreviousSegment := aTextEditor segmentCollector segments at: aFromSegment index - 1.

	"if the difference between the end of the previous segment and the start of
	our deletion interval is 1 it means that we are trying to delete a line break symbol
	which is preceded by another line break"
	^ aFromIndex - aPreviousSegment textEnd = 1
]

{ #category : #splitting }
AlbTextEditorLineSegmentBuilder >> split: aText in: anEditorSegmentStream [
self halt.
	self splitter split: aText in: anEditorSegmentStream
]

{ #category : #splitting }
AlbTextEditorLineSegmentBuilder >> split: aText in: anEditorSegmentStream offset: anOffset [
self halt.
	self splitter split: aText in: anEditorSegmentStream offset: anOffset
]

{ #category : #accessing }
AlbTextEditorLineSegmentBuilder >> splitter [

	<return: #AlbTextEditorSplitter>
	^ lineSplitter
]

{ #category : #accessing }
AlbTextEditorLineSegmentBuilder >> splitter: aTextEditorSplitter [

	lineSplitter := aTextEditorSplitter
]

{ #category : #private }
AlbTextEditorLineSegmentBuilder >> validateIntegrity: aTextEditor [

	| anIntegrity |
	Bloc debugModeEnabled ifFalse: [ ^ self ].

	self validateTextPieceUniquenessIn: aTextEditor.

	anIntegrity := self validateSegmentsIn: aTextEditor.
	self assert: [ anIntegrity key ] description: [ anIntegrity value key ]
]

{ #category : #private }
AlbTextEditorLineSegmentBuilder >> validateSegmentsIn: aTextEditor [

	"Validate integrity of the segments.
	Return true if everything is ok, false otherwise"

	<return: #Symbol>
	| aPreviousSegment |
	aPreviousSegment := nil.

	aTextEditor segmentCollector segments do: [ :aTextEditorLineSegment | 
		(aTextEditorLineSegment isEmpty and: [ 
			 aTextEditorLineSegment textStart > 0 and: [ aTextEditorLineSegment textEnd > 0 ] ]) ifTrue: [ 
			^ false -> ('empty segment' -> aTextEditorLineSegment) ].

		aTextEditorLineSegment textStart > aTextEditorLineSegment textEnd ifTrue: [ 
			^ false -> ('start is bigger then end' -> aTextEditorLineSegment) ].

		aTextEditorLineSegment textLength < 1 ifTrue: [ ^ false -> ('segment has zero length' -> aTextEditorLineSegment) ].

		aPreviousSegment ifNotNil: [ 
			(aTextEditorLineSegment asString anySatisfy: #isLineBreak) ifTrue: [ 
				(aTextEditorLineSegment textLength = 1 and: [ (aTextEditorLineSegment text at: 1) isLineBreak ]) ifFalse: [ 
					^ false -> ('new line segment is broken' -> aTextEditorLineSegment) ] ].

			(aPreviousSegment asString anySatisfy: #isLineBreak) ifTrue: [ 
				(aPreviousSegment textLength = 1 and: [ (aPreviousSegment text at: 1) isLineBreak ]) ifFalse: [ 
					^ false -> ('new line segment is broken' -> aPreviousSegment) ] ].

			"both are new lines"
			((aTextEditorLineSegment asString anySatisfy: #isLineBreak) and: [ 
				 aPreviousSegment asString anySatisfy: #isLineBreak ]) ifTrue: [ 
				aTextEditorLineSegment textStart = (aPreviousSegment textEnd + 1) ifFalse: [ 
					^ false -> ('two new line segments are not in sync' -> { 
						   aPreviousSegment.
						   aTextEditorLineSegment }) ] ].

			"current segment is new line, previous one is not"
			((aTextEditorLineSegment asString anySatisfy: #isLineBreak) and: [ 
				 (aPreviousSegment asString anySatisfy: #isLineBreak) not ]) ifTrue: [ 
				aTextEditorLineSegment textStart = (aPreviousSegment textEnd + 1) ifFalse: [ 
					^ false -> ('new line segment is not in sync with the previous' -> { 
						   aPreviousSegment.
						   aTextEditorLineSegment }) ] ].

			"prevuous segment is a new line, current one is not"
			((aTextEditorLineSegment asString anySatisfy: #isLineBreak) not and: [ 
				 aPreviousSegment asString anySatisfy: #isLineBreak ]) ifTrue: [ 
				aTextEditorLineSegment textStart = (aPreviousSegment textEnd + 2) ifFalse: [ 
					^ false -> ('previous new line segment is not in sync with the current one' -> { 
						   aPreviousSegment.
						   aTextEditorLineSegment }) ] ].

			"both segments are not new lines"
			((aTextEditorLineSegment asString anySatisfy: #isLineBreak) not and: [ 
				 (aPreviousSegment asString anySatisfy: #isLineBreak) not ]) ifTrue: [ 
				aTextEditorLineSegment textStart = (aPreviousSegment textEnd + 2) ifFalse: [ 
					^ false -> ('two normal segments are not in sync' -> { 
						   aPreviousSegment.
						   aTextEditorLineSegment }) ] ] ].
		aPreviousSegment := aTextEditorLineSegment ].

	^ true -> 'ok'
]

{ #category : #private }
AlbTextEditorLineSegmentBuilder >> validateTextPieceUniquenessIn: aTextEditor [

	| allTextPieces allGroupedTextPieces |
	allTextPieces := Array streamContents: [ :aStream | 
		                 aTextEditor segmentCollector segments do: [ :eachSegment | 
			                 aStream nextPut: eachSegment.
			                 eachSegment hasPieces ifTrue: [ eachSegment pieces do: [ :eachPiece | aStream nextPut: eachPiece ] ] ] ].

	allGroupedTextPieces := OrderedIdentityDictionary new.
	allTextPieces do: [ :eachPiece | 
		(allGroupedTextPieces at: eachPiece text ifAbsentPut: [ OrderedCollection new ]) add: eachPiece ].

	allGroupedTextPieces := allGroupedTextPieces select: [ :aGroup | aGroup size > 1 ].
	self assert: [ allGroupedTextPieces isEmpty ] description: [ 'Some text pieces are not unique!' ]
]

{ #category : #'api - accessing' }
AlbTextEditorLineSegmentBuilder >> wordStencil: aWordStencilBuilder [
self halt.
	wordStencilBuilder := aWordStencilBuilder asStencilBuilder: AlbTextEditableWordPieceStencilBuilder
]

{ #category : #accessing }
AlbTextEditorLineSegmentBuilder >> wordStencilBuilder [

	<return: #AlbTextWordPieceStencil>
	self halt.
	^ wordStencilBuilder
]
