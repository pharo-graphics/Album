"
I collect and cache text line segments for fast access by index.

##Internal Representation and Key Implementation Points.

###Instance Variables

	editor 				<BrTextEditor>	The editor that owns this cache
	limit 					<Integer> The (soft) maximum number of segments in the cache, see below.
	map 					<BrTextLineMap> 	The line number to character index map
	segments 				<OrderedCollection of BrTextEditorLineSegment>		The cached segments
	segmentsInterval 	<Interval> 	The interval of line numbers cached in segments
	subText 				<BlSubText>
	text      			<BlText>		The text being edited

###Implementation Points

To facilitate jumping backwards quickly the the manager builds a map of line number to charcter offset of the string being edited.  When the target line number is earlier than the cache start the map can be used as a known point to start parsing forward from.


The limit represents the maximum number of items held by the receiver when an uncached segment is requested (`BrTextEditorSegmentCollector>>#segmentAt:}`).  If segments are added via `BrTextEditorSegmentCollector>>#addSegments:after:}` or `BrTextEditorSegmentCollector>>#addSegments:before:}` the limit may be safely exceeded.
"
Class {
	#name : #AlbTextEditorSegmentCollector,
	#superclass : #Object,
	#traits : 'TBlDebug',
	#classTraits : 'TBlDebug classTrait',
	#instVars : [
		'text',
		'subText',
		'segments',
		'segmentsInterval',
		'cacheLimit',
		'lineSplitter'
	],
	#category : #'Album-Model-Segment-Text'
}

