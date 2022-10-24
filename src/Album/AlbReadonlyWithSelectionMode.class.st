Class {
	#name : #AlbReadonlyWithSelectionMode,
	#superclass : #AlbEditabilityMode,
	#category : #'Album-UI'
}

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
