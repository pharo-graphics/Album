Class {
	#name : #AlbTextEditorReadonlyWithoutSelectionMode,
	#superclass : #AlbTextEditorBasicMode,
	#category : #'Album-Editor-Model'
}

{ #category : #'api - hooks' }
AlbTextEditorReadonlyWithoutSelectionMode >> installOnEditor: aTextEditor [
	super installOnEditor: aTextEditor.

	aTextEditor segmentBuilder beReadOnly
]

{ #category : #testing }
AlbTextEditorReadonlyWithoutSelectionMode >> isReadOnly [
	^ true
]
