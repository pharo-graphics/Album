Class {
	#name : #AlbTextEditorLineSplitter,
	#superclass : #AlbTextEditorSplitter,
	#category : #'Album-Model-Segment-Text-Line'
}

{ #category : #'instance creation' }
AlbTextEditorLineSplitter >> newSegment [
	^ AlbTextEditorLineSegment new
]

{ #category : #'instance creation' }
AlbTextEditorLineSplitter >> newSegment: aBlText from: aStartIndex to: anEndIndex delimited: aDelimiterIndex offset: anOffset [
	| aText anAbsoluteTextStart anAbsoluteTextEnd |
	"aStartIndex and anEndIndex are given in text coordinates"

	aText := aBlText
		from: aStartIndex
		to: anEndIndex.

	anAbsoluteTextStart := aStartIndex - 1.
	anAbsoluteTextEnd := anEndIndex.

	^ self newSegment
		initializeWith: aText
		from: anAbsoluteTextStart + anOffset
		to: anAbsoluteTextEnd + anOffset
		delimiter: aDelimiterIndex - anEndIndex
]

{ #category : #'api - splitting' }
AlbTextEditorLineSplitter >> split: aText in: aEditorSegmentStream offset: anOffset [
	| anIterator |

	aText isEmpty
		ifTrue: [ ^ aEditorSegmentStream nextPut: (self newSegment: aText from: 1 to: 0 delimited: 0 offset: anOffset) ].

	anIterator := aText iterator.

	[ anIterator hasNext and: [ aEditorSegmentStream wantsMore ] ] whileTrue: [
		anIterator
			nextLineIndicesDo: [ :aLineStart :aLineEnd :aLineDelimiterEnd |
				aEditorSegmentStream nextPut: (self newSegment: aText from: aLineStart to: aLineEnd delimited: aLineDelimiterEnd offset: anOffset) ]
			shouldMerge: [ :aLineStart :aLineEnd :aLineDelimiterEnd |
				(aText from: aLineEnd + 1 to: aLineDelimiterEnd) iterator
					detectAttribute: [ :eachAttribute | self wantsToMergeSegments: eachAttribute ]
					ifFound: [ true ]
					ifNone: [ false ] ] ].

	(aEditorSegmentStream wantsMore and: [ aText last isLineBreak ])
		ifTrue: [ aEditorSegmentStream nextPut: (self newSegment: aText from: aText size + 1 to: aText size delimited: aText size offset: anOffset) ]
]

{ #category : #testing }
AlbTextEditorLineSplitter >> wantsToMergeSegments: aTextAttribute [
	"Return true if a given attribute should merge segments and ignore a new line"
	<return: #Boolean>

	^ aTextAttribute isAdornment and: [ aTextAttribute shouldReplace ]
]
