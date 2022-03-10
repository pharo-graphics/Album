Class {
	#name : #AlbEditorLineEndingShortcut,
	#superclass : #AlbEditorShortcut,
	#category : #'Album-Editor-Shortcuts'
}

{ #category : #accessing }
AlbEditorLineEndingShortcut >> description [
	^ 'Inserts a platform specific line ending at the cursor location and indents the new line to match the indentation of the previous line.'
]

{ #category : #initialization }
AlbEditorLineEndingShortcut >> initialize [
	super initialize.
	
	combination := BlKeyCombination return
]

{ #category : #accessing }
AlbEditorLineEndingShortcut >> name [
	^ 'Insert line ending'
]

{ #category : #evaluation }
AlbEditorLineEndingShortcut >> performOnEditor: aTextEditor element: aEditorElement dueTo: aShortcutEvent [
	aTextEditor inserter
		inputFilter: aTextEditor inputFilter;
		atCursor;
		lineEndingWithWhitespace;
		insert
]
