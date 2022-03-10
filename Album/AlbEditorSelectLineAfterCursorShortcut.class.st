Class {
	#name : #AlbEditorSelectLineAfterCursorShortcut,
	#superclass : #AlbEditorShortcut,
	#instVars : [
		'combinationForUnix'
	],
	#category : #'Album-Shortcuts'
}

{ #category : #accessing }
AlbEditorSelectLineAfterCursorShortcut >> description [
	^ 'Extends the selection from the current cursor position to the end of a line.'
]

{ #category : #initialization }
AlbEditorSelectLineAfterCursorShortcut >> initialize [
	super initialize.
	
	combination := BlKeyCombination primaryShiftArrowRight.

]

{ #category : #accessing }
AlbEditorSelectLineAfterCursorShortcut >> name [
	^ 'Select to the end of a line'
]

{ #category : #evaluation }
AlbEditorSelectLineAfterCursorShortcut >> performOnEditor: aTextEditor element: aEditorElement dueTo: aShortcutEvent [
	aTextEditor selecter
		extendToLineEnd;
		select
]
