"
I represent a single text segment that is backed up by a sub text.
We split the whole text into segment in order to support infinite list that is used to render the whole text.

By default segment is a single line: a piece of text between new line characters
"
Class {
	#name : #AlbTextEditorSegment,
	#superclass : #Object,
	#traits : 'TAlbTextEditorTextualPiece + TBlDebug',
	#classTraits : 'TAlbTextEditorTextualPiece classTrait + TBlDebug classTrait',
	#instVars : [
		'index'
	],
	#category : 'Album-Model-Segment-Text'
}

{ #category : #'pieces - computation' }
AlbTextEditorSegment >> clearCache [
	"Clear all caches and make this segment fresh as if it would just be created and initalized"
]

{ #category : #accessing }
AlbTextEditorSegment >> index [
	"Return segment index within Editor.
	Note: index can not be nil"
	<return: #Number>
	
	self
		assert: [ index isNotNil ]
		description: [ 'Index can not be nil' ].

	^ index
]

{ #category : #accessing }
AlbTextEditorSegment >> index: aNumber [
	index := aNumber
]

{ #category : #initialization }
AlbTextEditorSegment >> initializeWith: aBlSubText from: aTextStart to: aTextEnd delimiter: aDelimiterLength [
	self
		assert: [ aBlSubText isKindOf: BlSubText ]
		description: [ 'Must be sub-text' ].

	text := aBlSubText.
	
	textStart := aTextStart.
	textEnd := aTextEnd.
	delimiterLength := aDelimiterLength.

	self clearCache.
	self updateSegmentProperties
]

{ #category : #'api - operations' }
AlbTextEditorSegment >> insert: aCollectionOfSegments [
	| theSegments theRestLength |
	<return: #Collection of: #AblTextEditorSegment>

	theSegments := { self }, aCollectionOfSegments allButFirst.

	theRestLength := self textLength - (aCollectionOfSegments first textStart - textStart).

	"when inserting multiple segments we just need to alter intervals of the first (myself)
	and the last inserted segments accordingly"
	self
		scopeText: self textStart
		end: aCollectionOfSegments first textEnd.

	delimiterLength := aCollectionOfSegments first delimiterLength.

	theSegments last
		scopeText: theSegments last textStart
		end: theSegments last textEnd + theRestLength.

	^ theSegments
]

{ #category : #testing }
AlbTextEditorSegment >> isAllLineBreak [
	"Return true if segment only consists of line break, false otherwise"
	<return: #Boolean>
	
	^ self text allSatisfy: #isLineBreak
]

{ #category : #testing }
AlbTextEditorSegment >> isFirstIn: aTextEditor [
	"Return true if I am absolutely the very first segment (not first cached) in a given text editor"

	^ self index = 1
]

{ #category : #testing }
AlbTextEditorSegment >> isLastIn: aTextEditor [
	"Return true if I am absolutely the very last segment (not last cached) in a given text editor"

	^ self index = aTextEditor segmentCollector segments size
]

{ #category : #testing }
AlbTextEditorSegment >> isLineBreak [
	"Return true if segment only consists of line break, false otherwise"
	<return: #Boolean>
	
	^ self text anySatisfy: #isLineBreak
]

{ #category : #'text - modifications' }
AlbTextEditorSegment >> moveTextBy: aNumber [
	"Move all sub-text pieces (#start and #end) known by the segment by a given amount of indicies.
	If aNumber is negative sub-texts will be moved to the left (maybe this is a result of a deletion).
	If aNumber is positive sub-texts will be moved to the right (maybe this is a result of an insertion).
	aNumber must not be zero - undefined behaviour (nothing was inserted but the message is sent? Probably a bug)"

	self start: textStart + aNumber end: textEnd + aNumber
]

{ #category : #'text - modifications' }
AlbTextEditorSegment >> moveTextPiecesBy: aNumber at: aTextIndex [
]

{ #category : #'text - modifications' }
AlbTextEditorSegment >> updateSegmentProperties [
]