{ #category : #'cache - adding / removing' }
AlbTextEditorSegmentCollector >> addSegments: aCollectionOfSegments after: aSegment in: aTextEditor [
	"Add the supplied collection of segments to the receiver after aSegment.
	This may safely cause the number of cached segments to exceed limit."

	self assertSegmentIndicesMustCorrespondToTheInterval.
	aCollectionOfSegments withIndexDo: [ :aNewSegment :anIndex |
		aNewSegment index: anIndex + aSegment index.
		self segments
			add: aNewSegment
			afterIndex: aSegment index - self firstIndex + anIndex ].
	
	self offsetSegmentIndicesBy: aCollectionOfSegments size after: aCollectionOfSegments last index.
	self assertSegmentIndicesMustCorrespondToTheInterval.
	aTextEditor notifyItemsInserted: (aCollectionOfSegments first index to: aCollectionOfSegments last index).
]

{ #category : #'cache - adding / removing' }
AlbTextEditorSegmentCollector >> addSegments: aCollectionOfSegments before: aSegment in: aTextEditor [
	"Add the supplied collection of segments to the receiver before aSegment.
	This may safely cause the number of cached segments to exceed limit."

	self
		assert: [ aCollectionOfSegments isNotEmpty ]
		description: [ 'Can not add a collection of empty segments!' ].
	
	self assertSegmentIndicesMustCorrespondToTheInterval.

	aCollectionOfSegments withIndexDo: [ :aNewSegment :anIndex |
		aNewSegment index: (aSegment index - aCollectionOfSegments size) + anIndex.
		self segments
			add: aNewSegment
			afterIndex: aNewSegment index - 1 ].
	
	self offsetSegmentIndicesBy: aCollectionOfSegments size after: aCollectionOfSegments last index.
	aTextEditor notifyItemsInserted: (aCollectionOfSegments first index to: aCollectionOfSegments last index).
	
	self assertSegmentIndicesMustCorrespondToTheInterval.

]

{ #category : #'text - modifications' }
AlbTextEditorSegmentCollector >> addedAttribute: anAttribute from: aFromIndex to: aToIndex in: aTextEditor [

	"Is sent after an attribute was added in provided text editor"

	| aFromSegment aToSegment |
	self assert: [ aFromIndex <= (aToIndex + 1) ] description: [ '`From` index must be less or equal to `to` index' ].

	self
		cachedSegmentAt: aFromIndex
		ifFound: [ :aSegment | aFromSegment := aSegment ]
		ifNotFound: [  ].

	self cachedSegmentAt: aToIndex ifFound: [ :aSegment | aToSegment := aSegment ] ifNotFound: [  ].

	"we add attribute to something completely outside of the cached segments, just ignore it"
	(aFromSegment isNil or: [ aToSegment isNil ]) ifTrue: [ ^ self ].

	aTextEditor updater
		from: aFromSegment textStart to: aToSegment textEnd;
		update
]

{ #category : #'cache - adding / removing' }
AlbTextEditorSegmentCollector >> assertSegmentIndicesMustCorrespondToTheInterval [
	self
		assert: [ self segments size = segmentsInterval size ]
		description: [ 'Amount of segments must correspond to the interval' ].

	self
		assert: [
			| satisfy |
			satisfy := true.
			self segments with: segmentsInterval do: [ :eachSegment :anExpectedIndex |
				satisfy := satisfy and: [ eachSegment index = anExpectedIndex ]	].
			satisfy ]
		description: [ 'Segment indices must correspond to the interval' ].

		
	
]

{ #category : #accessing }
AlbTextEditorSegmentCollector >> cacheLimit [
	^ cacheLimit
]

{ #category : #accessing }
AlbTextEditorSegmentCollector >> cacheLimit: anInteger [
	cacheLimit = anInteger ifTrue: [ ^self ].
	self resetCache.
	cacheLimit := anInteger.
	self computeForwardAt: 1
]

{ #category : #accessing }
AlbTextEditorSegmentCollector >> cacheSize: anInteger [
	self cacheLimit: anInteger
]

{ #category : #'cache - accessing' }
AlbTextEditorSegmentCollector >> cachedAt: anIndex [
	"Return a cached segment at an absolute index within editor
	(I must convert index from editor coordinates to my local cache coordinates)"
	<return: #AlbTextEditorSegment>
	
	| aCachedIndex |
	aCachedIndex := anIndex - segmentsInterval first + 1.
	^ self segments at: aCachedIndex
]

{ #category : #accessing }
AlbTextEditorSegmentCollector >> cachedInterval [
	"Return the interval of the indices of the currently cached segments"
	<return: #Number>

	^ segmentsInterval
]

{ #category : #'cache - accessing' }
AlbTextEditorSegmentCollector >> cachedSegmentAt: aTextIndex ifFound: aFoundBlock ifNotFound: aNotFoundBlock [
	| segmentIndex segment |

	segmentIndex := self cachedSegmentIndexAt: aTextIndex.
	
	"if segment index is zero it means that text was modified outsize of currently cached elements"
	segmentIndex isZero
		"we should handle the case when text was inserted at index before a #start
		of the first segment. when it happens we need to move all cached segments"
		ifTrue: [ ^ aNotFoundBlock cull: self ].

	(self isCachedAt: segmentIndex) ifFalse:
		[ ^ aNotFoundBlock cull: self ].

	segment := self cachedAt: segmentIndex.
	
	self
		assert: [ segment index = segmentIndex ]
		description: [ 'Segment must have a valid index' ].
		
	aFoundBlock cull: segment
]

{ #category : #'cache - accessing' }
AlbTextEditorSegmentCollector >> cachedSegmentIndexAt: aTextIndex [
	"Return an index of a segment in a collection of cached segments that contains
	a text item with a given index or return 0 if no such *cached* segment exists.
	I use binary search to find a segment, algorithmic complexity O(log n)"
	<return: #Number>

	^ self segments
		findBinaryIndex: [ :aSegment |
			(aTextIndex between: aSegment textStart and: aSegment textEnd)
				ifTrue: [ 0 ]
				ifFalse: [
					aTextIndex < aSegment textStart
						ifTrue: [ -1 ]
						ifFalse: [ 1 ] ] ]
		ifNone: [ :a :b |
			| anAssoc |
			
			anAssoc := (self segments
				at: a
				ifAbsent: [ nil ]) -> a.
			
			anAssoc key ifNil: [
				anAssoc := (self segments
					at: b
					ifAbsent: [ nil ]) -> b. ].

			anAssoc key
				ifNil: [ 0 ]
				ifNotNil: [ :aSegment |
					(aTextIndex between: aSegment textStart and: aSegment textEndDelimited)
						ifTrue: [ anAssoc value ]
						ifFalse: [ 0 ] ] ]
]

{ #category : #'cache - adding / removing' }
AlbTextEditorSegmentCollector >> computeForwardAt: anIndex [

	| stream newSegments idx currSize seg |
	"cumulative segments computing : old segments are kept, cacheLimit new segments are added "
	stream := self newSegmentStream.
	stream skip: segments size.
	stream limit: cacheLimit.

	self split: self text in: stream offset: 0.
	"get the stream result directly (without copying)"
	newSegments := stream rawSegments.
	currSize := segments size.
	"newSegment is an Array"
	newSegments ifEmpty: [ ^ self ].
	"A loop to set the index to each new segment"
	idx := 1.
	seg := newSegments at: idx.
	[ seg notNil and: [idx < newSegments size]] whileTrue: [ 
		seg index: currSize + idx.
		idx := idx + 1.
		seg := newSegments at: idx
	 ].
	segments addAll: (newSegments copyFrom: 1 to: idx - 1).

	segmentsInterval := segments first index to: segments last index.
	self computeSubText
]

{ #category : #'private - computing' }
AlbTextEditorSegmentCollector >> computeSegmentAt: anIndex [

	<return: #AlbTextEditorSegment>
	self
		assert: [ (self isCachedAt: anIndex) not ]
		description: [ 'Computing of already cached segment is wasteful' ].
	anIndex > self lastIndex ifTrue: [ self computeForwardAt: anIndex ].
	self
		assert: [ self isCachedAt: anIndex ]
		description: [ 'Segment must be already cached!' ].

	^ self cachedAt: anIndex
]

{ #category : #'private - computing' }
AlbTextEditorSegmentCollector >> computeSubText [
	"Recompute subtext according to currently cached segments"
	| subTextStart subTextEnd |

	self
		assert: [ self hasCached ]
		description: [ 'There must be cached segments in order to compute sub text' ].

	subTextStart := segments first textStart + 1.
	subTextEnd := segments last textEnd + 1.
	"Allow for the fact that the last line in the string may not have a line-end character"
	subTextEnd > text size ifTrue: [ subTextEnd := subTextEnd - 1 ].
	subText := text from: subTextStart to: subTextEnd.

	"The following assertion should always be true, but is very expensive.
	Only used if a problem is suspected."
	self flag: 'To check because in case of a Replacement Adornment, the assertion fails'.
	"self assert: subText asString lines size <= segments size."
]

{ #category : #'cache - accessing' }
AlbTextEditorSegmentCollector >> computedSegmentsCount [
	"Return amount of cached segments. If segments are not cached,
	try to cache them and return their amount"
	<return: #Number>
	
	self hasCached
		ifFalse: [ self computeForwardAt: 1 ].
		
	^ self lastIndex
]

{ #category : #initialization }
AlbTextEditorSegmentCollector >> defaultCacheLimit [

	"Arbitrary value "
	^ 50
]

{ #category : #initialization }
AlbTextEditorSegmentCollector >> defaultSplitter [

	^ AlbTextEditorLineSplitter new
]

{ #category : #'private - deletion' }
AlbTextEditorSegmentCollector >> deleteFrom: aFromIndex segment: aFromSegment to: aToIndex segment: aToSegment in: aTextEditor [
	"I do the hard work of updating segment structure after deleting a piece of text within provided interval and segments"
	| shouldMergeWithPrevious aTargetSegment removedLength aNewEnd aNewStart |
	
	shouldMergeWithPrevious := self
		shouldMergeDeletingFrom: aFromIndex
		segment: aFromSegment
		in: aTextEditor.

	aTargetSegment := shouldMergeWithPrevious
		ifTrue: [ self segments at: (aFromSegment index - 1) ]
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

			self removeSegmentInterval: (removeSegmentStart to: removeSegmentEnd) in: aTextEditor ].
	
	aTargetSegment moveTextPiecesBy: removedLength negated at: aFromIndex.
	self
		moveTextBy: removedLength negated
		after: aTargetSegment.
		
	^ aTargetSegment
]

{ #category : #'text - modifications' }
AlbTextEditorSegmentCollector >> deletedFrom: aFromIndex to: aToIndex in: aTextEditor [
	| aFromSegment aToSegment aTargetSegment |

	self
		assert: [ aFromIndex <= aToIndex ]
		description: [ '`From` index must be less or equal to `to` index' ].

	self
		cachedSegmentAt: aFromIndex
		ifFound: [ :aSegment | aFromSegment := aSegment ]
		ifNotFound: [ ].

	self
		cachedSegmentAt: aToIndex
		ifFound: [ :aSegment | aToSegment := aSegment ]
		ifNotFound: [ ].

	(aFromSegment isNil or: [ aToSegment isNil ])	ifTrue: [ | interval |
			"Either aFromIndex or aToIndex are outside the segment collector's cache.
			It looks like the text editor's text has already been updated, 
			simply reset the cache and notify the editor"
			interval := self cachedInterval.
			self resetCache.
			aTextEditor notifyItemsRemoved: interval.
			^ self ].

	aTargetSegment := self deleteFrom: aFromIndex segment: aFromSegment to: aToIndex segment: aToSegment in: aTextEditor.

	aTextEditor updater
		from: aTargetSegment textStart to: aTargetSegment textEnd;
		update
]

{ #category : #'cache - accessing' }
AlbTextEditorSegmentCollector >> end [
	"Return the index of the last cached item in the text or 0 if nothing is cached"
	<return: #Number>
	
	^ self hasCached
		ifTrue: [ subText end ]
		ifFalse: [ 0 ]
]

{ #category : #'cache - accessing' }
AlbTextEditorSegmentCollector >> firstIndex [
	"Return the index of the first cached segment or 0 if there are no cached segments"
	<return: #Number>
	
	^ self hasCached
		ifTrue: [ segments first index ]
		ifFalse: [ 0 ]
]

{ #category : #testing }
AlbTextEditorSegmentCollector >> hasCached [
	"Return true if there are cached segments, false otherwise"
	<return: #Boolean>

	^ segments isNotEmpty
]

{ #category : #initialization }
AlbTextEditorSegmentCollector >> initialize [

	super initialize.
	lineSplitter := self defaultSplitter.

	cacheLimit := self defaultCacheLimit.
	subText := BlSubText text: '' asRopedText from: 1 to: 0.
	self resetCache
]

{ #category : #'text - modifications' }
AlbTextEditorSegmentCollector >> insertedString: aString at: aTextIndex in: aTextEditor [

	"I am doing a hard work updating editor's segment cache due to inserted string.
	Note: This is an *algorithm* that should be very performant, that is why we don't see
	a point in doing it in OOP style, procedural way fits quite well"

	| currentSegment stream newSegments |
	self assert: [ aTextEditor privateText isNotEmpty ] description: [ 'Text can not be empty here' ].
	self assert: [ aString isNotEmpty ] description: [ 'String must not be empty' ].

	stream := self newSegmentStream.

	self split: (aTextEditor privateText from: aTextIndex + 1 to: aTextIndex + aString size) in: stream offset: aTextIndex.

	self cachedSegmentAt: aTextIndex ifFound: [ :aSegment | currentSegment := aSegment ] ifNotFound: [ ^ self ].

	newSegments := currentSegment insert: stream collection.
	newSegments size > 1 ifTrue: [ self addSegments: newSegments allButFirst after: currentSegment in: aTextEditor ].

	currentSegment moveTextPiecesBy: aString size at: aTextIndex.
	self moveTextBy: aString size after: newSegments last.

	aTextEditor updater
		from: currentSegment textStart to: currentSegment textEnd;
		update
]

{ #category : #testing }
AlbTextEditorSegmentCollector >> isCachedAt: anIndex [
	"Return true if I have a cached segment at a given index, false otherwise"
	<return: #Boolean>

	^ segmentsInterval rangeIncludes: anIndex
]

{ #category : #'cache - accessing' }
AlbTextEditorSegmentCollector >> lastIndex [
	"Return the index of the last cached segment or 0 if there are no cached segments"
	<return: #Number>
	
	^ self hasCached
		ifTrue: [ segments last index ]
		ifFalse: [ 0 ]
]

{ #category : #'text - modifications' }
AlbTextEditorSegmentCollector >> moveTextBy: aNumber [
	"move all segments' subTexts start/end indices by aNumber"

	self hasCached
		ifFalse: [ ^ self ].
	
	self segments do: [ :aSegment | aSegment moveTextBy: aNumber ].
	self computeSubText
]

{ #category : #'text - modifications' }
AlbTextEditorSegmentCollector >> moveTextBy: aNumber after: aSegment [
	"move all segments after the given segment by aNumber"

	aSegment index + 1 to: self segments size do: [ :anIndex |
		| eachSegment |
		eachSegment := self cachedAt: anIndex.
		eachSegment moveTextBy: aNumber ].
	
	self computeSubText
]

{ #category : #private }
AlbTextEditorSegmentCollector >> newSegmentStream [
	^ AlbEditorSegmentStream new
]

{ #category : #private }
AlbTextEditorSegmentCollector >> newSegments [

	"Return a new empty collection that will be used to store segments"

	<return: #SequenceableCollection>
	^ OrderedCollection new
]

{ #category : #'text - modifications' }
AlbTextEditorSegmentCollector >> offsetSegmentIndicesBy: anOffset [
	"Offset segments' #index by anOffset of all cached segments"
	
	self
		offsetSegmentIndicesBy: anOffset
		after: self firstIndex - 1
]

{ #category : #'text - modifications' }
AlbTextEditorSegmentCollector >> offsetSegmentIndicesBy: anOffset after: aSegmentIndex [
	"Offset segments' #index by anOffset of all segments after a given segment index.
	Note: #lastIndex is not valid during execution of this method!"
	
	self
		assert: [ aSegmentIndex + 1 >= self firstIndex ]
		description: [ 'Segment index must be greater or equal first segment index ' ].
		
	(aSegmentIndex + 1 to: self segments size + self firstIndex - 1) do: [ :anIndex |
		| aSegment |
		
		aSegment := self segments at: anIndex - self firstIndex + 1.
		aSegment index: aSegment index + anOffset ].
	
	"actual cached interval changed, update it"
	segmentsInterval := segmentsInterval first to: segmentsInterval last + anOffset
]

{ #category : #'cache - adding / removing' }
AlbTextEditorSegmentCollector >> removeSegmentInterval: anInterval in: aTextEditor [
	"Remove all segments within index interval"

	anInterval reverseDo: [ :anIndex | self segments removeAt: anIndex ].
	
	self segments
		withIndexDo: [ :eachSegment :anIndex | eachSegment index: anIndex ].	
	segmentsInterval := (segments first index to: segments last index).

	aTextEditor notifyItemsRemoved: anInterval
]

{ #category : #'text - modifications' }
AlbTextEditorSegmentCollector >> removedAttributesFrom: aFromIndex to: aToIndex in: aTextEditor [

	"Is sent after an attributes were removed in provided text editor"

	| aFromSegment aToSegment |
	self assert: [ aFromIndex <= (aToIndex + 1) ] description: [ '`From` index must be less or equal to `to` index' ].

	self
		cachedSegmentAt: aFromIndex
		ifFound: [ :aSegment | aFromSegment := aSegment ]
		ifNotFound: [  ].

	self cachedSegmentAt: aToIndex ifFound: [ :aSegment | aToSegment := aSegment ] ifNotFound: [  ].

	"we remove attributes from something completely outside of the cached segments, just ignore it"
	(aFromSegment isNil or: [ aToSegment isNil ]) ifTrue: [ ^ self ].

	aTextEditor updater
		from: aFromSegment textStart to: aToSegment textEnd;
		update
]

{ #category : #initialization }
AlbTextEditorSegmentCollector >> resetCache [

	segmentsInterval := 0 to: 0.
	segments := self newSegments.

]

{ #category : #accessing }
AlbTextEditorSegmentCollector >> segmentAt: anIndex [
	"Return segment at given index"
	<return: #AlbTextEditorSegment>
	
	^ (self isCachedAt: anIndex)
		ifTrue: [ self cachedAt: anIndex ]
		ifFalse: [ self computeSegmentAt: anIndex ]
]

{ #category : #accessing }
AlbTextEditorSegmentCollector >> segments [
	<return: #SequenceableCollection of: #AlbTextEditorSegment>

	^ segments
]

{ #category : #'private - deletion' }
AlbTextEditorSegmentCollector >> shouldMergeDeletingFrom: aFromIndex segment: aFromSegment in: aTextEditor [

	"Return true if we should merge a given segment with the previous if we delete a piece of
	text in a given editor starting from a provided index, false otherwise"

	<return: #Boolean>
	| aPreviousSegment |
	"A given segment is already the first one, there is no previous to merge with"
	aFromSegment index = 1 ifTrue: [ ^ false ].

	"when from index is less then segment start index it means we delete a line break symbol and therefore must merge"
	aFromIndex < aFromSegment textStart ifTrue: [ ^ true ].

	aPreviousSegment := self segments at: aFromSegment index - 1.

	"if the difference between the end of the previous segment and the start of
	our deletion interval is 1 it means that we are trying to delete a line break symbol
	which is preceded by another line break"
	^ aFromIndex - aPreviousSegment textEnd = 1
]

{ #category : #'api - splitting' }
AlbTextEditorSegmentCollector >> split: aText in: anEditorSegmentStream [

	lineSplitter split: aText in: anEditorSegmentStream
]

{ #category : #'api - splitting' }
AlbTextEditorSegmentCollector >> split: aText in: anEditorSegmentStream offset: anOffset [

	lineSplitter split: aText in: anEditorSegmentStream offset: anOffset
]

{ #category : #'cache - accessing' }
AlbTextEditorSegmentCollector >> start [
	"Return the index of the first cached item in the text or 0 if nothing is cached"
	<return: #Number>

	^ self hasCached
		ifTrue: [ subText start ]
		ifFalse: [ 0 ]
]

{ #category : #accessing }
AlbTextEditorSegmentCollector >> subText [
	^ subText 
]

{ #category : #accessing }
AlbTextEditorSegmentCollector >> text [
	<return: #BlText>

	^ text
]

{ #category : #accessing }
AlbTextEditorSegmentCollector >> text: aText [
	text := aText.
	self computeForwardAt: 1
]

{ #category : #private }
AlbTextEditorSegmentCollector >> validateIntegrity: aTextEditor [

	| anIntegrity |
	Bloc debugModeEnabled ifFalse: [ ^ self ].

	self validateTextPieceUniquenessIn: aTextEditor.

	anIntegrity := self validateSegmentsIn: aTextEditor.
	self assert: [ anIntegrity key ] description: [ anIntegrity value key ]
]

{ #category : #private }
AlbTextEditorSegmentCollector >> validateSegmentsIn: aTextEditor [

	"Validate integrity of the segments.
	Return true if everything is ok, false otherwise"

	<return: #Symbol>
	| aPreviousSegment |
	aPreviousSegment := nil.

	self segments do: [ :aTextEditorLineSegment | 
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
AlbTextEditorSegmentCollector >> validateTextPieceUniquenessIn: aTextEditor [

	| allTextPieces allGroupedTextPieces |
	allTextPieces := Array streamContents: [ :aStream | 
		                 self segments do: [ :eachSegment | 
			                 aStream nextPut: eachSegment.
			                 eachSegment hasPieces ifTrue: [ eachSegment pieces do: [ :eachPiece | aStream nextPut: eachPiece ] ] ] ].

	allGroupedTextPieces := OrderedIdentityDictionary new.
	allTextPieces do: [ :eachPiece | 
		(allGroupedTextPieces at: eachPiece text ifAbsentPut: [ OrderedCollection new ]) add: eachPiece ].

	allGroupedTextPieces := allGroupedTextPieces select: [ :aGroup | aGroup size > 1 ].
	self assert: [ allGroupedTextPieces isEmpty ] description: [ 'Some text pieces are not unique!' ]
]
