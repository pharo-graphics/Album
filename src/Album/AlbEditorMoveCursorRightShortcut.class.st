Class {
	#name : 'AlbEditorMoveCursorRightShortcut',
	#superclass : 'AlbEditorShortcut',
	#category : 'Album-Shortcuts',
	#package : 'Album',
	#tag : 'Shortcuts'
}

{ #category : 'accessing' }
AlbEditorMoveCursorRightShortcut >> description [
	^ 'Moves the cursor one letter at a time to the right from the current position and deselects any selected text.'
]

{ #category : 'initialization' }
AlbEditorMoveCursorRightShortcut >> initialize [
	super initialize.
	
	combination := BlKeyCombination arrowRight
]

{ #category : 'accessing' }
AlbEditorMoveCursorRightShortcut >> name [
	^ 'Move cursor right'
]

{ #category : 'evaluation' }
AlbEditorMoveCursorRightShortcut >> performOnEditor: aTextEditor element: anEditorElement dueTo: aShortcutEvent [


	aTextEditor deselecter
		all;
		deselect.
	aTextEditor navigator
		moveRight;
		apply
]
