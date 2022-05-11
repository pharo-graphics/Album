Class {
	#name : #AlbTextEditorEvent,
	#superclass : #BlEvent,
	#instVars : [
		'editor'
	],
	#category : #'Album-Model-Events'
}

{ #category : #accessing }
AlbTextEditorEvent >> editor [
	<return: #AlbTextEditor>

	^ editor
]

{ #category : #accessing }
AlbTextEditorEvent >> editor: aTextEditor [
	editor := aTextEditor
]
