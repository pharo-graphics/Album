Class {
	#name : #AlbTextEditorSelectedEvent,
	#superclass : #AlbTextEditorEvent,
	#instVars : [
		'fromIndex',
		'toIndex'
	],
	#category : #'Album-Editor-Model - Events'
}

{ #category : #accessing }
AlbTextEditorSelectedEvent >> fromIndex [
	^ fromIndex
]

{ #category : #accessing }
AlbTextEditorSelectedEvent >> fromIndex: anObject [
	fromIndex := anObject
]

{ #category : #accessing }
AlbTextEditorSelectedEvent >> toIndex [
	^ toIndex
]

{ #category : #accessing }
AlbTextEditorSelectedEvent >> toIndex: anObject [
	toIndex := anObject
]
