Class {
	#name : #AlbEditorSaveShortcut,
	#superclass : #AlbEditorShortcut,
	#category : #'Album-Shortcuts'
}

{ #category : #accessing }
AlbEditorSaveShortcut >> description [
	^ 'Apply changes and save the source code (compile).'
]

{ #category : #initialization }
AlbEditorSaveShortcut >> initialize [
	super initialize.
	
	combination := BlKeyCombination primaryS
]

{ #category : #accessing }
AlbEditorSaveShortcut >> name [
	^ 'Save'
]

{ #category : #evaluation }
AlbEditorSaveShortcut >> performOnEditor: aTextEditor element: anEditorElement dueTo: aShortcutEvent [

	aTextEditor saveTextRequest
]
