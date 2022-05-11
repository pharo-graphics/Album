Class {
	#name : #AlbEditorCutShortcut,
	#superclass : #AlbEditorShortcut,
	#category : #'Album-Shortcuts'
}

{ #category : #accessing }
AlbEditorCutShortcut >> description [
	^ 'Cut selected text and save it to the clipboard ready to paste elsewhere.'
]

{ #category : #initialization }
AlbEditorCutShortcut >> initialize [
	super initialize.
	
	combination := BlKeyCombination primaryX
]

{ #category : #initialization }
AlbEditorCutShortcut >> name [
	^ 'Cut'
]

{ #category : #evaluation }
AlbEditorCutShortcut >> performOnEditor: aTextEditor element: aEditorElement dueTo: aShortcutEvent [
	aTextEditor cutSelected
]
