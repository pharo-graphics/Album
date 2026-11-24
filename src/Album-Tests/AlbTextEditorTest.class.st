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

{ #category : #'tests - cursor attributes' }
AlbTextEditorTest >> addCursorAttributeLoggingIn: aCollection to: aText [
	"Add to the 13 to 23 part of aText a cursor attribute that logs in aCollection when the cursor enters and leaves it"

	(aText from: 13 to: 23)
		onCursorEnter: [ :anEditor :anEvent :aFrom :aTo | aCollection add: #enter -> (aFrom to: aTo) ]
		leave: [ :anEditor :anEvent :aFrom :aTo | aCollection add: #leave -> (aFrom to: aTo) ]
]

{ #category : #'tests - cursor attributes' }
AlbTextEditorTest >> editorTextWithCursorAttributeLoggingIn: aCollection [
	"Give the editor a text with a cursor attribute logging in aCollection, and forget the initial leave sent when the text is set"

	textEditor text: (self textWithCursorAttributeLoggingIn: aCollection).
	aCollection removeAll
]

{ #category : #initialization }
AlbTextEditorTest >> setUp [

	textEditor := AlbTextEditor new
]

{ #category : #'tests - cursor attributes' }
AlbTextEditorTest >> testCursorAttributeAddedToEditorTextFiresEnterAction [

	| log |
	log := OrderedCollection new.
	textEditor text: 'Hello World- click here' asRopedText.
	self addCursorAttributeLoggingIn: log to: textEditor text.
	textEditor moveCursorTo: 15.
	self assert: log asArray equals: { (#enter -> (13 to: 23)) }
]

{ #category : #'tests - cursor attributes' }
AlbTextEditorTest >> testCursorAttributeDoesNotFireWhenCursorStaysOutside [

	| log |
	log := OrderedCollection new.
	self editorTextWithCursorAttributeLoggingIn: log.
	textEditor moveCursorTo: 2.
	textEditor moveCursorTo: 5.
	self assert: log isEmpty
]

{ #category : #'tests - cursor attributes' }
AlbTextEditorTest >> testCursorAttributeFiresEnterActionOnceWhileCursorStaysInside [

	| log |
	log := OrderedCollection new.
	self editorTextWithCursorAttributeLoggingIn: log.
	textEditor moveCursorTo: 15.
	textEditor moveCursorTo: 18.
	self assert: log asArray equals: { (#enter -> (13 to: 23)) }
]

{ #category : #'tests - cursor attributes' }
AlbTextEditorTest >> testCursorAttributeInInitialTextFiresEnterAction [

	| log |
	log := OrderedCollection new.
	self editorTextWithCursorAttributeLoggingIn: log.
	textEditor moveCursorTo: 15.
	self assert: log asArray equals: { (#enter -> (13 to: 23)) }
]

{ #category : #'tests - cursor attributes' }
AlbTextEditorTest >> testCursorAttributeInInitialTextFiresLeaveAction [

	| log |
	log := OrderedCollection new.
	self editorTextWithCursorAttributeLoggingIn: log.
	textEditor moveCursorTo: 15.
	textEditor moveCursorTo: 2.
	self assert: log asArray equals: {
			(#enter -> (13 to: 23)).
			(#leave -> (13 to: 23)) }
]

{ #category : #'tests - cursor attributes' }
AlbTextEditorTest >> testSettingTextFiresLeaveActionOfCursorAttribute [

	| log |
	log := OrderedCollection new.
	textEditor text: (self textWithCursorAttributeLoggingIn: log).
	self assert: log asArray equals: { (#leave -> (13 to: 23)) }
]

{ #category : #'tests - cursor attributes' }
AlbTextEditorTest >> testTextWithoutCursorAttributeHasNoEventHandlerAttribute [

	textEditor text: (self textWithCursorAttributeLoggingIn: OrderedCollection new).
	textEditor text: 'Hello' asRopedText.
	self deny: textEditor hasEventHandlerAttribute
]

{ #category : #tests }
AlbTextEditorTest >> test_emptyEditor [

	self assert: textEditor text asString equals: ''.
	self
		assert: textEditor segmentCollector computedSegmentsCount
		equals: 1.
	self
		assert: textEditor segmentCollector segments first textInterval
		equals: (0 to: 0)
]

{ #category : #tests }
AlbTextEditorTest >> test_insertString1 [

	textEditor insertString: 'Z' at: textEditor text size.
	textEditor insertString: 'A' at: 0.
	self assert: textEditor text asString equals: 'AZ'.
	self should: [ textEditor insertString: 'A' at: -1 ] raise: Error.
	self should: [ textEditor insertString: 'A' at: 3 ] raise: Error
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
	self
		assert: textEditor segmentCollector computedSegmentsCount
		equals: 1.
	self
		assert: textEditor segmentCollector segments first textInterval
		equals: (0 to: 1)
]

{ #category : #tests }
AlbTextEditorTest >> test_textFromString [
	"the editor text can be initialized from a string"

	textEditor text: 'a string' asRopedText.
	self assert: textEditor text asString equals: 'a string'.
	"#textSnapshot return a copy of the editor text (to be used in application thread - non-UI process)"
	self assert: textEditor textSnapshot asString equals: 'a string'
]

{ #category : #tests }
AlbTextEditorTest >> test_textFromStringWithNonPrintableCharacter [
	"non printable character test"
	self should: [textEditor checkAndSetText: Character backspace asString] raise: Error.
]

{ #category : #'tests - cursor attributes' }
AlbTextEditorTest >> textWithCursorAttributeLoggingIn: aCollection [
	"Return the text 'Hello World- click here' whose 'click here' part (13 to 23) logs in aCollection when the cursor enters and leaves it"

	| text |
	text := 'Hello World- click here' asRopedText.
	self addCursorAttributeLoggingIn: aCollection to: text.
	^ text
]
