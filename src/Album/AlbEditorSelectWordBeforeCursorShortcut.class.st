Class {
	#name : #AlbEditorSelectWordBeforeCursorShortcut,
	#superclass : #AlbEditorShortcut,
	#instVars : [
		'combinationForMacOS'
	],
	#category : 'Album-Shortcuts'
}

{ #category : #'api - combination' }
AlbEditorSelectWordBeforeCursorShortcut >> combinationForMacOS [
	^ combinationForMacOS
]

{ #category : #accessing }
AlbEditorSelectWordBeforeCursorShortcut >> description [
	^ 'Extends the selection from the current cursor position to the beginning of previous word.'
]

{ #category : #initialization }
AlbEditorSelectWordBeforeCursorShortcut >> initialize [
	super initialize.
	
	combination := BlKeyCombination builder shift control arrowLeft build.
	combinationForMacOS := BlKeyCombination builder shift alt arrowLeft build.
]

{ #category : #accessing }
AlbEditorSelectWordBeforeCursorShortcut >> name [
	^ 'Select previous word'
]

{ #category : #evaluation }
AlbEditorSelectWordBeforeCursorShortcut >> performOnEditor: aTextEditor element: aEditorElement dueTo: aShortcutEvent [
	aTextEditor selecter
		extendToPreviousWordStart;
		select
]
