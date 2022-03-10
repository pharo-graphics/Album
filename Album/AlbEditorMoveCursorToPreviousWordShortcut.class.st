Class {
	#name : #AlbEditorMoveCursorToPreviousWordShortcut,
	#superclass : #AlbEditorShortcut,
	#instVars : [
		'combinationForMacOS'
	],
	#category : #'Album-Editor-Shortcuts'
}

{ #category : #'api - combination' }
AlbEditorMoveCursorToPreviousWordShortcut >> combinationForMacOS [
	^ combinationForMacOS
]

{ #category : #accessing }
AlbEditorMoveCursorToPreviousWordShortcut >> description [
	^ 'Moves the cursor to the start of the previous (or current) word and deselects any selected text.'
]

{ #category : #initialization }
AlbEditorMoveCursorToPreviousWordShortcut >> initialize [
	super initialize.

	combination := BlKeyCombination builder control arrowLeft build.
	combinationForMacOS := BlKeyCombination builder alt arrowLeft build.
]

{ #category : #accessing }
AlbEditorMoveCursorToPreviousWordShortcut >> name [
	^ 'Move cursor to the previous word'
]

{ #category : #evaluation }
AlbEditorMoveCursorToPreviousWordShortcut >> performOnEditor: aTextEditor element: aEditorElement dueTo: aShortcutEvent [
	aTextEditor deselecter
		all;
		deselect.

	aTextEditor navigator
		moveToStartPreviousWord;
		apply
]
