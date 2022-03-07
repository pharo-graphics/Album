Class {
	#name : #AlbTextEditorReadonlyWithSelectionMode,
	#superclass : #AlbTextEditorBasicMode,
	#category : #'Album-Editor-Model'
}

{ #category : #initialization }
AlbTextEditorReadonlyWithSelectionMode >> createEventHandlers [
	^ super createEventHandlers, {
		BrTextEditorMouseDownHandler uniqueInstance.
		BrTextEditorDoubleClickHandler uniqueInstance.
		BrTextEditorSelectionHandler new.
		BrTextEditorCursorIconHandler uniqueInstance.
	}
]

{ #category : #initialization }
AlbTextEditorReadonlyWithSelectionMode >> initialize [
	super initialize.
	
	shortcuts := {
		BrEditorCopyShortcut new.
		BrEditorSelectAllShortcut new.
		BrEditorDeselectAllShortcut new.
	}
]

{ #category : #'api - hooks' }
AlbTextEditorReadonlyWithSelectionMode >> installOnEditor: aTextEditor [
	super installOnEditor: aTextEditor.

	aTextEditor segmentBuilder beReadOnly
]

{ #category : #testing }
AlbTextEditorReadonlyWithSelectionMode >> isReadOnly [
	^ true
]
