Class {
	#name : #AlbTextEditorAbstractSegmentSplitter,
	#superclass : #Object,
	#category : #'Album-Model-Segment'
}

{ #category : #'private - pieces computation' }
AlbTextEditorAbstractSegmentSplitter >> itemValueType: anObject [

	"Return a type of an item within a segment.
	Note: return value should be never used explicitely, it is only needed
	for direct comparison, therefore can be any immutable object"

	^ self subclassResponsibility
]

{ #category : #'private - pieces computation' }
AlbTextEditorAbstractSegmentSplitter >> processPureWords: aTextIterator in: aStream offset: anOffset [

	"Process a text within a scope of the given iterator as if it does not contain any adornment attributes
	nor event handling attributes. At this point we should just split it in words based on the text separator
	such as space or some other characters abnd create a text piece for each `word`"

	aTextIterator nextSegment: [ :aCharacter | self itemValueType: aCharacter ] indicesDo: [ :aStart :anEnd | 
		| aWord aTextStart aTextEnd |
		aWord := aTextIterator text from: (aStart + 1 min: anEnd) to: anEnd.

		aTextStart := aStart + anOffset.
		aTextEnd := anEnd + anOffset.
		(aWord allSatisfy: #isLineBreak) ifTrue: [ aTextEnd := aTextStart ].

		aStream nextPut: (self textPiece: aWord from: aTextStart to: aTextEnd) ]
]

{ #category : #'private - pieces computation' }
AlbTextEditorAbstractSegmentSplitter >> processSegment: aTextIterator in: aStream offset: anOffset [

	aTextIterator nextSpanIndicesDo: [ :aStart :anEnd | 
		| aSpanIterator aDelta |
		aSpanIterator := (aTextIterator text from: aStart to: anEnd) iterator.
		aDelta := aStart - 1 max: 0.
		[ aSpanIterator hasNext ] whileTrue: [ 
			self processWithOptionalEventHandlerAttributes: aSpanIterator in: aStream offset: anOffset + aDelta ] ]
]

{ #category : #'private - pieces computation' }
AlbTextEditorAbstractSegmentSplitter >> processWithOptionalEventHandlerAttributes: aTextIterator in: aStream offset: anOffset [
	"Process a text within the scope of the given iterator.
	We can split text into pieces based on the presence of event handling attributes. 
	Every combination of event handling elements should be a separate text piece with its own unique visual element"

	aTextIterator
		nextSpan: [ :eachAttribute | eachAttribute isEventHandler ]
		indicesDo: [ :aStart :anEnd :theEventHandlerAttributes | 
			| aSpan aSpanIterator aDelta |
			aSpan := aTextIterator text from: aStart to: anEnd.
			aSpanIterator := aSpan iterator.
			aDelta := (aStart - 1) max: 0.
			[ aSpanIterator hasNext ] whileTrue: [
				self processPureWords: aSpanIterator in: aStream offset: anOffset + aDelta ] ]
]

{ #category : #splitting }
AlbTextEditorAbstractSegmentSplitter >> split: aText from: aStartIndex to: anEndIndex [

	"aStartIndex and anEndIndex are given in cursor coordinates"

	^ Array streamContents: [ :stream | 
		  | lineIterator |
		  lineIterator := aText iterator.
		  [ lineIterator hasNext ] whileTrue: [ self processSegment: lineIterator in: stream offset: aStartIndex ].
		  stream size isZero ifTrue: [ 
			  stream nextPut: (self textPiece: (aText from: 1 to: aText size) from: aStartIndex to: anEndIndex) ] ]
]

{ #category : #splitting }
AlbTextEditorAbstractSegmentSplitter >> splitSegment: aTextEditorSegment [ 
	| thePieces |

	thePieces := self
		split: aTextEditorSegment text
		from: aTextEditorSegment textStart
		to: aTextEditorSegment textEnd.
	thePieces do: [ :eachPiece | eachPiece segment: aTextEditorSegment ].
	^ thePieces
]

{ #category : #'instance creation' }
AlbTextEditorAbstractSegmentSplitter >> textPiece: aBlSubText from: aTextStart to: aTextEnd [
	"Create and return a text segment piece"
	<return: #AlbTextEditorAbstractSegmentPiece>

	^ self textPieceClass new
		initializeWith: aBlSubText
		from: aTextStart
		to: aTextEnd
		delimiter: 0
]

{ #category : #accessing }
AlbTextEditorAbstractSegmentSplitter >> textPieceClass [
	"Create and return a text segment piece"
	<return: #TAblTextEditorTextualPiece>

	^ self subclassResponsibility 
]
