Class {
	#name : #AlbTextEditorReadonlyWithoutSelectionMode,
	#superclass : #AlbTextEditorBasicMode,
	#category : #'Album-Model'
}

{ #category : #'api - hooks' }
AlbTextEditorReadonlyWithoutSelectionMode >> installOnEditor: aTextEditor [
	super installOnEditor: aTextEditor.

	aTextEditor wordStencil: AlbTextWordPieceStencilBuilder readOnly 
]

{ #category : #testing }
AlbTextEditorReadonlyWithoutSelectionMode >> isReadOnly [
	^ true
]
