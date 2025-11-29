Class {
	#name : #AlbEditorShortcutExamples,
	#superclass : #Object,
	#category : #'Album-Examples-Shortcuts'
}

{ #category : #accessing }
AlbEditorShortcutExamples >> deleteOneLetterAfterCursorWithSelection [
	<gtExample>
	| anEditorElement anEditor |
	
	anEditorElement := AlbTextEditorOperatorTest new test_editorOnMultilineText.
	anEditor := anEditorElement editor.
	
	anEditor selecter
		from: 3 to: 7;
		select.
	anEditor navigator
		moveTo: 3;
		apply.
		
	self assert: anEditor selection equals: (BlCompositeSelection new select: 3 to: 7).
	self assert: anEditor cursors equals: (AlbTextEditorCursor atAll: { 3 }).
	
	AlbEditorShortcut deleteOneLetterAfterCursor
		performOnEditor: anEditor element: anEditorElement dueTo: nil.
	
	self assert: (anEditor text from: 3 to: 4) asString equals: 'sr'.
	self assert: anEditor selection equals: (BlCompositeSelection new).
	self assert: anEditor cursors equals: (AlbTextEditorCursor atAll: { 3 }).
	
	^ anEditorElement
]

{ #category : #accessing }
AlbEditorShortcutExamples >> deleteOneLetterAfterCursorWithSelectionBeforeCursor [
	<gtExample>
	| anEditorElement anEditor |
	
	anEditorElement := AlbTextEditorOperatorTest new test_editorOnMultilineText.
	anEditor := anEditorElement editor.
	
	anEditor selecter
		from: 3 to: 7;
		select.
		
	self assert: anEditor selection equals: (BlCompositeSelection new select: 3 to: 7).
	self assert: anEditor cursors equals: (AlbTextEditorCursor atAll: { 7 }).
	
	AlbEditorShortcut deleteOneLetterAfterCursor
		performOnEditor: anEditor element: anEditorElement dueTo: nil.
	
	self assert: (anEditor text from: 3 to: 4) asString equals: 'sr'.
	self assert: anEditor selection equals: (BlCompositeSelection new).
	self assert: anEditor cursors equals: (AlbTextEditorCursor atAll: { 3 }).
	
	^ anEditorElement
]

{ #category : #accessing }
AlbEditorShortcutExamples >> deleteOneLetterBeforeCursorWithSelection [
	<gtExample>
	| anEditorElement anEditor |
	
	anEditorElement := AlbTextEditorOperatorTest new test_editorOnMultilineText.
	anEditor := anEditorElement editor.
	
	anEditor selecter
		from: 3 to: 7;
		select.
		
	self assert: anEditor selection equals: (BlCompositeSelection new select: 3 to: 7).
	self assert: anEditor cursors equals: (AlbTextEditorCursor atAll: { 7 }).
	
	AlbEditorShortcut deleteOneLetterBeforeCursor
		performOnEditor: anEditor element: anEditorElement dueTo: nil.
	
	self assert: (anEditor text from: 3 to: 4) asString equals: 'sr'.
	self assert: anEditor selection equals: (BlCompositeSelection new).
	self assert: anEditor cursors equals: (AlbTextEditorCursor atAll: { 3 }).
	
	^ anEditorElement
]

{ #category : #accessing }
AlbEditorShortcutExamples >> deleteOneLetterBeforeCursorWithSelectionAfterCursor [
	<gtExample>
	| anEditorElement anEditor |
	
	anEditorElement := AlbTextEditorOperatorTest new test_editorOnMultilineText.
	anEditor := anEditorElement editor.
	
	anEditor selecter
		from: 3 to: 7;
		select.
	anEditor navigator
		moveTo: 3;
		apply.
		
	self assert: anEditor selection equals: (BlCompositeSelection new select: 3 to: 7).
	self assert: anEditor cursors equals: (AlbTextEditorCursor atAll: { 3 }).
	
	AlbEditorShortcut deleteOneLetterBeforeCursor
		performOnEditor: anEditor element: anEditorElement dueTo: nil.
	
	self assert: (anEditor text from: 3 to: 4) asString equals: 'sr'.
	self assert: anEditor selection equals: (BlCompositeSelection new).
	self assert: anEditor cursors equals: (AlbTextEditorCursor atAll: { 3 }).
	
	^ anEditorElement
]

{ #category : #accessing }
AlbEditorShortcutExamples >> testDeleteOneLetterAfterCursorWithSelection [
	<demo>
	<sampleInstance>
	
	| anEditorElement anEditor |
	
	anEditorElement := AlbTextEditorOperatorTest new test_editorOnMultilineText.
	anEditor := anEditorElement editor.
	
	anEditor selecter
		from: 3 to: 7;
		select.
	anEditor navigator
		moveTo: 3;
		apply.
		
	self assert: anEditor selection equals: (BlCompositeSelection new select: 3 to: 7).
	self assert: anEditor cursors equals: (AlbTextEditorCursor atAll: { 3 }).
	
	AlbEditorShortcut testDeleteOneLetterAfterCursor
		performOnEditor: anEditor element: anEditorElement dueTo: nil.
	
	self assert: (anEditor text from: 3 to: 4) asString equals: 'sr'.
	self assert: anEditor selection equals: (BlCompositeSelection new).
	self assert: anEditor cursors equals: (AlbTextEditorCursor atAll: { 3 }).
	
	^ anEditorElement
]
