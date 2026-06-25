Class {
	#name : #AlbTextEditorLayoutMeasurementExamples,
	#superclass : #Object,
	#traits : 'TAlbTextEditorFixedMeasurerExamples',
	#classTraits : 'TAlbTextEditorFixedMeasurerExamples classTrait',
	#category : #'Album-Examples-Editor'
}

{ #category : #'examples - measurement' }
AlbTextEditorLayoutMeasurementExamples >> fit_content_Hello [
	<gtExample>
	<noTest>
	| anEditorElement |

	anEditorElement := self newEditorElement: 'Hello'.

"	self assert: anEditorElement width equals: (5 * self glyphWidth) + (self paragraphMargin width).
	self assert: anEditorElement height equals: self glyphHeight + (self wordPadding height) + (self lineSpacing * 0) + (self paragraphMargin height).
"
	^ anEditorElement
]

{ #category : #'examples - measurement' }
AlbTextEditorLayoutMeasurementExamples >> fit_content_Hello_World [
	<gtExample>
	<noTest>
	| anEditorElement |

	anEditorElement := self newEditorElement: 'Hello World'.

	self assert: anEditorElement width equals: (11 * self glyphWidth) + (self paragraphMargin width).
	self assert: anEditorElement height equals: self glyphHeight + (self wordPadding height) + (self lineSpacing * 0) + (self paragraphMargin height).

	^ anEditorElement
]

{ #category : #'instance creation' }
AlbTextEditorLayoutMeasurementExamples >> newEditorElement: aText [

	| anEditor aRopedText |
	aRopedText :=
		aText asRopedText
			lineSpacing: self lineSpacing;
			paragraphMargin: self paragraphMargin;
			wordPadding: self wordPadding;
			yourself.

	anEditor := AlbEditorElement new.
	anEditor padding: BlInsets empty.
	anEditor fitContent.
	anEditor text: aRopedText.
	
	BlDevCrossover on: anEditor.
	
	anEditor  
		wordStencil: (AlbTextWordPieceStencil editable
			measurer: self fixedMeasurer).
	
	anEditor requestFocus.
	anEditor forceLayout.

	^ anEditor
]
