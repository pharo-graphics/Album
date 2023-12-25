Class {
	#name : #AlbTextEditorLineSegmentSplitter,
	#superclass : #Object,
	#instVars : [
		'characterClassifier',
		'privateCount'
	],
	#category : 'Album-Model-Segment'
}

{ #category : #'splitting configuration' }
AlbTextEditorLineSegmentSplitter >> beCharacterBased [

	characterClassifier := self characterBasedClassifier
]

{ #category : #'splitting configuration' }
AlbTextEditorLineSegmentSplitter >> beSeparatorBased [

	characterClassifier := self separatorBasedClassifier
]

{ #category : #'splitting configuration' }
AlbTextEditorLineSegmentSplitter >> characterBasedClassifier [

	"Return a block that compute a type of an item within a segment.
	Note: return value should be never used explicitely, it is only needed
	for direct comparison, therefore can be any immutable object"
	
	" This one is used to compute one segment per character.
	the text editing performance decrease but line computation is adapted for soft line in a textfield "

	^ [ :obj | self privateCount ]
]

{ #category : #accessing }
AlbTextEditorLineSegmentSplitter >> characterClassifier [

	^ characterClassifier
]

{ #category : #accessing }
AlbTextEditorLineSegmentSplitter >> characterClassifier: aValuable [


	"aValuable compute a type of an item within a segment.
	Basically, it is a block that takes an item (a character) as unique argument.
	Note: return value should be never used explicitely, it is only needed
	for direct comparison, therefore can be any immutable object"
	
	characterClassifier := aValuable
]

{ #category : #initialization }
AlbTextEditorLineSegmentSplitter >> defaultCharacterClassifier [

	"Return a block that compute a type of an item within a segment.
	Note: return value should be never used explicitely, it is only needed
	for direct comparison, therefore can be any immutable object"

	^ self separatorBasedClassifier
]

{ #category : #initialization }
AlbTextEditorLineSegmentSplitter >> initialize [

	super initialize.
	privateCount := 0.
	characterClassifier := self defaultCharacterClassifier 

]

{ #category : #'private - pieces computation' }
AlbTextEditorLineSegmentSplitter >> itemValueType: anObject [

	"Return a type of an item within a segment.
	Note: return value should be never used explicitely, it is only needed
	for direct comparison, therefore can be any immutable object"

	^ self characterClassifier value: anObject
]

{ #category : #'private - pieces computation' }
AlbTextEditorLineSegmentSplitter >> privateCount [

	^  privateCount := privateCount + 1
]

{ #category : #'private - pieces computation' }
AlbTextEditorLineSegmentSplitter >> processPureWords: aTextIterator in: aStream offset: anOffset [

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
AlbTextEditorLineSegmentSplitter >> processSegment: aTextIterator in: aStream offset: anOffset [		
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

{ #category : #'splitting configuration' }
AlbTextEditorLineSegmentSplitter >> separatorBasedClassifier [

	"Return a block that compute a type of an item within a segment.
	Note: return value should be never used explicitely, it is only needed
	for direct comparison, therefore can be any immutable object"

	^ [ :obj | obj isCharacter
		  ifTrue: [ 
			  obj isSeparator
				  ifTrue: [ self privateCount ]
				  ifFalse: [ #letter ] ] 
		  ifFalse: [ #object ] ]
]

{ #category : #splitting }
AlbTextEditorLineSegmentSplitter >> split: aText from: aStartIndex to: anEndIndex [

	"aStartIndex and anEndIndex are given in cursor coordinates"

	^ Array streamContents: [ :stream | 
		  | lineIterator |
		  lineIterator := aText iterator.
		  [ lineIterator hasNext ] whileTrue: [ self processSegment: lineIterator in: stream offset: aStartIndex ].
		  stream size isZero ifTrue: [ 
			  stream nextPut: (self textPiece: (aText from: 1 to: aText size) from: aStartIndex to: anEndIndex) ] ]
]

{ #category : #splitting }
AlbTextEditorLineSegmentSplitter >> splitSegment: aTextEditorSegment [

	| thePieces |
	thePieces := self
		             split: aTextEditorSegment text
		             from: aTextEditorSegment textStart
		             to: aTextEditorSegment textEnd.
	thePieces do: [ :eachPiece | eachPiece segment: aTextEditorSegment ].
	^ thePieces
]

{ #category : #'instance creation' }
AlbTextEditorLineSegmentSplitter >> textPiece: aBlSubText from: aTextStart to: aTextEnd [
	"Create and return a text segment piece"
	<return: #AlbTextEditorAbstractSegmentPiece>

	^ self textPieceClass new
		initializeWith: aBlSubText
		from: aTextStart
		to: aTextEnd
		delimiter: 0
]

{ #category : #accessing }
AlbTextEditorLineSegmentSplitter >> textPieceClass [
	"Create and return a text segment piece"

	^ AlbTextEditorLineSegmentTextPiece
]
