"
I test multi-cursor editing in Album.

Editor states are written in a compact notation: the text with a | at every cursor position.
For example 'a|b|c' is the text abc with cursors at positions 1 and 2.
#editorFrom: builds an editor from such a spec (the first | is the primary cursor), #specOf: renders an editor back.
"
Class {
	#name : #AlbMultiCursorTest,
	#superclass : #TestCase,
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
	anEditorElement forceLayout.
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
	"Return a laid out editor element, for operations that need the rendered text"

	| anElement aSpace |
	anElement := AlbEditorElement new.
	anElement constraintsDo: [ :c |
		c horizontal exact: 400.
		c vertical exact: 300 ].
	aSpace := BlSpace new.
	aSpace root addChild: anElement.
	anElement text: (self editorFrom: aSpec) text.
	anElement forceLayout.
	self setCursorsOf: anElement editor from: aSpec.
	anElement forceLayout.
	^ anElement
]

{ #category : #helpers }
AlbMultiCursorTest >> lines: aCollectionOfStrings [

	^ String cr join: aCollectionOfStrings
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
	AlbEditorAddCursorBelowShortcut new performOnEditor: editor element: element dueTo: nil.
	element forceLayout.
	AlbEditorAddCursorAboveShortcut new performOnEditor: editor element: element dueTo: nil.
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

{ #category : #'tests - shortcuts' }
AlbMultiCursorTest >> test_escape_keeps_only_the_primary_cursor [

	| element |
	element := self elementFrom: 'a|b|c|'.
	AlbEditorDeselectAllShortcut new performOnEditor: element editor element: element dueTo: nil.
	self assert: (self specOf: element editor) equals: 'a|bc'
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
	element editor deleter
		oneBeforeCursor;
		delete.
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
	element editor navigator
		moveDown;
		apply.
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

{ #category : #'tests - inserting' }
AlbMultiCursorTest >> test_paste_at_every_cursor [

	| editor |
	editor := self editorFrom: 'a|b|'.
	editor paster
		text: '--';
		atCursor;
		paste.
	self assert: (self specOf: editor) equals: 'a--|b--|'
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
AlbMultiCursorTest >> test_selecting_keeps_only_the_primary_cursor [

	| editor |
	editor := self editorFrom: 'a|b|c'.
	editor select: 0 to: 2.
	self deny: editor hasMultipleCursors.
	self assert: editor cursor position equals: 1
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
