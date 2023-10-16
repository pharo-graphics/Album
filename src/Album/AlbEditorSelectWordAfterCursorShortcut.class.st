Class {
	#name : 'AlbEditorSelectWordAfterCursorShortcut',
	#superclass : 'AlbEditorShortcut',
	#instVars : [
		'combinationForMacOS'
	],
	#category : 'Album-Shortcuts',
	#package : 'Album',
	#tag : 'Shortcuts'
}

{ #category : 'api - combination' }
AlbEditorSelectWordAfterCursorShortcut >> combinationForMacOS [
	^ combinationForMacOS
]

{ #category : 'accessing' }
AlbEditorSelectWordAfterCursorShortcut >> description [
	^ 'Extends the selection from the current cursor position to the end of the next word.'
]

{ #category : 'initialization' }
AlbEditorSelectWordAfterCursorShortcut >> initialize [
	super initialize.
	
	combination := BlKeyCombination builder shift control arrowRight build.
	combinationForMacOS := BlKeyCombination builder shift alt arrowRight build.
]

{ #category : 'accessing' }
AlbEditorSelectWordAfterCursorShortcut >> name [
	^ 'Select next word'
]

{ #category : 'evaluation' }
AlbEditorSelectWordAfterCursorShortcut >> performOnEditor: aTextEditor element: aEditorElement dueTo: aShortcutEvent [
	aTextEditor selecter
		extendToNextWordEnd;
		select
]
