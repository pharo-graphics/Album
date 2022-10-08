Class {
	#name : #AlbTextEditorReadonlyWithSelectionMode,
	#superclass : #AlbTextEditorMode,
	#category : #'Album-Brick-NU-Album-Model'
}

{ #category : #initialization }
AlbTextEditorReadonlyWithSelectionMode >> initialize [

	super initialize.
	readonly := true
]
