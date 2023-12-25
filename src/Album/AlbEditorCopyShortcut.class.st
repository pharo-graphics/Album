Class {
	#name : #AlbEditorCopyShortcut,
	#superclass : #AlbEditorShortcut,
	#category : 'Album-Shortcuts'
}

{ #category : #accessing }
AlbEditorCopyShortcut >> description [
	^ 'Copies the selection text into the clipboard.'
]

{ #category : #initialization }
AlbEditorCopyShortcut >> initialize [
	super initialize.
	
	combination := BlKeyCombination primaryC
]

{ #category : #accessing }
AlbEditorCopyShortcut >> name [
	^ 'Copy'
]

{ #category : #evaluation }
AlbEditorCopyShortcut >> performOnEditor: aTextEditor element: anEditorElement dueTo: aShortcutEvent [

	aTextEditor copySelected
]
