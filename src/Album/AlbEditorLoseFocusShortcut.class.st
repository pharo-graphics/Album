Class {
	#name : 'AlbEditorLoseFocusShortcut',
	#superclass : 'AlbEditorShortcut',
	#category : 'Album-Shortcuts',
	#package : 'Album',
	#tag : 'Shortcuts'
}

{ #category : 'accessing' }
AlbEditorLoseFocusShortcut >> description [
	^ 'Loses focus.'
]

{ #category : 'initialization' }
AlbEditorLoseFocusShortcut >> initialize [
	super initialize.
	
	combination := BlKeyCombination escape
]

{ #category : 'accessing' }
AlbEditorLoseFocusShortcut >> name [
	^ 'Lose focus'
]

{ #category : 'evaluation' }
AlbEditorLoseFocusShortcut >> performOnEditor: aTextEditor element: aEditorElement dueTo: aShortcutEvent [
	aEditorElement loseFocus
]
