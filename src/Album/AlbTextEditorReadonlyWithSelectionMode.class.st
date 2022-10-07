Class {
	#name : #AlbTextEditorReadonlyWithSelectionMode,
	#superclass : #AlbTextEditorMode,
	#category : #'Album-Model'
}

{ #category : #initialization }
AlbTextEditorReadonlyWithSelectionMode >> initialize [

	super initialize.
	readonly := true
]
