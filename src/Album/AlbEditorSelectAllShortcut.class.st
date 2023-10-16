Class {
	#name : 'AlbEditorSelectAllShortcut',
	#superclass : 'AlbEditorShortcut',
	#category : 'Album-Shortcuts',
	#package : 'Album',
	#tag : 'Shortcuts'
}

{ #category : 'accessing' }
AlbEditorSelectAllShortcut >> description [
	^ 'Selects all text'
]

{ #category : 'initialization' }
AlbEditorSelectAllShortcut >> initialize [
	super initialize.
	
	combination := BlKeyCombination primaryA
]

{ #category : 'accessing' }
AlbEditorSelectAllShortcut >> name [
	^ 'Select all'
]

{ #category : 'evaluation' }
AlbEditorSelectAllShortcut >> performOnEditor: aTextEditor element: aEditorElement dueTo: aShortcutEvent [

	aTextEditor selecter
		all;
		select
]
