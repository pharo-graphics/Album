Class {
	#name : 'AlbEditorSelectLineBeforeCursorShortcut',
	#superclass : 'AlbEditorShortcut',
	#category : 'Album-Shortcuts',
	#package : 'Album',
	#tag : 'Shortcuts'
}

{ #category : 'accessing' }
AlbEditorSelectLineBeforeCursorShortcut >> description [
	^ 'Extends the selection from the current cursor position to the beginning of a line.'
]

{ #category : 'initialization' }
AlbEditorSelectLineBeforeCursorShortcut >> initialize [
	super initialize.
	
	combination := BlKeyCombination primaryShiftArrowLeft.

]

{ #category : 'accessing' }
AlbEditorSelectLineBeforeCursorShortcut >> name [
	^ 'Select to the beginning of a line'
]

{ #category : 'evaluation' }
AlbEditorSelectLineBeforeCursorShortcut >> performOnEditor: aTextEditor element: aEditorElement dueTo: aShortcutEvent [
	aTextEditor selecter
		extendToLineStart;
		select
]
