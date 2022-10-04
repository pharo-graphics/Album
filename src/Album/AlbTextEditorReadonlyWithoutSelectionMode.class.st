Class {
	#name : #AlbTextEditorReadonlyWithoutSelectionMode,
	#superclass : #AlbTextEditorBasicMode,
	#category : #'Album-Model'
}

{ #category : #'api - hooks' }
AlbTextEditorReadonlyWithoutSelectionMode >> installOnEditor: aTextEditor [

	super installOnEditor: aTextEditor.
	aTextEditor deselecter
		all;
		deselect.
	aTextEditor wordStencil: AlbTextWordPieceStencil readOnly
]

{ #category : #testing }
AlbTextEditorReadonlyWithoutSelectionMode >> isReadOnly [
	^ true
]
