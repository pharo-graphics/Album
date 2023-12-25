Class {
	#name : #AlbEditorMoveCursorToNextWordShortcut,
	#superclass : #AlbEditorShortcut,
	#instVars : [
		'combinationForMacOS'
	],
	#category : 'Album-Shortcuts'
}

{ #category : #'api - combination' }
AlbEditorMoveCursorToNextWordShortcut >> combinationForMacOS [
	^ combinationForMacOS
]

{ #category : #accessing }
AlbEditorMoveCursorToNextWordShortcut >> description [
	^ 'Moves the cursor to the end of the next (or current) word and deselects any selected text.'
]

{ #category : #initialization }
AlbEditorMoveCursorToNextWordShortcut >> initialize [
	super initialize.
	
	combination := BlKeyCombination builder control arrowRight build.
	combinationForMacOS := BlKeyCombination builder alt arrowRight build.
]

{ #category : #accessing }
AlbEditorMoveCursorToNextWordShortcut >> name [
	^ 'Move cursor to the next word'
]

{ #category : #evaluation }
AlbEditorMoveCursorToNextWordShortcut >> performOnEditor: aTextEditor element: aEditorElement dueTo: aShortcutEvent [

	aTextEditor deselecter
		all;
		deselect.
	aTextEditor navigator
		moveToEndNextWord;
		apply
]
