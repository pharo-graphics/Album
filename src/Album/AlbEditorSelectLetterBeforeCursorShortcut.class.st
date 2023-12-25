Class {
	#name : #AlbEditorSelectLetterBeforeCursorShortcut,
	#superclass : #AlbEditorShortcut,
	#category : 'Album-Shortcuts'
}

{ #category : #accessing }
AlbEditorSelectLetterBeforeCursorShortcut >> description [
	^ 'Selects one letter at a time to the left from the cursor.'
]

{ #category : #initialization }
AlbEditorSelectLetterBeforeCursorShortcut >> initialize [
	super initialize.
	
	combination := BlKeyCombination shiftArrowLeft
]

{ #category : #accessing }
AlbEditorSelectLetterBeforeCursorShortcut >> name [
	^ 'Select letter to the left'
]

{ #category : #evaluation }
AlbEditorSelectLetterBeforeCursorShortcut >> performOnEditor: aTextEditor element: aEditorElement dueTo: aShortcutEvent [
	aTextEditor selecter
		moveOneToLeft;
		select
]
