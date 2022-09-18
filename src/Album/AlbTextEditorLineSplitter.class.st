"
I split a piece of text into line segments `BrTextEditorLineSegment`
"
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
	| aSubText anAbsoluteTextStart anAbsoluteTextEnd |
	"aStartIndex and anEndIndex are given in text coordinates"

	aSubText := aBlText
		from: aStartIndex
		to: anEndIndex.

	anAbsoluteTextStart := aStartIndex - 1.
	anAbsoluteTextEnd := anEndIndex.

	^ self newSegment
		initializeWith: aSubText
		from: anAbsoluteTextStart + anOffset
		to: anAbsoluteTextEnd + anOffset
		delimiter: aDelimiterIndex - anEndIndex
]

{ #category : #'api - splitting' }
AlbTextEditorLineSplitter >> split: aText in: aEditorSegmentStream offset: anOffset [

	| anIterator |
	aText isEmpty ifTrue: [ 
		^ aEditorSegmentStream nextPut: (self
				   newSegment: aText
				   from: 1
				   to: 0
				   delimited: 0
				   offset: anOffset) ].

	anIterator := aText iterator.

	[ anIterator hasNext and: [ aEditorSegmentStream wantsMore ] ] whileTrue: [ 
		anIterator
			nextLineIndicesDo: [ :aLineStart :aLineEnd :aLineDelimiterEnd | 
				aEditorSegmentStream nextPut: (self
						 newSegment: aText
						 from: aLineStart
						 to: aLineEnd
						 delimited: aLineDelimiterEnd
						 offset: anOffset) ] ].

	(aEditorSegmentStream wantsMore and: [ aText last isLineBreak ]) ifTrue: [ 
		aEditorSegmentStream nextPut: (self
				 newSegment: aText
				 from: aText size + 1
				 to: aText size
				 delimited: aText size
				 offset: anOffset) ]
]
