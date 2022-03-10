Class {
	#name : #AlbEditorMoveCursorToLineEndShortcut,
	#superclass : #AlbEditorShortcut,
	#category : #'Album-Editor-Shortcuts'
}

{ #category : #accessing }
AlbEditorMoveCursorToLineEndShortcut >> description [
	^ 'Moves the cursor to the end of the current line and deselects any selected text.'
]

{ #category : #initialization }
AlbEditorMoveCursorToLineEndShortcut >> initialize [
	super initialize.
	
	combination := BlKeyCombination primaryArrowRight.

]

{ #category : #accessing }
AlbEditorMoveCursorToLineEndShortcut >> name [
	^ 'Move cursor to the line end'
]

{ #category : #evaluation }
AlbEditorMoveCursorToLineEndShortcut >> performOnEditor: aTextEditor element: aEditorElement dueTo: aShortcutEvent [
	aTextEditor deselecter
		all;
		deselect.
	aTextEditor navigator
		moveToLineEnd;
		apply
]
