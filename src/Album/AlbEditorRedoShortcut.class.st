Class {
	#name : 'AlbEditorRedoShortcut',
	#superclass : 'AlbEditorShortcut',
	#category : 'Album-Shortcuts',
	#package : 'Album',
	#tag : 'Shortcuts'
}

{ #category : 'accessing' }
AlbEditorRedoShortcut >> description [
	^ 'Reverses the undo or advances the document to a more recent state.'
]

{ #category : 'initialization' }
AlbEditorRedoShortcut >> initialize [
	super initialize.
	
	combination := BlKeyCombination primaryShiftZ
]

{ #category : 'accessing' }
AlbEditorRedoShortcut >> name [
	^ 'Redo'
]

{ #category : 'evaluation' }
AlbEditorRedoShortcut >> performOnEditor: aTextEditor element: aEditorElement dueTo: aShortcutEvent [

	aTextEditor redo
]
