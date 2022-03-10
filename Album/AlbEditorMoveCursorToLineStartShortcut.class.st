Class {
	#name : #AlbEditorMoveCursorToLineStartShortcut,
	#superclass : #AlbEditorShortcut,
	#category : #'Album-Editor-Shortcuts'
}

{ #category : #accessing }
AlbEditorMoveCursorToLineStartShortcut >> description [
	^ 'Moves the cursor to the start of the current line and deselects any selected text.'
]

{ #category : #initialization }
AlbEditorMoveCursorToLineStartShortcut >> initialize [
	super initialize.
	
	combination := BlKeyCombination primaryArrowLeft.

]

{ #category : #accessing }
AlbEditorMoveCursorToLineStartShortcut >> name [
	^ 'Move cursor to the line start'
]

{ #category : #evaluation }
AlbEditorMoveCursorToLineStartShortcut >> performOnEditor: aTextEditor element: aEditorElement dueTo: aShortcutEvent [
	aTextEditor deselecter
		all;
		deselect.
	aTextEditor navigator
		moveToLineStart;
		apply
]
