Class {
	#name : 'AlbEditorSelectLineAboveCursorShortcut',
	#superclass : 'AlbEditorShortcut',
	#category : 'Album-Shortcuts',
	#package : 'Album',
	#tag : 'Shortcuts'
}

{ #category : 'accessing' }
AlbEditorSelectLineAboveCursorShortcut >> description [
	^ 'Selects one line at a time above the cursor.'
]

{ #category : 'initialization' }
AlbEditorSelectLineAboveCursorShortcut >> initialize [
	super initialize.
	
	combination := BlKeyCombination shiftArrowUp
]

{ #category : 'accessing' }
AlbEditorSelectLineAboveCursorShortcut >> name [
	^ 'Select line above'
]

{ #category : 'evaluation' }
AlbEditorSelectLineAboveCursorShortcut >> performOnEditor: aTextEditor element: aEditorElement dueTo: aShortcutEvent [
	aTextEditor selecter
		moveOneUp;
		select
]
