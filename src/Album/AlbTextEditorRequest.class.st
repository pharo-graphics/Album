Class {
	#name : 'AlbTextEditorRequest',
	#superclass : 'BlEvent',
	#instVars : [
		'editorElement'
	],
	#category : 'Album-UI-Requests',
	#package : 'Album',
	#tag : 'UI-Requests'
}

{ #category : 'accessing' }
AlbTextEditorRequest >> editorElement [
	^ editorElement
]

{ #category : 'accessing' }
AlbTextEditorRequest >> editorElement: anObject [
	editorElement := anObject
]
