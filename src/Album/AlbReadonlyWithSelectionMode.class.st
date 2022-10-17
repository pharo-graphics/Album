Class {
	#name : #AlbReadonlyWithSelectionMode,
	#superclass : #AlbEditabilityMode,
	#category : #'Album-Model'
}

{ #category : #testing }
AlbReadonlyWithSelectionMode >> allowSelection [

	^ true
]

{ #category : #testing }
AlbReadonlyWithSelectionMode >> isEditable [

	^ false
]

{ #category : #'shortcut management' }
AlbReadonlyWithSelectionMode >> shortcuts [

	^ { 
		  AlbEditorCopyShortcut new.
		  AlbEditorSelectAllShortcut new.
		  AlbEditorRemanentSelectionShortcut new.
		  AlbEditorDeselectAllShortcut new }
]
