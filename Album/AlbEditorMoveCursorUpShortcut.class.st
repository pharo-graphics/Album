Class {
	#name : #AlbEditorMoveCursorUpShortcut,
	#superclass : #AlbEditorShortcut,
	#category : #'Album-Editor-Shortcuts'
}

{ #category : #accessing }
AlbEditorMoveCursorUpShortcut >> description [
	^ 'Moves the cursor one line at a time above the current position and deselects any selected text.'
]

{ #category : #initialization }
AlbEditorMoveCursorUpShortcut >> initialize [
	super initialize.
	
	combination := BlKeyCombination arrowUp
]

{ #category : #accessing }
AlbEditorMoveCursorUpShortcut >> name [
	^ 'Move cursor up'
]

{ #category : #evaluation }
AlbEditorMoveCursorUpShortcut >> performOnEditor: aTextEditor element: aEditorElement dueTo: aShortcutEvent [
	aTextEditor deselecter
		all;
		deselect.
	aTextEditor navigator
		moveUp;
		withoutResettingDesiredCoordinate;
		apply
]
