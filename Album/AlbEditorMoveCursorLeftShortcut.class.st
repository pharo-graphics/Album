Class {
	#name : #AlbEditorMoveCursorLeftShortcut,
	#superclass : #AlbEditorShortcut,
	#category : #'Album-Editor-Shortcuts'
}

{ #category : #accessing }
AlbEditorMoveCursorLeftShortcut >> description [
	^ 'Moves the cursor one letter at a time to the left from the current position and deselects any selected text.'
]

{ #category : #initialization }
AlbEditorMoveCursorLeftShortcut >> initialize [
	super initialize.
	
	combination := BlKeyCombination arrowLeft
]

{ #category : #accessing }
AlbEditorMoveCursorLeftShortcut >> name [
	^ 'Move cursor left'
]

{ #category : #evaluation }
AlbEditorMoveCursorLeftShortcut >> performOnEditor: aTextEditor element: aEditorElement dueTo: aShortcutEvent [
	aTextEditor deselecter
		all;
		deselect.
	aTextEditor navigator
		moveLeft;
		apply
]
