Class {
	#name : 'AlbEditorDeleteOneLetterAfterCursorShortcut',
	#superclass : 'AlbEditorShortcut',
	#category : 'Album-Shortcuts',
	#package : 'Album',
	#tag : 'Shortcuts'
}

{ #category : 'accessing' }
AlbEditorDeleteOneLetterAfterCursorShortcut >> description [
	^ 'Discards the character ahead of the cursor''s position, moving all following characters one position "back" towards the freed letterspace.'
]

{ #category : 'initialization' }
AlbEditorDeleteOneLetterAfterCursorShortcut >> initialize [
	super initialize.
	
	combination := BlKeyCombination delete
]

{ #category : 'accessing' }
AlbEditorDeleteOneLetterAfterCursorShortcut >> name [
	^ 'Forward delete'
]

{ #category : 'evaluation' }
AlbEditorDeleteOneLetterAfterCursorShortcut >> performOnEditor: aTextEditor element: anEditorElement dueTo: aShortcutEvent [

	aTextEditor deleter
		selected;
		oneAfterCursorIfOutsideOfSelection;
		delete
]
