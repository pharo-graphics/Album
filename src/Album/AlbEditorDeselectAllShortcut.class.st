Class {
	#name : #AlbEditorDeselectAllShortcut,
	#superclass : #AlbEditorShortcut,
	#category : 'Album-Shortcuts'
}

{ #category : #accessing }
AlbEditorDeselectAllShortcut >> description [
	^ 'Deselects any currently selected text.'
]

{ #category : #initialization }
AlbEditorDeselectAllShortcut >> initialize [
	super initialize.
	
	combination := BlKeyCombination escape
]

{ #category : #accessing }
AlbEditorDeselectAllShortcut >> name [
	^ 'Deselect'
]

{ #category : #evaluation }
AlbEditorDeselectAllShortcut >> performOnEditor: aTextEditor element: aEditorElement dueTo: aShortcutEvent [

	aTextEditor selectNone
]
