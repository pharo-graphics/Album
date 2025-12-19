Class {
	#name : #AlbReadonlyWithSelectionMode,
	#superclass : #AlbEditabilityMode,
	#category : #'Album-UI'
}

{ #category : #initialization }
AlbReadonlyWithSelectionMode >> defaultBeneathLayerEventHandlers [

	^ {  }
]

{ #category : #initialization }
AlbReadonlyWithSelectionMode >> defaultEditorElementEventHandlers [

	^ { 
		  AlbTextEditorMouseHandler new.
		  AlbTextEditorDoubleClickHandler new.
		  AlbTextEditorFocusHandler new }
]

{ #category : #initialization }
AlbReadonlyWithSelectionMode >> defaultFrontLayerEventHandlers [

	^ { AlbTextEditorSelectionHandler new }
]

{ #category : #initialization }
AlbReadonlyWithSelectionMode >> defaultRemanentSubtextEventHandlers [

	^ {  }
]

{ #category : #'shortcut management' }
AlbReadonlyWithSelectionMode >> defaultShortcuts [

	^ { 
		  AlbEditorCopyShortcut new.
		  AlbEditorSelectAllShortcut new.
		  AlbEditorDeselectAllShortcut new }
]
