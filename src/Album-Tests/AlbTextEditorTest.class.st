"
An AlbTextEditorTest is a test class for testing the behavior of AlbTextEditor
"
Class {
	#name : #AlbTextEditorTest,
	#superclass : #TestCase,
	#instVars : [
		'textEditor'
	],
	#category : #'Album-Tests-TextEditor'
}

{ #category : #initialization }
AlbTextEditorTest >> setUp [
	textEditor := AlbTextEditor new.
]

{ #category : #tests }
AlbTextEditorTest >> test_emptyEditor [
	self assert: textEditor segmentBuilder class equals: textEditor defaultSegmentBuilder class.
	self assert: textEditor text asString equals: ''.
	self assert: textEditor segmentCollector computedSegmentsCount equals: 1.
	self assert: textEditor segmentCollector segments first textInterval equals: (0 to: 0).
]

{ #category : #tests }
AlbTextEditorTest >> test_insertString1 [

	textEditor insertString: 'Z' at: textEditor text size.
	textEditor insertString: 'A' at: 0.
	self assert: textEditor text asString equals: 'AZ'.
	self should: [textEditor insertString: 'A' at: -1] raise: Error.
	self should: [textEditor insertString: 'A' at: 3] raise: Error.


]

{ #category : #tests }
AlbTextEditorTest >> test_insertString2 [

	self should: [textEditor insertString: Character backspace asString at: 0] raise: Error.


]

{ #category : #tests }
AlbTextEditorTest >> test_insertString3 [

	self
		should: [ 
			textEditor inserter
				string: Character backspace asString;
				insert ]
		raise: Error
]

{ #category : #tests }
AlbTextEditorTest >> test_oneCharacter [
	textEditor text: 'A' asRopedText.
	self assert: textEditor text asString equals: 'A'.
	self assert: textEditor segmentCollector computedSegmentsCount equals: 1.
	self assert: textEditor segmentCollector segments first textInterval equals: (0 to: 1).
]

{ #category : #tests }
AlbTextEditorTest >> test_textFromString [

	"the editor text can be initialized from a string"

	textEditor text: 'a string'.
	self assert: textEditor text asString equals: 'a string'.
	"#textSnapshot return a copy of the editor text (to be used in application thread - non-UI process)"
	self assert: textEditor textSnapshot asString equals: 'a string'
]

{ #category : #tests }
AlbTextEditorTest >> test_textFromStringWithNonPrintableCharacter [
	"non printable character test"
	self should: [textEditor text: Character backspace asString] raise: Error.

]
