Class {
	#name : #AlbEditorPasteShortcut,
	#superclass : #AlbEditorShortcut,
	#category : #'Album-Shortcuts'
}

{ #category : #accessing }
AlbEditorPasteShortcut >> description [
	^ 'Paste a text from the clipboard at the current cursor position and delete any currently selected text.'
]

{ #category : #initialization }
AlbEditorPasteShortcut >> initialize [
	super initialize.
	
	combination := BlKeyCombination primaryV
]

{ #category : #accessing }
AlbEditorPasteShortcut >> name [
	^ 'Paste'
]

{ #category : #evaluation }
AlbEditorPasteShortcut >> performOnEditor: aTextEditor element: aEditorElement dueTo: aShortcutEvent [
	aTextEditor paster
		inputFilter: aTextEditor inputFilter;
		fromClipboard;
		atCursor;
		paste
]
