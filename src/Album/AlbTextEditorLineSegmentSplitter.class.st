"
I split a piece of text behind a `BrTextEditorLineSegment` into pieces `BrTextEditorLineSegmentPiece`
"
Class {
	#name : #AlbTextEditorLineSegmentSplitter,
	#superclass : #AlbTextEditorAbstractSegmentSplitter,
	#instVars : [
		'privateCount'
	],
	#category : #'Album-Model-Segment-Text-Line'
}

{ #category : #'private - pieces computation' }
AlbTextEditorLineSegmentSplitter >> itemValueType: anObject [

	"Return a type of an item within a segment.
	Note: return value should be never used explicitely, it is only needed
	for direct comparison, therefore can be any immutable object"

	<return: #Symbol>
	^ anObject isCharacter
		  ifTrue: [ 
			  anObject isSeparator
				  ifTrue: [ privateCount := privateCount + 1 ]
				  ifFalse: [ 
					  anObject isSpecial
						  ifTrue: [ privateCount := privateCount + 1 ]
						  ifFalse: [ #letter ] ] ]
		  ifFalse: [ #object ]
]

{ #category : #'private - pieces computation' }
AlbTextEditorLineSegmentSplitter >> processPureWords: aTextIterator in: aStream offset: anOffset [

	"Process a text within a scope of the given iterator as if it does not contain any adornment attributes
	nor event handling attributes. At this point we should just split it in words based on the text separator
	such as space or some other characters abnd create a text piece for each `word`"

	"tabCount is only used to separate each tab as a word with only the tab char"

	privateCount := 0.
	super processPureWords: aTextIterator in: aStream offset: anOffset
]

{ #category : #accessing }
AlbTextEditorLineSegmentSplitter >> textPieceClass [
	"Create and return a text segment piece"
	<return: #TAblTextEditorTextualPiece>

	^ AlbTextEditorLineSegmentTextPiece
]
