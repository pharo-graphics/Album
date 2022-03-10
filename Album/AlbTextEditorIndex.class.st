Class {
	#name : #AlbTextEditorIndex,
	#superclass : #Object,
	#instVars : [
		'index'
	],
	#category : #'Album-Model'
}

{ #category : #'instance creation' }
AlbTextEditorIndex class >> index: aNumber [
	^ self new index: aNumber
]

{ #category : #converting }
AlbTextEditorIndex >> asCursorIndex: aText [
	^ self subclassResponsibility
]

{ #category : #accessing }
AlbTextEditorIndex >> index [
	<return: #Number>

	^ index
]

{ #category : #accessing }
AlbTextEditorIndex >> index: aNumber [
	index := aNumber
]
