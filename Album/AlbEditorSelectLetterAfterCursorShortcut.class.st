Class {
	#name : #AlbEditorSelectLetterAfterCursorShortcut,
	#superclass : #AlbEditorShortcut,
	#category : #'Album-Editor-Shortcuts'
}

{ #category : #accessing }
AlbEditorSelectLetterAfterCursorShortcut >> description [
	^ 'Selects one letter at a time to the right from the cursor.'
]

{ #category : #initialization }
AlbEditorSelectLetterAfterCursorShortcut >> initialize [
	super initialize.
	
	combination := BlKeyCombination shiftArrowRight
]

{ #category : #accessing }
AlbEditorSelectLetterAfterCursorShortcut >> name [
	^ 'Select letter to the right'
]

{ #category : #evaluation }
AlbEditorSelectLetterAfterCursorShortcut >> performOnEditor: aTextEditor element: aEditorElement dueTo: aShortcutEvent [
	aTextEditor selecter
		moveOneToRight;
		select
]
