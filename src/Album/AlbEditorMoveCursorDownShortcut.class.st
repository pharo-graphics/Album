Class {
	#name : 'AlbEditorMoveCursorDownShortcut',
	#superclass : 'AlbEditorShortcut',
	#category : 'Album-Shortcuts',
	#package : 'Album',
	#tag : 'Shortcuts'
}

{ #category : 'accessing' }
AlbEditorMoveCursorDownShortcut >> description [
	^ 'Moves the cursor one line at a time below the current position and deselects any selected text.'
]

{ #category : 'initialization' }
AlbEditorMoveCursorDownShortcut >> initialize [
	super initialize.
	
	combination := BlKeyCombination arrowDown
]

{ #category : 'accessing' }
AlbEditorMoveCursorDownShortcut >> name [
	^ 'Move cursor down'
]

{ #category : 'evaluation' }
AlbEditorMoveCursorDownShortcut >> performOnEditor: aTextEditor element: anEditorElement dueTo: aShortcutEvent [


	aTextEditor deselecter
		all;
		deselect.
	aTextEditor navigator
		moveDown;
		withoutResettingDesiredCoordinate;
		apply
]
