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
		'segmentBuilder',
		'segmentsInterval',
		'cacheLimit',
		'viewInterval'
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

{ #category : #'cache - accessing' }
AlbTextEditorSegmentCollector >> cachedAt: anIndex [
	"Return a cached segment at an absolute index within editor
	(I must convert index from editor coordiantes to my local cache coordinates)"
	<return: #AlbEditorSegment>
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

{ #category : #'cache - computation' }
AlbTextEditorSegmentCollector >> computeForwardAt: anIndex [
	| stream offset |
	"cumulative segments computing : old segments are kept, cacheLimit new segments are added "
	offset := segments ifEmpty: [0] ifNotEmpty: [segments last textEnd].
	stream := self newSegmentStream.
	stream skip: segments size.
	stream limit: self cacheLimit.
	
	segmentBuilder
		split: self text
		in: stream
		offset: 0.
	
	segments addAll: stream segments.
	self segments
		withIndexDo: [ :eachSegment :idx | eachSegment index: idx ].	
	segmentsInterval := (segments first index to: segments last index).
	self computeSubText
]

{ #category : #accessing }
AlbTextEditorSegmentCollector >> computeSegmentAt: anIndex [

	<return: #AlbEditorSegment>
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

	^ 50
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
	cacheLimit := self defaultCacheLimit.
	subText := BlSubText text: '' asRopedText from: 1 to: 0.
	self resetCache
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

{ #category : #accessing }
AlbTextEditorSegmentCollector >> newSegmentStream [
	^ AlbEditorSegmentStream new
]

{ #category : #'instance creation' }
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

{ #category : #initialization }
AlbTextEditorSegmentCollector >> resetCache [

	segmentsInterval := 0 to: 0.
	segments := self newSegments.

]

{ #category : #accessing }
AlbTextEditorSegmentCollector >> segmentAt: anIndex [
	"Return segment at given index"
	<return: #AlbEditorSegment>
	
	^ (self isCachedAt: anIndex)
		ifTrue: [ self cachedAt: anIndex ]
		ifFalse: [ self computeSegmentAt: anIndex ]
]

{ #category : #accessing }
AlbTextEditorSegmentCollector >> segmentBuilder [

	^ segmentBuilder
]

{ #category : #accessing }
AlbTextEditorSegmentCollector >> segmentBuilder: aSegmentBuilder [

	segmentBuilder := aSegmentBuilder
]

{ #category : #accessing }
AlbTextEditorSegmentCollector >> segments [
	<return: #SequenceableCollection of: #AlbEditorSegment>

	^ segments
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

{ #category : #accessing }
AlbTextEditorSegmentCollector >> viewInterval [
	^ viewInterval
]

{ #category : #accessing }
AlbTextEditorSegmentCollector >> viewInterval: anInterval [
	viewInterval := anInterval 
]
