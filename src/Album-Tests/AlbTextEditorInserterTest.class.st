Class {
	#name : #AlbTextEditorInserterTest,
	#superclass : #AlbTextEditorOperatorTest,
	#category : #'Album-Tests-Operators'
}

{ #category : #insertion }
AlbTextEditorInserterTest >> test_big_text_insert_cr_twice_at_0 [
	
	| anEditor bigText size |
	size := 10000000.
	bigText := (String loremIpsum: size) asRopedText.
	anEditor := AlbEditorElement new.
	anEditor text: bigText.
	space deferAndSettle: [
		space root addChild: anEditor.
		anEditor requestFocus ].

	space deferAndSettle: [
		anEditor inserter
			at: 0;
			string: String cr;
			insert ].

	self assert: anEditor text size equals: size + 1.

	space deferAndSettle: [
		anEditor inserter
			at: 0;
			string: String cr;
			insert ].

	self assert: anEditor text size equals: size + 2
]

{ #category : #insertion }
AlbTextEditorInserterTest >> test_filter_insert_Hello123Symbols_onlyAlphaNumeric [
	
	| anEditor anEditorElement |
	
	anEditorElement := self newEditorElementWithMultilineText.
	anEditor := anEditorElement editor.	
	space deferAndSettle: [
		anEditor moveCursorTo: 0.
		anEditor inserter
			at: 0;
			string: 'Hello123$#^)';
			onlyAlphaNumeric;
			insert ].

	self assert: anEditor text asString equals: ('Hello123', self multilineText asString).
	self assert: anEditor cursor position equals: 8.
	self assert: anEditor selection isEmpty
]

{ #category : #insertion }
AlbTextEditorInserterTest >> test_filter_insert_Hello123_onlyDigits [
	
	| anEditor anEditorElement |
	
	anEditorElement := self newEditorElementWithMultilineText.
	anEditor := anEditorElement editor.	
	space deferAndSettle: [
		anEditor moveCursorTo: 0.
		anEditor inserter
			at: 0;
			string: 'Hello123';
			onlyDigits;
			insert ].

	self assert: anEditor text asString equals: ('123', self multilineText asString).
	self assert: anEditor cursor position equals: 3.
	self assert: anEditor selection isEmpty
]

{ #category : #insertion }
AlbTextEditorInserterTest >> test_filter_insert_Hello123_onlyLetters [
	
	| anEditor anEditorElement |
	
	anEditorElement := self newEditorElementWithMultilineText.
	anEditor := anEditorElement editor.	
	space deferAndSettle: [
		anEditor moveCursorTo: 0.
		anEditor inserter
			at: 0;
			string: 'Hello123';
			onlyLetters;
			insert ].

	self assert: anEditor text asString equals: ('Hello', self multilineText asString).
	self assert: anEditor cursor position equals: 5.
	self assert: anEditor selection isEmpty
]

{ #category : #insertion }
AlbTextEditorInserterTest >> test_insert_Hello_atCursorAt_0_and_1_selection_no [
	
	| anEditor anEditorElement |
	"Album is mono cursor, only last moveTo is actually done"
	anEditorElement := self newEditorElementWithMultilineText.
	anEditor := anEditorElement editor.
	space deferAndSettle: [
		anEditor navigator
			moveTo: 0;
			moveTo: 1;
			apply.
		anEditor inserter
			atCursor;
			string: 'Hello';
			insert ].

	self assert: anEditor text asString equals: ('AHello', (self multilineText from: 2 to: self multilineText size) asString).
	self assert: anEditor cursor position equals: 6.
	self assert: anEditor selection isEmpty.
]

{ #category : #insertion }
AlbTextEditorInserterTest >> test_insert_Hello_at_0_cursorAt_0_selection_0_to_0 [
	
	| anEditor anEditorElement |
	
	anEditorElement := self newEditorElementWithMultilineText.
	anEditor := anEditorElement editor.
	space deferAndSettle: [
		anEditor moveCursorTo: 0.
		anEditor select: 0 to: 0.
		anEditor inserter
			at: 0;
			string: 'Hello';
			insert ].

	self assert: anEditor text asString equals: ('Hello', self multilineText asString).
	self assert: anEditor cursor position equals: 5.
	self assert: anEditor selection isEmpty
]

{ #category : #insertion }
AlbTextEditorInserterTest >> test_insert_Hello_at_0_cursorAt_0_selection_0_to_1 [
	
	| anEditor anEditorElement |
	
	anEditorElement := self newEditorElementWithMultilineText.
	anEditor := anEditorElement editor.
	space deferAndSettle: [
		anEditor moveCursorTo: 0.
		anEditor select: 0 to: 1.
		anEditor inserter
			at: 0;
			string: 'Hello';
			insert ].

	self assert: anEditor text asString equals: ('Hello', (self multilineText from: 2 to: self multilineText size) asString).
	self assert: anEditor cursor position equals: 5.
	self assert: anEditor selection isEmpty
]

{ #category : #insertion }
AlbTextEditorInserterTest >> test_insert_Hello_at_0_cursorAt_10_selection_0_to_1_and_8_to_14 [
	
	| anEditor anEditorElement |
	
	anEditorElement := self newEditorElementWithMultilineText.
	anEditor := anEditorElement editor.
	space deferAndSettle: [
		anEditor moveCursorTo: 10.
		anEditor select: 0 to: 1. "A"
		anEditor select: 8 to: 14. " river"
		anEditor inserter
			at: 0;
			string: 'Hello';
			insert ].

	self assert: anEditor text asString equals: ('Hello', (self multilineText from: 2 to: 7) asString, (self multilineText from: 14 to: self multilineText size) asString).
	self assert: anEditor cursor position equals: 12.
	self assert: anEditor selection isEmpty
]

{ #category : #insertion }
AlbTextEditorInserterTest >> test_insert_Hello_at_0_cursorAt_10_selection_0_to_1_and_8_to_14_no_delete [
	
	| anEditor anEditorElement |
	
	anEditorElement := self newEditorElementWithMultilineText.
	anEditor := anEditorElement editor.
	space deferAndSettle: [
		anEditor moveCursorTo: 10.
		anEditor select: 0 to: 1. "A"
		anEditor select: 8 to: 14. " river"
		anEditor inserter
			at: 0;
			string: 'Hello';
			withoutSelectionDelete;
			insert ].

	self assert: anEditor text asString equals: ('Hello', self multilineText asString).
	self assert: anEditor cursor position equals: 15.
	self assert: anEditor selection allSelections equals: {
		BlSelection from: 5 to: 6.
		BlSelection from: 13 to: 19.
	}
]

{ #category : #insertion }
AlbTextEditorInserterTest >> test_insert_Hello_at_0_cursorAt_10_selection_0_to_1_and_8_to_14_no_delete_no_selection [
	
	| anEditor anEditorElement |
	
	anEditorElement := self newEditorElementWithMultilineText.
	anEditor := anEditorElement editor.
	space deferAndSettle: [
		anEditor moveCursorTo: 10.
		anEditor select: 0 to: 1. "A"
		anEditor select: 8 to: 14. " river"
		anEditor inserter
			at: 0;
			string: 'Hello';
			withoutSelectionDelete;
			withoutSelectionUpdate;
			insert ].

	self assert: anEditor text asString equals: ('Hello', self multilineText asString).
	self assert: anEditor cursor position equals: 15.
	self assert: anEditor selection allSelections equals: {
		BlSelection from: 0 to: 1.
		BlSelection from: 8 to: 14.
	}
]

{ #category : #insertion }
AlbTextEditorInserterTest >> test_insert_Hello_at_0_cursorAt_10_selection_0_to_1_and_8_to_14_no_delete_no_selection_no_cursor [
	
	| anEditor anEditorElement |
	
	anEditorElement := self newEditorElementWithMultilineText.
	anEditor := anEditorElement editor.
	space deferAndSettle: [
		anEditor moveCursorTo: 10.
		anEditor select: 0 to: 1. "A"
		anEditor select: 8 to: 14. " river"
		anEditor inserter
			at: 0;
			string: 'Hello';
			withoutSelectionDelete;
			withoutSelectionUpdate;
			withoutCursorUpdate;
			insert ].

	self assert: anEditor text asString equals: ('Hello', self multilineText asString).
	self assert: anEditor cursor position equals: 10.
	self assert: anEditor selection allSelections equals: {
		BlSelection from: 0 to: 1.
		BlSelection from: 8 to: 14.
	}
]

{ #category : #insertion }
AlbTextEditorInserterTest >> test_insert_Hello_at_0_cursorAt_5_selection_0_to_0 [
	
	| anEditor anEditorElement |
	
	anEditorElement := self newEditorElementWithMultilineText.
	anEditor := anEditorElement editor.
	space deferAndSettle: [
		anEditor moveCursorTo: 5.
		anEditor select: 0 to: 0.
		anEditor inserter
			at: 0;
			string: 'Hello';
			insert ].

	self assert: anEditor text asString equals: ('Hello', self multilineText asString).
	self assert: anEditor cursor position equals: 10.
	self assert: anEditor selection isEmpty
]

{ #category : #insertion }
AlbTextEditorInserterTest >> test_insert_Hello_at_1_cursorAt_0_selection_0_to_0 [
	
	| anEditor anEditorElement |
	
	anEditorElement := self newEditorElementWithMultilineText.
	anEditor := anEditorElement editor.
	space deferAndSettle: [
		anEditor moveCursorTo: 0.
		anEditor select: 0 to: 0.
		anEditor inserter
			at: 1;
			string: 'Hello';
			insert ].

	self assert: anEditor text asString equals: (self multilineText first asString, 'Hello', ((self multilineText from: 2 to: self multilineText size) asString)).
	self assert: anEditor cursor position equals: 0.
	self assert: anEditor selection isEmpty
]

{ #category : #insertion }
AlbTextEditorInserterTest >> test_insert_Hello_at_1_cursorAt_1_selection_0_to_0 [
	
	| anEditor anEditorElement |
	
	anEditorElement := self newEditorElementWithMultilineText.
	anEditor := anEditorElement editor.
	space deferAndSettle: [
		anEditor moveCursorTo: 1.
		anEditor select: 0 to: 0.
		anEditor inserter
			at: 1;
			string: 'Hello';
			insert ].

	self assert: anEditor text asString equals: (self multilineText first asString, 'Hello', ((self multilineText from: 2 to: self multilineText size) asString)).
	self assert: anEditor cursor position equals: 6.
	self assert: anEditor selection isEmpty
]

{ #category : #indentation }
AlbTextEditorInserterTest >> test_insert_indentation [
	
	| anEditor |

	anEditor := self newEditorElement: 'AAAAA', String cr, 'BBBBB', String cr, 'CCCCC'.
	space deferAndSettle: [
		anEditor selecter
			from: 0 to: 11;
			select.
		anEditor inserter
			indentation;
			beforeSelectedLines;
			withoutSelectionDelete;
			insert ].

	self assert: anEditor text asString equals: ('	AAAAA', String cr, '	BBBBB', String cr, 'CCCCC').
	self assert: anEditor selection allSelections equals: {
		BlSelection from: 1 to: 13.
	}.
]

{ #category : #indentation }
AlbTextEditorInserterTest >> test_insert_indentation2 [
	
	| anEditor |

	anEditor := self newEditorElement: 'AAAAA', String cr, 'BBBBB', String cr, 'CCCCC'.
	space deferAndSettle: [
		anEditor selecter
			from: 3 to: 13;
			select ].

	self assert: anEditor selectedText asString equals: 'AA', String cr, 'BBBBB', String cr, 'C'.
	self assert: anEditor selection allSelections equals: { BlSelection from: 3 to: 13 }.

	space deferAndSettle: [
		anEditor inserter
			indentation;
			beforeSelectedLines;
			withoutSelectionDelete;
			insert ].

	self assert: anEditor text asString equals: ('	AAAAA', String cr, '	BBBBB', String cr, '	CCCCC').
	self assert: anEditor selection allSelections equals: { BlSelection from: 4 to: 16 }.
]

{ #category : #indentation }
AlbTextEditorInserterTest >> test_insert_indentation_selection_0_to_1 [
	
	| anEditor anEditorElement |

	anEditorElement := self newEditorElementWithMultilineText.
	anEditor := anEditorElement editor.
	space deferAndSettle: [
		anEditor selecter
			from: 0 to: 1;
			select.
		anEditor inserter
			indentation;
			beforeSelectedLines;
			withoutSelectionDelete;
			insert ].

	self assert: anEditor text asString equals: (String tab, self multilineText asString).
	self assert: anEditor selection allSelections equals: {
		BlSelection from: 1 to: 2.
	}.
]

{ #category : #indentation }
AlbTextEditorInserterTest >> test_insert_indentation_selection_1_to_2 [
	
	| anEditor anEditorElement |

	anEditorElement := self newEditorElementWithMultilineText.
	anEditor := anEditorElement editor.
	space deferAndSettle: [
		anEditor selecter
			from: 1 to: 2;
			select.
		anEditor inserter
			indentation;
			beforeSelectedLines;
			withoutSelectionDelete;
			insert ].

	self assert: anEditor text asString equals: (String tab, self multilineText asString).
	self assert: anEditor selection allSelections equals: {
		BlSelection from: 2 to: 3.
	}.
]

{ #category : #insertion }
AlbTextEditorInserterTest >> test_insert_openParentheses_at_cursor_0_and_1_and_3_selection_0_to_0 [
	
	| anEditor anEditorElement |
	
	anEditorElement := self newEditorElementWithMultilineText.
	anEditor := anEditorElement editor.
	space deferAndSettle: [
		anEditor moveCursorTo: 0.
		anEditor select: 0 to: 0.
		anEditor navigator
			moveTo: 1;
			moveTo: 3;
			apply.
		anEditor inserter
			atCursor;
			string: '(';
			surroundings: (AlbTextEditorSurroundMap newFromArray: { '('. ')'. nil });
			insert ].

	self assert: anEditor text asString equals: ((self multilineText from: 1 to: 3) asString, '()', (self multilineText from: 4 to: self multilineText size) asString).
	self assert: anEditor cursor position equals: 4.
	self assert: anEditor selection isEmpty
]

{ #category : #insertion }
AlbTextEditorInserterTest >> test_insert_openParentheses_at_cursor_0_and_1_selection_0_to_0 [
	
	| anEditor anEditorElement |
	
	anEditorElement := self newEditorElementWithMultilineText.
	anEditor := anEditorElement editor.
	space deferAndSettle: [
		anEditor moveCursorTo: 0.
		anEditor select: 0 to: 0.
		anEditor navigator
			moveTo: 1;
			apply.
		anEditor inserter
			atCursor;
			string: '(';
			surroundings: (AlbTextEditorSurroundMap newFromArray: { '('. ')'. nil });
			insert ].

	self assert: anEditor text asString equals: (self multilineText from: 1 to: 1) asString, '()', (self multilineText from: 2 to: self multilineText size) asString.
	self assert: anEditor cursor position equals: 2.
	self assert: anEditor selection isEmpty
]

{ #category : #insertion }
AlbTextEditorInserterTest >> test_insert_openParentheses_at_cursor_0_and_3_selection_0_to_1_withoutSelectionDelete [
	
	| anEditor anEditorElement |
	
	anEditorElement := self newEditorElementWithMultilineText.
	anEditor := anEditorElement editor.
	space deferAndSettle: [
		anEditor moveCursorTo: 0.
		anEditor select: 0 to: 1.
		anEditor inserter
			atCursor;
			string: '(';
			surroundings: (AlbTextEditorSurroundMap newFromArray: { '('. ')'. nil });
			withoutSelectionDelete;
			insert ].

	self assert: anEditor text asString equals: (('(', (self multilineText from: 1 to: 1) asString),')', (self multilineText from: 2 to: self multilineText size) asString).
	self assert: anEditor cursor position equals: 1.

	self assert: anEditor selection allSelections equals: {
		BlSelection from: 1 to: 2.
	}
]

{ #category : #insertion }
AlbTextEditorInserterTest >> test_insert_openParentheses_at_cursor_0_selection_0_to_0 [
	
	| anEditor anEditorElement |
	
	anEditorElement := self newEditorElementWithMultilineText.
	anEditor := anEditorElement editor.
	space deferAndSettle: [
		anEditor moveCursorTo: 0.
		anEditor select: 0 to: 0.
		anEditor inserter
			atCursor;
			string: '(';
			surroundings: (AlbTextEditorSurroundMap newFromArray: { '('. ')'. nil });
			insert ].

	self assert: anEditor text asString equals: ('()', self multilineText asString).
	self assert: anEditor cursor position equals: 1.
	self assert: anEditor selection isEmpty
]

{ #category : #insertion }
AlbTextEditorInserterTest >> test_insert_openParentheses_at_cursor_0_selection_0_to_1 [
	
	| anEditor anEditorElement |
	
	anEditorElement := self newEditorElementWithMultilineText.
	anEditor := anEditorElement editor.
	space deferAndSettle: [
		anEditor moveCursorTo: 0.
		anEditor select: 0 to: 1.
		anEditor inserter
			atCursor;
			string: '(';
			surroundings: (AlbTextEditorSurroundMap newFromArray: { '('. ')'. nil });
			insert ].

	self assert: anEditor text asString equals: ('()', (self multilineText from: 2 to: self multilineText size) asString).
	self assert: anEditor cursor position equals: 1.
	self assert: anEditor selection isEmpty
]

{ #category : #insertion }
AlbTextEditorInserterTest >> test_insert_openParentheses_at_cursor_0_selection_0_to_1_withoutSelectionDelete [
	
	| anEditor anEditorElement |
	
	anEditorElement := self newEditorElementWithMultilineText.
	anEditor := anEditorElement editor.
	space deferAndSettle: [
		anEditor moveCursorTo: 0.
		anEditor select: 0 to: 1.
		anEditor inserter
			atCursor;
			string: '(';
			surroundings: (AlbTextEditorSurroundMap newFromArray: { '('. ')'. nil });
			withoutSelectionDelete;
			insert ].

	self assert: anEditor text asString equals: ('(',self multilineText first asString,')', (self multilineText from: 2 to: self multilineText size) asString).
	self assert: anEditor cursor position equals: 1.

	self assert: anEditor selection allSelections equals: {
		BlSelection from: 1 to: 2.
	}
]

{ #category : #insertion }
AlbTextEditorInserterTest >> test_insert_openParentheses_at_cursor_0_selection_2_to_8_withoutSelectionDelete [
	
	| anEditor anEditorElement |
	
	anEditorElement := self newEditorElementWithMultilineText.
	anEditor := anEditorElement editor.
	space deferAndSettle: [
		anEditor moveCursorTo: 0.
		anEditor select: 2 to: 8.
		anEditor inserter
			atCursor;
			string: '(';
			surroundings: (AlbTextEditorSurroundMap newFromArray: { '(' . ')'. nil });
			withoutSelectionDelete;
			insert ].

	self assert: anEditor text asString equals: ('()', self multilineText asString).
	self assert: anEditor cursor position equals: 1.

	self assert: anEditor selection allSelections equals: {
		BlSelection from: 4 to: 10.
	}
]

{ #category : #insertion }
AlbTextEditorInserterTest >> test_insert_openParentheses_at_cursor_10_selection_2_to_8_withoutSelectionDelete [
	
	| anEditor anEditorElement |
	
	anEditorElement := self newEditorElementWithMultilineText.
	anEditor := anEditorElement editor.
	space deferAndSettle: [
		anEditor moveCursorTo: 10.
		anEditor select: 2 to: 8.
		anEditor inserter
			atCursor;
			string: '(';
			surroundings: (AlbTextEditorSurroundMap newFromArray: { '(' . ')'. nil });
			withoutSelectionDelete;
			insert ].

	self assert: anEditor text asString equals: (
		(self multilineText from: 1 to: 10) asString,
		'()',
		(self multilineText from: 11 to: self multilineText size) asString).
	self assert: anEditor cursor position equals: 11.

	self assert: anEditor selection allSelections equals: {
		BlSelection from: 2 to: 8.
	}
]

{ #category : #insertion }
AlbTextEditorInserterTest >> test_insert_openParentheses_at_cursor_1_selection_1_to_2_withOperatorAccountingSelection_withoutSelectionDelete [
	"I make sure that selected text gets surrounded if it is described in condition"
	
	| anEditor anEditorElement |

	anEditorElement := self newEditorElementWithMultilineText.
	anEditor := anEditorElement editor.
	space deferAndSettle: [
		anEditor moveCursorTo: 1.
		anEditor select: 1 to: 2.
		anEditor inserter
			atCursor;
			string: '(';
			surroundings: (AlbTextEditorSurroundMap newFromArray: {
				'('. ')'. [ :anOperator :anIndex |
					(anOperator hasSpaceAroundIndex: anIndex) or: [ anOperator selection contains: anIndex ] ] });
			withoutSelectionDelete;
			insert ].

	self assert: anEditor text asString equals:
		(self multilineText first asString, '(',self multilineText second asString,')', (self multilineText from: 3 to: self multilineText size) asString).
	self assert: anEditor cursor position equals: 2.

	self assert: anEditor selection allSelections equals: {
		BlSelection from: 2 to: 3.
	}
]

{ #category : #insertion }
AlbTextEditorInserterTest >> test_insert_openParentheses_at_cursor_1_selection_1_to_2_withOperatorNotAccountingSelection_withoutSelectionDelete [
	"I make sure that selected text is not surrounded if it is selected and when it is not described in operator"
	
	| anEditor anEditorElement |

	anEditorElement := self newEditorElementWithMultilineText.
	anEditor := anEditorElement editor.
	space deferAndSettle: [
		anEditor moveCursorTo: 1.
		anEditor select: 1 to: 2.
		anEditor inserter
			atCursor;
			string: '(';
			surroundings: (AlbTextEditorSurroundMap newFromArray: {
				'('. ')'. [ :anOperator :anIndex |
					(anOperator hasSpaceAroundIndex: anIndex) ] });
			withoutSelectionDelete;
			insert ].

	self assert: anEditor text asString equals:
		(self multilineText first asString, '(', (self multilineText from: 2 to: self multilineText size) asString).
	self assert: anEditor cursor position equals: 2.

	self assert: anEditor selection allSelections equals: {
		BlSelection from: 2 to: 3.
	}
]

{ #category : #insertion }
AlbTextEditorInserterTest >> test_insert_openParentheses_at_cursor_2_selection_2_to_8_withoutSelectionDelete [
	
	| anEditor anEditorElement |
	
	anEditorElement := self newEditorElementWithMultilineText.
	anEditor := anEditorElement editor.
	space deferAndSettle: [
		anEditor moveCursorTo: 2.
		anEditor select: 2 to: 8.
		anEditor inserter
			atCursor;
			string: '(';
			surroundings: (AlbTextEditorSurroundMap newFromArray: { '(' . ')'. nil });
			withoutSelectionDelete;
			insert ].

	self assert: anEditor text asString equals: (
		(self multilineText from: 1 to: 2) asString,
		'(', (self multilineText from: 3 to: 8) asString, ')',
		(self multilineText from: 9 to: self multilineText size) asString).
	self assert: anEditor cursor position equals: 3.

	self assert: anEditor selection allSelections equals: {
		BlSelection from: 3 to: 9.
	}
]

{ #category : #insertion }
AlbTextEditorInserterTest >> test_insert_openParentheses_at_cursor_8_selection_2_to_8_withoutSelectionDelete [
	
	| anEditor anEditorElement |
	
	anEditorElement := self newEditorElementWithMultilineText.
	anEditor := anEditorElement editor.
	space deferAndSettle: [
		anEditor moveCursorTo: 8.
		anEditor select: 2 to: 8.
		anEditor inserter
			atCursor;
			string: '(';
			surroundings: (AlbTextEditorSurroundMap newFromArray: { '('. ')'. nil });
			withoutSelectionDelete;
			insert ].

	self assert: anEditor text asString equals: (
		(self multilineText from: 1 to: 2) asString,
		'(', (self multilineText from: 3 to: 8) asString, ')',
		(self multilineText from: 9 to: self multilineText size) asString).
	self assert: anEditor cursor position equals: 9.

	self assert: anEditor selection allSelections equals: {
		BlSelection from: 3 to: 9.
	}
]

{ #category : #insertion }
AlbTextEditorInserterTest >> test_insert_open_close_parentheses_at_cursor_0_selection_0_to_0 [
	
	| anEditor anEditorElement |
	
	anEditorElement := self newEditorElementWithMultilineText.
	anEditor := anEditorElement editor.
	space deferAndSettle: [
		anEditor moveCursorTo: 0.
		anEditor select: 0 to: 0.
		anEditor inserter
			atCursor;
			string: '(';
			surroundings: (AlbTextEditorSurroundMap newFromArray: { '('. ')'. nil });
			insert.
		anEditor inserter
			atCursor;
			string: ')';
			surroundings: (AlbTextEditorSurroundMap newFromArray: { '('. ')'. nil });
			insert ].

	self assert: anEditor text asString equals: ('()', self multilineText asString).
	self assert: anEditor cursor position equals: 2.
	self assert: anEditor selection isEmpty
]

{ #category : #insertion }
AlbTextEditorInserterTest >> test_insert_open_close_parentheses_with_selection_and_undo [

	| editorElement editor |
	editorElement := self newEditorElement: '' asRopedText.
	editor := editorElement editor.

	space deferAndSettle: [
		editor inserter
			at: 0;
			string: 'abc';
			insert ].
	space deferAndSettle: [
		editor selecter all select.
		editor inserter
			atCursor;
			string: '(';
			withoutSelectionDelete;
			surroundings:
				(AlbTextEditorSurroundMap newFromArray: { '('. ')'. nil });
			insert ].

	self assert: editor text asString equals: '(abc)'.

	space deferAndSettle: [ editor undo ].

	self assert: editor text asString equals: 'abc'.
]
