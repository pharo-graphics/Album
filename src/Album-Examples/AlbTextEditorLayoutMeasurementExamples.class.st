Class {
	#name : #AlbTextEditorLayoutMeasurementExamples,
	#superclass : #Object,
	#traits : 'TAlbTextEditorFixedMeasurerExamples',
	#classTraits : 'TAlbTextEditorFixedMeasurerExamples classTrait',
	#category : #'Album-Examples-Editor'
}

{ #category : #'instance creation' }
AlbTextEditorLayoutMeasurementExamples >> editorFor: aText [
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

{ #category : #'examples - measurement' }
AlbTextEditorLayoutMeasurementExamples >> fit_content_Hello [
	<gtExample>
	<noTest>
	| anEditorElement |

	anEditorElement := self editorFor: 'Hello'.

	self assert: anEditorElement width equals: (5 * self glyphWidth) + (self paragraphMargin width).
	self assert: anEditorElement height equals: self glyphHeight + (self wordPadding height) + (self lineSpacing * 0) + (self paragraphMargin height).

	^ anEditorElement
]

{ #category : #'examples - measurement' }
AlbTextEditorLayoutMeasurementExamples >> fit_content_Hello_World [
	<gtExample>
	<noTest>
	| anEditorElement |

	anEditorElement := self editorFor: 'Hello World'.

	self assert: anEditorElement width equals: (11 * self glyphWidth) + (self paragraphMargin width).
	self assert: anEditorElement height equals: self glyphHeight + (self wordPadding height) + (self lineSpacing * 0) + (self paragraphMargin height).

	^ anEditorElement
]
