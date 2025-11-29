Class {
	#name : #AlbTextEditorParagraphAttributesExamples,
	#superclass : #TestCase,
	#category : #'Album-Examples-Editor'
}

{ #category : #'instance creation' }
AlbTextEditorParagraphAttributesExamples >> editorElement [

	| textEditor editorElement |
	textEditor := AlbTextEditor new.
	editorElement := AlbEditorElement new.
	editorElement editor: textEditor.
	editorElement constraintsDo: [ :c |
		c horizontal fitContent.
		c vertical fitContent ].

	^ editorElement
]

{ #category : #examples }
AlbTextEditorParagraphAttributesExamples >> testHelloEditor [

	| anEditorElement |
	self skip.
	"editor: does not exist so skip it for now.
	"
	anEditorElement := self editorElement.
	anEditorElement editor text: self testHelloText.
	
	anEditorElement forceLayout.

	self 
		assert: anEditorElement editor segmentCollector segments size 
		equals: 1.
	self
		assert: anEditorElement editor segmentCollector segments first lineSpacing
		equals: 20.
	self
		assert: anEditorElement editor segmentCollector segments first wordPadding
		equals: (BlInsets top: 10 bottom: 10).
	self
		assert: anEditorElement editor segmentCollector segments first paragraphMargin
		equals: (BlInsets top: 15 left: 20 bottom: 15 right: 20).

	^ anEditorElement
]

{ #category : #examples }
AlbTextEditorParagraphAttributesExamples >> testHelloText [

	| aText |

	aText := 'Hello' asRopedText
		fontSize: 20;
		lineSpacing: 20;
		wordPadding: (BlInsets top: 10 bottom: 10);
		paragraphMargin: (BlInsets top: 15 left: 20 bottom: 15 right: 20).

	self
		assert: aText iterator attributes
		equals: {
			BlFontSizeAttribute size: 20.
			AlbTextParagraphLineSpacingAttribute lineSpacing: 20.
			AlbTextParagraphWordPaddingAttribute wordPadding: (BlInsets top: 10 bottom: 10).
			AlbTextParagraphMarginAttribute paragraphMargin: (BlInsets top: 15 left: 20 bottom: 15 right: 20)
		}.

	^ aText
]
