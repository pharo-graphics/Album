Class {
	#name : #AlbEmbeddedEditorExamples,
	#superclass : #AlbTextEditorExamples,
	#traits : 'TAlbTextEditorFixedMeasurerExamples',
	#classTraits : 'TAlbTextEditorFixedMeasurerExamples classTrait',
	#category : #'Album-Examples-Editor'
}

{ #category : #'instance creation' }
AlbEmbeddedEditorExamples >> editorFor: aText [
	<return: #AlbEditorElement>
	| anEditor aRopedText |

	aRopedText := aText asRopedText lineSpacing: self lineSpacing; paragraphMargin: self paragraphMargin; wordPadding: self wordPadding.

	anEditor := AlbEditorElement new.
	anEditor padding: BlInsets empty.
	anEditor fitContent.
	anEditor text: aRopedText.
	
	BlDevCrossover on: anEditor.
	
	anEditor editor
		wordStencil: [ :aTAlbTextEditorTextualPiece |
			| aTextElement |
			aTextElement := AlbTextWordPieceStencil editable
				segmentPiece: aTAlbTextEditorTextualPiece;
				asElement.
			aTextElement measurer: self fixedMeasurer.
			aTextElement measurer textOffset: aTAlbTextEditorTextualPiece textStart.
			aTextElement ].
	
	anEditor requestFocus.
	"anEditor forceLayout."

	^ anEditor
]

{ #category : #'examples - embedded' }
AlbEmbeddedEditorExamples >> editorWithEmbeddedEditor [

	<gtExample>
	| ed |
	ed := self newEditor privateText: self textWithEmbeddedEditor.
	self makeFixedMeasurement: ed.
	^ ed
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
	self makeFixedMeasurement: anEditorElement editor.
	
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
AlbEmbeddedEditorExamples >> makeFixedMeasurement: aTextEditor [

	aTextEditor
		wordStencil: [ :aTAlbTextEditorTextualPiece |
			| aTextElement |
			aTextElement := AlbTextWordPieceStencil editable
				segmentPiece: aTAlbTextEditorTextualPiece;
				asElement.
			aTextElement measurer: self fixedMeasurer.
			aTextElement ]
]

{ #category : #'examples - embedded' }
AlbEmbeddedEditorExamples >> newThreeLineText [
	<gtExample>
	
	^ ('first' , String cr , 'second' , String cr , 'third') asRopedText
]

{ #category : #'examples - embedded' }
AlbEmbeddedEditorExamples >> textWithEmbeddedEditor [
	<script: 'self new textWithEmbeddedEditor'>
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
				self makeFixedMeasurement: anEditorElement editor.
				anEditorElement ]).

	^ aText
]
