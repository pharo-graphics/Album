"
I test multi-cursor editing in Album.

Editor states are written in a compact notation: the text with a | at every cursor position.
For example 'a|b|c' is the text abc with cursors at positions 1 and 2.
#editorFrom: builds an editor from such a spec (the first | is the primary cursor), #specOf: renders an editor back.
"
Class {
	#name : #AlbMultiCursorTest,
	#superclass : #BlSpaceTestCase,
	#category : #'Album-Tests-Operators'
}

{ #category : #helpers }
AlbMultiCursorTest >> backspaceOracle: aSpec [
	"The expected spec after deleting the character before every cursor: remove the character preceding each |, then merge cursors that meet"

	| result |
	result := OrderedCollection new.
	aSpec do: [ :each |
		each = $|
			ifTrue: [
				(result notEmpty and: [ result last ~= $| ]) ifTrue: [ result removeLast ].
				(result notEmpty and: [ result last = $| ]) ifFalse: [ result add: $| ] ]
			ifFalse: [ result add: each ] ].
	^ String withAll: result
]

{ #category : #helpers }
AlbMultiCursorTest >> cursorElementsIn: anEditorElement [

	| found |
	space settle.
	found := OrderedCollection new.
	anEditorElement allChildrenBreadthFirstDo: [ :each |
		(each isKindOf: AlbCursorElement) ifTrue: [ found add: each ] ].
	^ found
]

{ #category : #helpers }
AlbMultiCursorTest >> editorFrom: aSpec [
	"Return a text editor on the text of aSpec with a cursor at every | position. The first one is the primary cursor"

	| positions text editor navigator |
	positions := OrderedCollection new.
	text := String streamContents: [ :out |
		aSpec do: [ :each |
			each = $|
				ifTrue: [ positions add: out position ]
				ifFalse: [ out nextPut: each ] ] ].
	editor := AlbTextEditor new.
	editor text: text asRopedText.
	navigator := editor navigator.
	navigator moveTo: positions first.
	positions allButFirst do: [ :each | navigator addCursorAt: each ].
	navigator apply.
	^ editor
]

{ #category : #helpers }
AlbMultiCursorTest >> elementFrom: aSpec [
	"Return an editor element shown in the test space, for operations that need the rendered text"

	| anElement |
	anElement := AlbEditorElement new.
	anElement constraintsDo: [ :c |
		c horizontal exact: 400.
		c vertical exact: 300 ].
	anElement text: (self editorFrom: aSpec) text.
	space deferAndSettle: [ space root addChild: anElement ].
	space deferAndSettle: [ self setCursorsOf: anElement editor from: aSpec ].
	^ anElement
]

{ #category : #helpers }
AlbMultiCursorTest >> lines: aCollectionOfStrings [

	^ String cr join: aCollectionOfStrings
]

{ #category : #helpers }
AlbMultiCursorTest >> preservingClipboardDo: aBlock [
	"Evaluate aBlock and restore the system clipboard afterwards, so that tests do not overwrite it"

	| aSavedText |
	aSavedText := Clipboard clipboardText asString.
	aBlock ensure: [ Clipboard clipboardText: aSavedText ]
]

{ #category : #helpers }
AlbMultiCursorTest >> randomSpecUsing: aRandom [
	"Return a random spec of up to 12 characters with at least one cursor"

	| text positions |
	text := String new: (aRandom nextInteger: 13) - 1.
	1 to: text size do: [ :i | text at: i put: ('ab c' at: (aRandom nextInteger: 4)) ].
	positions := (0 to: text size) select: [ :each | aRandom next < 0.3 ].
	positions ifEmpty: [ positions := { (aRandom nextInteger: text size + 1) - 1 } ].
	^ String streamContents: [ :out |
		0 to: text size do: [ :i |
			(positions includes: i) ifTrue: [ out nextPut: $| ].
			i < text size ifTrue: [ out nextPut: (text at: i + 1) ] ] ]
]

{ #category : #helpers }
AlbMultiCursorTest >> selectionOf: anEditor [
	"Return the selected intervals as from -> to associations"

	| theBounds |
	theBounds := OrderedCollection new.
	anEditor selection do: [ :each | theBounds add: each from -> each to ].
	^ theBounds asArray
]

{ #category : #helpers }
AlbMultiCursorTest >> setCursorsOf: anEditor from: aSpec [

	| positions index navigator |
	positions := OrderedCollection new.
	index := 0.
	aSpec do: [ :each |
		each = $|
			ifTrue: [ positions add: index ]
			ifFalse: [ index := index + 1 ] ].
	navigator := anEditor navigator.
	navigator moveTo: positions first.
	positions allButFirst do: [ :each | navigator addCursorAt: each ].
	navigator apply
]

{ #category : #helpers }
AlbMultiCursorTest >> specOf: anEditor [
	"Return the text of anEditor with a | at every cursor position"

	| spec |
	spec := anEditor text asString.
	anEditor cursors reverseDo: [ :each |
		spec := (spec first: each position) , '|' , (spec allButFirst: each position) ].
	^ spec
]

{ #category : #'tests - cursors' }
AlbMultiCursorTest >> test_add_cursor_at_existing_position_is_ignored [

	| editor |
	editor := self editorFrom: 'a|bc'.
	editor addCursorAt: 1.
	self assert: (self specOf: editor) equals: 'a|bc'.
	self deny: editor hasMultipleCursors
]

{ #category : #'tests - shortcuts' }
AlbMultiCursorTest >> test_add_cursor_below_and_above [

	| element editor |
	element := self elementFrom: (self lines: #( 'abc' 'd|ef' 'ghi' )).
	editor := element editor.
	space deferAndSettle: [ AlbEditorAddCursorBelowShortcut new performOnEditor: editor element: element dueTo: nil ].
	space deferAndSettle: [ AlbEditorAddCursorAboveShortcut new performOnEditor: editor element: element dueTo: nil ].
	self assert: (self specOf: editor) equals: (self lines: #( 'a|bc' 'd|ef' 'g|hi' ))
]

{ #category : #'tests - deleting' }
AlbMultiCursorTest >> test_backspace_at_every_cursor [

	| editor |
	editor := self editorFrom: 'ab|cd|'.
	editor deleter
		oneBeforeCursor;
		delete.
	self assert: (self specOf: editor) equals: 'a|c|'
]

{ #category : #'tests - selecting' }
AlbMultiCursorTest >> test_backspace_deletes_every_selection [

	| editor |
	editor := self editorFrom: '|one |two |three'.
	editor selecter
		extendToNextWordEnd;
		select.
	editor deleter
		selected;
		oneBeforeCursorIfOutsideOfSelection;
		delete.
	self assert: (self specOf: editor) equals: '| | |'.
	self assert: editor selection isEmpty
]

{ #category : #'tests - deleting' }
AlbMultiCursorTest >> test_backspace_merges_cursors_that_meet [

	| editor |
	editor := self editorFrom: 'a|b|c'.
	editor deleter
		oneBeforeCursor;
		delete.
	self assert: (self specOf: editor) equals: '|c'.
	self deny: editor hasMultipleCursors
]

{ #category : #'tests - copy/paste' }
AlbMultiCursorTest >> test_copy_selections_and_paste_them_one_per_cursor [

	self preservingClipboardDo: [
		| editor |
		editor := self editorFrom: (self lines: #( '|one = 1' '|two = 2' '|three = 3' )).
		editor selecter
			extendToNextWordEnd;
			select.
		editor copySelected.
		self assert: Clipboard clipboardText asString lines asArray equals: #( 'one' 'two' 'three' ).
		editor deselecter
			all;
			deselect.
		editor navigator
			moveToLineEnd;
			apply.
		editor paste.
		self assert: (self specOf: editor) equals: (self lines: #( 'one = 1one|' 'two = 2two|' 'three = 3three|' )) ]
]

{ #category : #'tests - cursors' }
AlbMultiCursorTest >> test_cursors_are_sorted_and_primary_is_kept [

	| editor |
	editor := self editorFrom: 'ab|c|d'.
	editor addCursorAt: 0.
	self assert: (editor cursors collect: [ :each | each position ]) equals: #( 0 2 3 ).
	self assert: editor cursor position equals: 2.
	self assert: editor hasMultipleCursors
]

{ #category : #'tests - rendering' }
AlbMultiCursorTest >> test_cursors_in_the_same_word_are_all_displayed [

	| element positions |
	element := self elementFrom: 'o|n|e two'.
	positions := (self cursorElementsIn: element) collect: [ :each | each parent text asString -> each textPosition ].
	self assert: positions asSet equals: { 'one' -> 1. 'one' -> 2 } asSet
]

{ #category : #'tests - copy/paste' }
AlbMultiCursorTest >> test_cut_removes_every_selection [

	self preservingClipboardDo: [
		| editor |
		editor := self editorFrom: '|one |two |three'.
		editor selecter
			extendToNextWordEnd;
			select.
		editor cutSelected.
		self assert: (self specOf: editor) equals: '| | |'.
		self assert: editor selection isEmpty.
		self assert: Clipboard clipboardText asString lines asArray equals: #( 'one' 'two' 'three' ) ]
]

{ #category : #'tests - copy/paste' }
AlbMultiCursorTest >> test_cut_single_selection_is_unchanged [

	self preservingClipboardDo: [
		| editor |
		editor := self editorFrom: 'one |two three'.
		editor selecter
			extendToNextWordEnd;
			select.
		editor cutSelected.
		self assert: (self specOf: editor) equals: 'one | three'.
		self assert: Clipboard clipboardText asString equals: 'two' ]
]

{ #category : #'tests - shortcuts' }
AlbMultiCursorTest >> test_escape_keeps_only_the_primary_cursor [

	| element |
	element := self elementFrom: 'a|b|c|'.
	space deferAndSettle: [ AlbEditorDeselectAllShortcut new performOnEditor: element editor element: element dueTo: nil ].
	self assert: (self specOf: element editor) equals: 'a|bc'
]

{ #category : #'tests - selecting' }
AlbMultiCursorTest >> test_extend_selection_at_every_cursor [

	| editor |
	editor := self editorFrom: '|one |two |three'.
	editor selecter
		moveOneToRight;
		select.
	editor selecter
		moveOneToRight;
		select.
	self assert: (self specOf: editor) equals: 'on|e tw|o th|ree'.
	self assert: (self selectionOf: editor) equals: { 0 -> 2. 4 -> 6. 8 -> 10 }
]

{ #category : #'tests - selecting' }
AlbMultiCursorTest >> test_extend_selection_down_at_every_cursor [

	| element |
	element := self elementFrom: (self lines: #( '|abc' 'def' '|ghi' 'jkl' )).
	space deferAndSettle: [
		element editor selecter
			moveOneDown;
			select ].
	self assert: (self specOf: element editor) equals: (self lines: #( 'abc' '|def' 'ghi' '|jkl' )).
	self assert: (self selectionOf: element editor) equals: { 0 -> 4. 8 -> 12 }
]

{ #category : #'tests - selecting' }
AlbMultiCursorTest >> test_extend_selection_to_word_end_at_every_cursor [

	| editor |
	editor := self editorFrom: '|one |two |three'.
	editor selecter
		extendToNextWordEnd;
		select.
	self assert: (self specOf: editor) equals: 'one| two| three|'.
	self assert: (self selectionOf: editor) equals: { 0 -> 3. 4 -> 7. 8 -> 13 }
]

{ #category : #'tests - deleting' }
AlbMultiCursorTest >> test_forward_delete_at_every_cursor [

	| editor |
	editor := self editorFrom: '|ab|cd'.
	editor deleter
		oneAfterCursor;
		delete.
	self assert: (self specOf: editor) equals: '|b|d'
]

{ #category : #'tests - deleting' }
AlbMultiCursorTest >> test_forward_delete_merges_cursors_that_meet [

	| editor |
	editor := self editorFrom: '|a|bc'.
	editor deleter
		oneAfterCursor;
		delete.
	self assert: (self specOf: editor) equals: '|c'
]

{ #category : #'tests - inserting' }
AlbMultiCursorTest >> test_insert_at_every_cursor [

	| editor |
	editor := self editorFrom: 'a|b|c|'.
	editor inserter
		atCursor;
		string: 'X';
		insert.
	self assert: (self specOf: editor) equals: 'aX|bX|cX|'
]

{ #category : #'tests - inserting' }
AlbMultiCursorTest >> test_insert_at_start_and_end [

	| editor |
	editor := self editorFrom: '|abc|'.
	editor inserter
		atCursor;
		string: '#';
		insert.
	self assert: (self specOf: editor) equals: '#|abc#|'
]

{ #category : #'tests - inserting' }
AlbMultiCursorTest >> test_insert_several_characters_at_adjacent_cursors [

	| editor |
	editor := self editorFrom: 'a|b|'.
	editor inserter
		atCursor;
		string: 'xyz';
		insert.
	self assert: (self specOf: editor) equals: 'axyz|bxyz|'
]

{ #category : #'tests - cursors' }
AlbMultiCursorTest >> test_last_cursor_is_never_removed [

	| editor |
	editor := self editorFrom: 'a|bc'.
	editor navigator
		removeCursorAt: 1;
		apply.
	self assert: (self specOf: editor) equals: 'a|bc'
]

{ #category : #'tests - inserting' }
AlbMultiCursorTest >> test_line_ending_keeps_the_indentation_of_each_cursor_line [

	| editor |
	editor := self editorFrom: (self lines: { String tab , 'a|'. 'b|' }).
	editor inserter
		atCursor;
		crLineEndingWithWhitespace;
		insert.
	self assert: (self specOf: editor) equals: (self lines: { String tab , 'a'. String tab , '|'. 'b'. '|' })
]

{ #category : #'tests - rendering' }
AlbMultiCursorTest >> test_merged_cursors_remove_their_elements [

	| element |
	element := self elementFrom: 'a|b|cd|'.
	space deferAndSettle: [
		element editor deleter
			oneBeforeCursor;
			delete ].
	self assert: (self specOf: element editor) equals: '|c|'.
	self assert: (self cursorElementsIn: element) size equals: 2
]

{ #category : #'tests - cursors' }
AlbMultiCursorTest >> test_moveTo_keeps_a_single_cursor [

	| editor |
	editor := self editorFrom: 'a|b|c|'.
	editor navigator
		moveTo: 0;
		apply.
	self assert: (self specOf: editor) equals: '|abc'
]

{ #category : #'tests - navigating' }
AlbMultiCursorTest >> test_move_down_moves_every_cursor [

	| element |
	element := self elementFrom: (self lines: #( 'a|bc|' 'def' 'ghi' )).
	space deferAndSettle: [
		element editor navigator
			moveDown;
			apply ].
	self assert: (self specOf: element editor) equals: (self lines: #( 'abc' 'd|ef|' 'ghi' ))
]

{ #category : #'tests - navigating' }
AlbMultiCursorTest >> test_move_left_and_right_move_every_cursor [

	| editor |
	editor := self editorFrom: 'a|bc|d'.
	editor navigator
		moveRight;
		apply.
	self assert: (self specOf: editor) equals: 'ab|cd|'.
	editor navigator
		moveLeft;
		apply.
	editor navigator
		moveLeft;
		apply.
	self assert: (self specOf: editor) equals: '|ab|cd'
]

{ #category : #'tests - navigating' }
AlbMultiCursorTest >> test_move_left_merges_cursors_at_text_start [

	| editor |
	editor := self editorFrom: '|a|b'.
	editor navigator
		moveLeft;
		apply.
	self assert: (self specOf: editor) equals: '|ab'
]

{ #category : #'tests - navigating' }
AlbMultiCursorTest >> test_move_to_line_start_and_end_per_cursor [

	| editor |
	editor := self editorFrom: (self lines: #( 'ab|c' 'd|ef' )).
	editor navigator
		moveToLineEnd;
		apply.
	self assert: (self specOf: editor) equals: (self lines: #( 'abc|' 'def|' )).
	editor navigator
		moveToLineStart;
		apply.
	self assert: (self specOf: editor) equals: (self lines: #( '|abc' '|def' ))
]

{ #category : #'tests - rendering' }
AlbMultiCursorTest >> test_one_cursor_element_per_cursor [

	| element cursorElements |
	element := self elementFrom: (self lines: #( 'o|ne t|wo' 'thr|ee' )).
	cursorElements := self cursorElementsIn: element.
	self assert: cursorElements size equals: 3.
	self assert: (cursorElements select: [ :each | each == element cursorElement ]) size equals: 1
]

{ #category : #'tests - copy/paste' }
AlbMultiCursorTest >> test_paste_at_every_cursor [

	| editor |
	editor := self editorFrom: 'a|b|'.
	editor paster
		text: '--';
		atCursor;
		paste.
	self assert: (self specOf: editor) equals: 'a--|b--|'
]

{ #category : #'tests - copy/paste' }
AlbMultiCursorTest >> test_paste_ignores_a_trailing_line_ending [

	| editor |
	editor := self editorFrom: 'a|b|'.
	editor paster
		text: (self lines: #( 'X' 'Y' '' ));
		atCursor;
		paste.
	self assert: (self specOf: editor) equals: 'aX|bY|'
]

{ #category : #'tests - copy/paste' }
AlbMultiCursorTest >> test_paste_multiple_lines_with_a_single_cursor [

	| editor |
	editor := self editorFrom: 'a|b'.
	editor paster
		text: (self lines: #( 'X' 'Y' ));
		atCursor;
		paste.
	self assert: (self specOf: editor) equals: (self lines: #( 'aX' 'Y|b' ))
]

{ #category : #'tests - copy/paste' }
AlbMultiCursorTest >> test_paste_one_line_per_cursor [

	| editor |
	editor := self editorFrom: 'a|b|c|'.
	editor paster
		text: (self lines: #( 'X' 'Y' 'Z' ));
		atCursor;
		paste.
	self assert: (self specOf: editor) equals: 'aX|bY|cZ|'
]

{ #category : #'tests - copy/paste' }
AlbMultiCursorTest >> test_paste_whole_text_when_line_count_differs [

	| editor |
	editor := self editorFrom: 'a|b|'.
	editor paster
		text: (self lines: #( 'X' 'Y' 'Z' ));
		atCursor;
		paste.
	self assert: (self specOf: editor) equals: (self lines: #( 'aX' 'Y' 'Z|bX' 'Y' 'Z|' ))
]

{ #category : #'tests - oracle' }
AlbMultiCursorTest >> test_random_backspaces_match_oracle [

	| random |
	random := Random seed: 7.
	200 timesRepeat: [
		| spec editor |
		spec := self randomSpecUsing: random.
		editor := self editorFrom: spec.
		editor deleter
			oneBeforeCursor;
			delete.
		self assert: (self specOf: editor) equals: (self backspaceOracle: spec) ]
]

{ #category : #'tests - oracle' }
AlbMultiCursorTest >> test_random_insertions_match_oracle [

	| random |
	random := Random seed: 42.
	200 timesRepeat: [
		| spec editor |
		spec := self randomSpecUsing: random.
		editor := self editorFrom: spec.
		editor inserter
			atCursor;
			string: 'xy';
			insert.
		self
			assert: (self specOf: editor)
			equals: (spec copyReplaceAll: '|' with: 'xy|') ]
]

{ #category : #'tests - cursors' }
AlbMultiCursorTest >> test_removeSecondaryCursors [

	| editor |
	editor := self editorFrom: 'a|b|c|'.
	editor removeSecondaryCursors.
	self assert: (self specOf: editor) equals: 'a|bc'
]

{ #category : #'tests - cursors' }
AlbMultiCursorTest >> test_remove_primary_cursor_promotes_a_secondary_one [

	| editor |
	editor := self editorFrom: '|ab|c'.
	editor navigator
		removeCursorAt: 0;
		apply.
	self assert: (self specOf: editor) equals: 'ab|c'.
	self assert: editor cursor position equals: 2
]

{ #category : #'tests - selecting' }
AlbMultiCursorTest >> test_select_all_keeps_a_single_cursor [
	"An explicit range replaces the cursors, as in VS Code"

	| editor |
	editor := self editorFrom: 'a|b|c'.
	editor selecter
		all;
		select.
	self assert: (self specOf: editor) equals: 'abc|'.
	self assert: (self selectionOf: editor) equals: { 0 -> 3 }
]

{ #category : #'tests - copy/paste' }
AlbMultiCursorTest >> test_selected_texts_one_per_selection [

	| editor |
	editor := self editorFrom: '|one |two |three'.
	editor selecter
		extendToNextWordEnd;
		select.
	self assert: editor selectedTexts equals: #( 'one' 'two' 'three' )
]

{ #category : #'tests - selecting' }
AlbMultiCursorTest >> test_selections_that_meet_merge_their_cursors [
	"The cursor kept is the one at the edge of the merged selection; it becomes primary"

	| editor |
	editor := self editorFrom: 'a|bc|def'.
	editor selecter
		moveOneToRight;
		select.
	editor selecter
		moveOneToRight;
		select.
	self assert: (self specOf: editor) equals: 'abcde|f'.
	self assert: (self selectionOf: editor) equals: { 1 -> 5 }.
	self deny: editor hasMultipleCursors.
	editor selecter
		moveOneToLeft;
		select.
	self assert: (self selectionOf: editor) equals: { 1 -> 4 }
]

{ #category : #'tests - selecting' }
AlbMultiCursorTest >> test_shrink_selection_at_every_cursor [

	| editor |
	editor := self editorFrom: '|one |two |three'.
	editor selecter
		moveOneToRight;
		select.
	editor selecter
		moveOneToRight;
		select.
	editor selecter
		moveOneToLeft;
		select.
	self assert: (self specOf: editor) equals: 'o|ne t|wo t|hree'.
	self assert: (self selectionOf: editor) equals: { 0 -> 1. 4 -> 5. 8 -> 9 }
]

{ #category : #'tests - selecting' }
AlbMultiCursorTest >> test_typing_over_selections_keeps_one_cursor_element_per_cursor [

	| element |
	element := self elementFrom: '|one |two |three'.
	space deferAndSettle: [
		element editor selecter
			extendToNextWordEnd;
			select.
		element editor inserter
			atCursor;
			string: 'X';
			insert ].
	self assert: (self specOf: element editor) equals: 'X| X| X|'.
	self assert: (self cursorElementsIn: element) size equals: 3
]

{ #category : #'tests - selecting' }
AlbMultiCursorTest >> test_typing_over_selections_undo_and_redo [
	"As with a single cursor, replacing selected text is undone in two steps: the insertion, then the deletion"

	| editor |
	editor := self editorFrom: '|one |two |three'.
	editor selecter
		extendToNextWordEnd;
		select.
	editor inserter
		atCursor;
		string: 'X';
		insert.
	editor undo.
	self assert: (self specOf: editor) equals: '| | |'.
	editor undo.
	self assert: (self specOf: editor) equals: 'one| two| three|'.
	editor redo.
	editor redo.
	self assert: (self specOf: editor) equals: 'X| X| X|'
]

{ #category : #'tests - selecting' }
AlbMultiCursorTest >> test_typing_replaces_every_selection [

	| editor |
	editor := self editorFrom: '|one |two |three'.
	editor selecter
		extendToNextWordEnd;
		select.
	editor inserter
		atCursor;
		string: 'X';
		insert.
	self assert: (self specOf: editor) equals: 'X| X| X|'.
	self assert: editor selection isEmpty
]

{ #category : #'tests - history' }
AlbMultiCursorTest >> test_undo_and_redo_insertion_restore_every_cursor [

	| editor |
	editor := self editorFrom: 'a|b|c'.
	editor inserter
		atCursor;
		string: 'X';
		insert.
	editor undo.
	self assert: (self specOf: editor) equals: 'a|b|c'.
	editor redo.
	self assert: (self specOf: editor) equals: 'aX|bX|c'
]

{ #category : #'tests - history' }
AlbMultiCursorTest >> test_undo_deletion_restores_every_cursor [

	| editor |
	editor := self editorFrom: 'ab|cd|'.
	editor deleter
		oneBeforeCursor;
		delete.
	editor undo.
	self assert: (self specOf: editor) equals: 'ab|cd|'
]
