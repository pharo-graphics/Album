Class {
	#name : #AlbEditorShortcutExamples,
	#superclass : #BlExamplesTest,
	#category : #'Album-Examples-Shortcuts'
}

{ #category : #accessing }
AlbEditorShortcutExamples >> deleteOneLetterAfterCursorWithSelection [
	<sampleInstance>

	| anEditorElement anEditor |
	
	anEditorElement := AlbTextEditorOperatorTest new newEditorElementWithMultilineText.
	anEditor := anEditorElement editor.
	
	anEditor selecter
		from: 3 to: 7;
		select.
	anEditor navigator
		moveTo: 3;
		apply.
		
	self assert: anEditor selection equals: (BlCompositeSelection new select: 3 to: 7).
	self assert: anEditor cursor position equals: 3.
	
	AlbEditorDeleteOneLetterAfterCursorShortcut new
		performOnEditor: anEditor element: anEditorElement dueTo: nil.
	
	self assert: (anEditor text from: 3 to: 4) asString equals: 'sr'.
	self assert: anEditor selection equals: (BlCompositeSelection new).
	self assert: anEditor cursor position equals: 3.
	
	^ anEditorElement
]

{ #category : #accessing }
AlbEditorShortcutExamples >> deleteOneLetterAfterCursorWithSelectionBeforeCursor [
	<sampleInstance>

	| anEditorElement anEditor |
	
	anEditorElement := AlbTextEditorOperatorTest new newEditorElementWithMultilineText.
	anEditor := anEditorElement editor.
	
	anEditor selecter
		from: 3 to: 7;
		select.
		
	self assert: anEditor selection equals: (BlCompositeSelection new select: 3 to: 7).
	self assert: anEditor cursor position equals: 7.
	
	AlbEditorDeleteOneLetterAfterCursorShortcut new
		performOnEditor: anEditor element: anEditorElement dueTo: nil.
	
	self assert: (anEditor text from: 3 to: 4) asString equals: 'sr'.
	self assert: anEditor selection equals: (BlCompositeSelection new).
	self assert: anEditor cursor position equals: 3.
	
	^ anEditorElement
]

{ #category : #accessing }
AlbEditorShortcutExamples >> deleteOneLetterBeforeCursorWithSelection [
	<sampleInstance>

	| anEditorElement anEditor |
	
	anEditorElement := AlbTextEditorOperatorTest new newEditorElementWithMultilineText.
	anEditor := anEditorElement editor.
	
	anEditor selecter
		from: 3 to: 7;
		select.
		
	self assert: anEditor selection equals: (BlCompositeSelection new select: 3 to: 7).
	self assert: anEditor cursor position equals: 7.
	
	AlbEditorDeleteOneLetterBeforeCursorShortcut new
		performOnEditor: anEditor element: anEditorElement dueTo: nil.
	
	self assert: (anEditor text from: 3 to: 4) asString equals: 'sr'.
	self assert: anEditor selection equals: (BlCompositeSelection new).
	self assert: anEditor cursor position equals: 3.
	
	^ anEditorElement
]

{ #category : #accessing }
AlbEditorShortcutExamples >> deleteOneLetterBeforeCursorWithSelectionAfterCursor [
	<sampleInstance>

	| anEditorElement anEditor |
	
	anEditorElement := AlbTextEditorOperatorTest new newEditorElementWithMultilineText.
	anEditor := anEditorElement editor.
	
	anEditor selecter
		from: 3 to: 7;
		select.
	anEditor navigator
		moveTo: 3;
		apply.
		
	self assert: anEditor selection equals: (BlCompositeSelection new select: 3 to: 7).
	self assert: anEditor cursor position equals: 3.
	
	AlbEditorDeleteOneLetterBeforeCursorShortcut new
		performOnEditor: anEditor element: anEditorElement dueTo: nil.
	
	self assert: (anEditor text from: 3 to: 4) asString equals: 'sr'.
	self assert: anEditor selection equals: (BlCompositeSelection new).
	self assert: anEditor cursor position equals: 3.
	
	^ anEditorElement
]
