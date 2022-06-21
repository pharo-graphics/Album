Class {
	#name : #AlbTextEditorHistoryTest,
	#superclass : #TestCase,
	#category : #'Album-Tests-TextEditor'
}

{ #category : #tests }
AlbTextEditorHistoryTest >> test_insert_one_char_and_undo [
	
	| editorElement editor |
	editorElement := '' asRopedText onAlbum.
	editor := editorElement editor.
	(editor inserter)
		at: 0;
		string: 'A';
		insert.
	self assert: editor text asString equals: 'A'.
	editor undo.
	self assert: editor text asString equals: ''.
	^ editorElement
]

{ #category : #tests }
AlbTextEditorHistoryTest >> test_insert_one_char_and_undo_then_redo [
	
	| editorElement editor |
	editorElement := '' asRopedText onAlbum.
	editor := editorElement editor.
	(editor inserter)
		at: 0;
		string: 'A';
		insert.
	editor undo.
	editor redo.
	self assert: editor text asString equals: 'A'.
	^ editorElement
]

{ #category : #tests }
AlbTextEditorHistoryTest >> test_insert_open_close_parentheses_with_selection_and_undo [
	
	| editorElement editor |
	editorElement := '' asRopedText onAlbum.
	editor := editorElement editor.
	(editor inserter)
		at: 0;
		string: 'abc';
		insert.
	editor selecter all select.
	(editor inserter)
		atCursor;
		string: '(';
		withoutSelectionDelete;
		surroundings:
				(AlbTextEditorSurroundMap
						newFromArray:
							{'('.
								')'.
								nil});
		insert.
	self assert: editor text asString equals: '(abc)'.
	editor undo.
	self assert: editor text asString equals: 'abc'.
	^ editorElement
]

{ #category : #tests }
AlbTextEditorHistoryTest >> test_insert_select_remove_and_undo_then_redo [
	
	| editorElement editor s |
	s := 'to be selected and removed'.
	editorElement := s asRopedText onAlbum.
	editor := editorElement editor.
	self assert: editor text asString equals: s.
	(editor selecter)
		all;
		select.
	(editor inserter)
		string: Character backspace asString;
		insert.
	self flag: 'the editor text become invalid here because $backspace is not a valid character for a text. Have to see if invalid character should be forbidden in inserter (filter ?). see AlbEditorDeleteOneLetterBeforeCursorShortcut, it implements the valid backspace treatement'.
	self assert: editor text asString equals: ''.
	editor undo.
	self assert: editor text asString equals: s.
	editor redo.
	self assert: editor text asString equals: ''.
	^ editorElement
]

{ #category : #tests }
AlbTextEditorHistoryTest >> test_insert_select_remove_and_undo_then_redo2 [
	
	| editorElement editor s |
	s := 'to be selected and removed'.
	editorElement := s asRopedText onAlbum.
	editor := editorElement editor.
	self assert: editor text asString equals: s.
	(editor selecter)
		all;
		select.
	(editor deleter)
		selected;
		delete.

	self assert: editor text asString equals: ''.
	editor undo.
	self assert: editor text asString equals: s.
	editor redo.
	self assert: editor text asString equals: ''.
	^ editorElement
]

{ #category : #tests }
AlbTextEditorHistoryTest >> test_insert_select_remove_and_undo_then_redo3 [
	
	| editorElement editor s |
	s := 'to be selected and removed'.
	editorElement := s asRopedText onAlbum.
	editor := editorElement editor.
	self assert: editor text asString equals: s.
	(editor selecter)
		all;
		select.
	(editor inserter)
		string: 'X';
		insert.
	self assert: editor text asString equals: 'X'.
	editor undo.
	self assert: editor text isEmpty.
	editor undo.
	self assert: editor text asString equals: s.
	editor redo.
	self assert: editor text isEmpty.
	editor redo.
	self assert: editor text asString equals: 'X'.
	^ editorElement
]
