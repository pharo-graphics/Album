Class {
	#name : #AlbEmbeddedEditorExamples,
	#superclass : #AlbTextEditorExamples,
	#traits : 'TAlbTextEditorFixedMeasurerExamples',
	#classTraits : 'TAlbTextEditorFixedMeasurerExamples classTrait',
	#category : #'Album-Examples-Editor'
}

{ #category : #'instance creation' }
AlbEmbeddedEditorExamples >> editorFor: aText [
	<return: #AlbEditor>
	| anEditor aRopedText |

	aRopedText := aText asRopedText lineSpacing: self lineSpacing; paragraphMargin: self paragraphMargin; wordPadding: self wordPadding.

	anEditor := AlbEditor new.
	anEditor aptitude: AlbEditorAptitude new.
	anEditor padding: BlInsets empty.
	anEditor fitContent.
	anEditor text: aRopedText.
	
	BlDevCrossover on: anEditor.
	
	anEditor editor segmentBuilder
		wordStencil: [ :aTAlbTextEditorTextualPiece |
			| aTextElement |
			aTextElement := AlbTextEditableWordPieceStencilBuilder new
				segmentPiece: aTAlbTextEditorTextualPiece;
				asElement.
			aTextElement measurer: self fixedMeasurer.
			aTextElement measurer textOffset: aTAlbTextEditorTextualPiece textStart.
			aTextElement ].
	
	anEditor requestFocus.
	anEditor forceLayout.

	^ anEditor
]

{ #category : #'examples - embedded' }
AlbEmbeddedEditorExamples >> editorWithEmbeddedEditor [
	<gtExample>

	^ self newEditor
		text: self textWithEmbeddedEditor;
		segmentBuilderDo: [ :aSegmentBuilder | self makeFixedMeasurement: aSegmentBuilder ]
]

{ #category : #'examples - embedded' }
AlbEmbeddedEditorExamples >> elementWithEmbeddedEditor [
	<gtExample>
	
	^ self newElement editor: self editorWithEmbeddedEditor
]

{ #category : #'private - instance creation' }
AlbEmbeddedEditorExamples >> embeddedEditorText [
	^ 'Hello world' asRopedText
]

{ #category : #'examples - embedded' }
AlbEmbeddedEditorExamples >> embeddedTextEditorElement [
	"<gtExample>"
	| anEditorElement |

	anEditorElement := AlbTextEditorOnObjectPrintStringExamples new elementOnObjectPrintString
		padding: (BlInsets all: 10);
		border: (BlBorder paint: Color gray);
		background: (Color gray alpha: 0.2);
		constraintsDo: [ :c |
			c horizontal fitContent.
			c vertical fitContent ].

	anEditorElement editor text: self embeddedEditorText.
	self makeFixedMeasurement: anEditorElement editor segmentBuilder.
	
	anEditorElement forceLayout.
	
	self assert: anEditorElement width equals: (self embeddedEditorText size * self glyphWidth).
	self assert: anEditorElement height equals: (self glyphHeight).

	^ anEditorElement
]

{ #category : #'private - instance creation' }
AlbEmbeddedEditorExamples >> mainEditorText [
	^ self newThreeLineText fontSize: 20
]

{ #category : #private }
AlbEmbeddedEditorExamples >> makeFixedMeasurement: aSegmentBuilder [

	aSegmentBuilder
		wordStencil: [ :aTAlbTextEditorTextualPiece |
			| aTextElement |
			aTextElement := AlbTextEditableWordPieceStencilBuilder new
				segmentPiece: aTAlbTextEditorTextualPiece;
				asElement.
			aTextElement measurer: self fixedMeasurer.
			aTextElement ]
]

{ #category : #'examples - embedded' }
AlbEmbeddedEditorExamples >> textWithEmbeddedEditor [
	<gtExample>
	| aText |

	aText := self mainEditorText.
	(aText from: 5 to: 5) attribute:
		(AlbTextAdornmentDynamicAttribute new
			beAppend;
			stencil: [
				| anEditorElement |
				anEditorElement := AlbTextEditorOnObjectPrintStringExamples new elementOnObjectPrintString
					padding: (BlInsets all: 10);
					border: (BlBorder paint: Color gray);
					background: (Color gray alpha: 0.2).

				anEditorElement editor text: self embeddedEditorText.
				self makeFixedMeasurement: anEditorElement editor segmentBuilder.
				anEditorElement ]).

	^ aText
]
