Class {
	#name : 'AlbReadonlyWithSelectionMode',
	#superclass : 'AlbEditabilityMode',
	#category : 'Album-UI',
	#package : 'Album',
	#tag : 'UI'
}

{ #category : 'initialization' }
AlbReadonlyWithSelectionMode >> defaultEditorElementEventHandlers [
self flag: 'AlbTextEditorFocusHandler should e added if album is used on itself (not by ToAlbum)'. 

	^ { 
		  AlbTextEditorMouseHandler new.
		  AlbTextEditorDoubleClickHandler new.
		  "AlbTextEditorFocusHandler new" }
]

{ #category : 'initialization' }
AlbReadonlyWithSelectionMode >> defaultFrontLayerEventHandlers [

	^ {  AlbTextEditorCursorIconHandler new .
		  AlbTextEditorSelectionHandler new }
]

{ #category : 'shortcut management' }
AlbReadonlyWithSelectionMode >> defaultShortcuts [

	^ { 
		  AlbEditorCopyShortcut new.
		  AlbEditorSelectAllShortcut new.
		  AlbEditorDeselectAllShortcut new }
]
