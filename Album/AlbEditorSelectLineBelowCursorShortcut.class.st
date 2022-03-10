Class {
	#name : #AlbEditorSelectLineBelowCursorShortcut,
	#superclass : #AlbEditorShortcut,
	#category : #'Album-Editor-Shortcuts'
}

{ #category : #accessing }
AlbEditorSelectLineBelowCursorShortcut >> description [
	^ 'Selects one line at a time below the cursor.'
]

{ #category : #initialization }
AlbEditorSelectLineBelowCursorShortcut >> initialize [
	super initialize.
	
	combination := BlKeyCombination shiftArrowDown
]

{ #category : #accessing }
AlbEditorSelectLineBelowCursorShortcut >> name [
	^ 'Select line below'
]

{ #category : #evaluation }
AlbEditorSelectLineBelowCursorShortcut >> performOnEditor: aTextEditor element: aEditorElement dueTo: aShortcutEvent [
	aTextEditor selecter
		moveOneDown;
		select
]
