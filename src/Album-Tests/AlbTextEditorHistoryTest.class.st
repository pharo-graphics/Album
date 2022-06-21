Class {
	#name : #AlbTextEditorHistoryTest,
	#superclass : #TestCase,
	#category : #'Album-Tests-Operators'
}

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
