Class {
	#name : #AlbEditorReadonlyWithSelectionMode,
	#superclass : #AlbEditorEditabilityMode,
	#category : #'Album-Model'
}

{ #category : #testing }
AlbEditorReadonlyWithSelectionMode >> allowSelection [

	^ true
]

{ #category : #testing }
AlbEditorReadonlyWithSelectionMode >> isEditable [

	^ false
]

{ #category : #'shortcut management' }
AlbEditorReadonlyWithSelectionMode >> shortcuts [

	^ { 
		  AlbEditorCopyShortcut new.
		  AlbEditorSelectAllShortcut new.
		  AlbEditorRemanentSelectionShortcut new.
		  AlbEditorDeselectAllShortcut new }
]
