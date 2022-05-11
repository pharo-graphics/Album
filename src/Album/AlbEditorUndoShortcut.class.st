Class {
	#name : #AlbEditorUndoShortcut,
	#superclass : #AlbEditorShortcut,
	#category : #'Album-Shortcuts'
}

{ #category : #accessing }
AlbEditorUndoShortcut >> description [
	^ 'Erases the last change done to the document, reverting it to an older state.'
]

{ #category : #initialization }
AlbEditorUndoShortcut >> initialize [
	super initialize.
	
	combination := BlKeyCombination primaryZ
]

{ #category : #accessing }
AlbEditorUndoShortcut >> name [
	^ 'Undo'
]

{ #category : #evaluation }
AlbEditorUndoShortcut >> performOnEditor: aTextEditor element: aEditorElement dueTo: aShortcutEvent [
	aTextEditor undo
]
