Class {
	#name : #AlbTextEditorReadonlyWithSelectionMode,
	#superclass : #AlbTextEditorBasicMode,
	#category : #'Album-Model'
}

{ #category : #initialization }
AlbTextEditorReadonlyWithSelectionMode >> createEventHandlers [
	^ super createEventHandlers, {
		AlbTextEditorMouseDownHandler new.
		AlbTextEditorDoubleClickHandler new.
		AlbTextEditorSelectionHandler new.
		AlbTextEditorCursorIconHandler new.
	}
]

{ #category : #initialization }
AlbTextEditorReadonlyWithSelectionMode >> initialize [
	super initialize.
	
	shortcuts := {
		AlbEditorCopyShortcut new.
		AlbEditorSelectAllShortcut new.
		AlbEditorRemanentSelectionShortcut new.
		AlbEditorDeselectAllShortcut new.
	}
]

{ #category : #'api - hooks' }
AlbTextEditorReadonlyWithSelectionMode >> installOnEditor: aTextEditor [
	super installOnEditor: aTextEditor.

	aTextEditor wordStencil: AlbTextWordPieceStencilBuilder readOnly 
]

{ #category : #testing }
AlbTextEditorReadonlyWithSelectionMode >> isReadOnly [
	^ true
]
