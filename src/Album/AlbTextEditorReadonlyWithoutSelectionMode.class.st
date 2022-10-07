Class {
	#name : #AlbTextEditorReadonlyWithoutSelectionMode,
	#superclass : #AlbTextEditorMode,
	#category : #'Album-Model'
}

{ #category : #initialization }
AlbTextEditorReadonlyWithoutSelectionMode >> initialize [
	super initialize.
	readonly := true.

]

{ #category : #'api - hooks' }
AlbTextEditorReadonlyWithoutSelectionMode >> installOnEditor: aTextEditor [

	super installOnEditor: aTextEditor.
	aTextEditor deselecter
		all;
		deselect
]
