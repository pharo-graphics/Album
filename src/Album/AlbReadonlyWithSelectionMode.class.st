Class {
	#name : #AlbReadonlyWithSelectionMode,
	#superclass : #AlbEditabilityMode,
	#category : 'Album-UI'
}

{ #category : #initialization }
AlbReadonlyWithSelectionMode >> defaultEditorElementEventHandlers [

	^ { 
		  AlbTextEditorMouseHandler new.
		  AlbTextEditorDoubleClickHandler new.
		  AlbTextEditorFocusHandler new }
]

{ #category : #initialization }
AlbReadonlyWithSelectionMode >> defaultFrontLayerEventHandlers [

	^ {  AlbTextEditorCursorIconHandler new .
		  AlbTextEditorSelectionHandler new }
]

{ #category : #'shortcut management' }
AlbReadonlyWithSelectionMode >> defaultShortcuts [

	^ { 
		  AlbEditorCopyShortcut new.
		  AlbEditorSelectAllShortcut new.
		  AlbEditorDeselectAllShortcut new }
]
