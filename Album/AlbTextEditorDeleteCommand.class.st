Class {
	#name : #AlbTextEditorDeleteCommand,
	#superclass : #AlbTextEditorCommand,
	#instVars : [
		'fromIndex',
		'toIndex'
	],
	#category : #'Album-Editor-Commands'
}

{ #category : #executing }
AlbTextEditorDeleteCommand >> executeOn: aTextEditor [
	aTextEditor text
		delete: ((self fromIndex + 1) min: self toIndex)
		to: self toIndex
]

{ #category : #accessing }
AlbTextEditorDeleteCommand >> fromIndex [
	^ fromIndex
]

{ #category : #accessing }
AlbTextEditorDeleteCommand >> fromIndex: aNumber [
	<return: #Number>

	fromIndex := aNumber
]

{ #category : #accessing }
AlbTextEditorDeleteCommand >> toIndex [
	<return: #Number>

	^ toIndex
]

{ #category : #accessing }
AlbTextEditorDeleteCommand >> toIndex: aNumber [
	toIndex := aNumber
]
