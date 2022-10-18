Class {
	#name : #AlbReadonlyWithSelectionMode,
	#superclass : #AlbEditabilityMode,
	#category : #'Album-Model'
}

{ #category : #testing }
AlbReadonlyWithSelectionMode >> allowSelection [

	^ true
]

{ #category : #initialization }
AlbReadonlyWithSelectionMode >> defaultEditorElementEventHandlers [

	^ { 
		  AlbTextEditorMouseHandler new.
		  AlbTextEditorDoubleClickHandler new.
		  AlbTextEditorSelectionHandler new.
		  AlbTextEditorCursorIconHandler new.
		  AlbTextEditorFocusHandler new }
]

{ #category : #'shortcut management' }
AlbReadonlyWithSelectionMode >> defaultShortcuts [

	^ { 
		  AlbEditorCopyShortcut new.
		  AlbEditorSelectAllShortcut new.
		  AlbEditorRemanentSelectionShortcut new.
		  AlbEditorDeselectAllShortcut new }
]

{ #category : #testing }
AlbReadonlyWithSelectionMode >> isEditable [

	^ false
]
