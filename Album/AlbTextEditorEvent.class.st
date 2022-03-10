Class {
	#name : #AlbTextEditorEvent,
	#superclass : #BlEvent,
	#instVars : [
		'editor'
	],
	#category : #'Album-Editor-Model - Events'
}

{ #category : #accessing }
AlbTextEditorEvent >> editor [
	<return: #BrTextEditor>

	^ editor
]

{ #category : #accessing }
AlbTextEditorEvent >> editor: aBrTextEditor [
	editor := aBrTextEditor
]
