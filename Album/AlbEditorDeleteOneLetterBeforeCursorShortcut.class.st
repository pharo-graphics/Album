Class {
	#name : #AlbEditorDeleteOneLetterBeforeCursorShortcut,
	#superclass : #AlbEditorShortcut,
	#category : #'Album-Editor-Shortcuts'
}

{ #category : #accessing }
AlbEditorDeleteOneLetterBeforeCursorShortcut >> description [
	^ 'Moves the display cursor one position backwards, deletes the character at that position, and shifts back the text after that position by one position.'
]

{ #category : #initialization }
AlbEditorDeleteOneLetterBeforeCursorShortcut >> initialize [
	super initialize.
	
	combination := BlKeyCombination backspace
]

{ #category : #accessing }
AlbEditorDeleteOneLetterBeforeCursorShortcut >> name [
	^ 'Delete'
]

{ #category : #evaluation }
AlbEditorDeleteOneLetterBeforeCursorShortcut >> performOnEditor: aTextEditor element: aEditorElement dueTo: aShortcutEvent [
	aTextEditor deleter
		selected;
		oneBeforeCursorIfOutsideOfSelection;
		surroundings: aTextEditor surroundMap;
		delete
]
