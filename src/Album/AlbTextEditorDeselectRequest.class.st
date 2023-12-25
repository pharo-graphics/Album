Class {
	#name : #AlbTextEditorDeselectRequest,
	#superclass : #AlbTextEditorRequest,
	#instVars : [
		'fromIndex',
		'toIndex'
	],
	#category : 'Album-UI-Requests'
}

{ #category : #accessing }
AlbTextEditorDeselectRequest >> fromIndex [
	^ fromIndex
]

{ #category : #accessing }
AlbTextEditorDeselectRequest >> fromIndex: anObject [
	fromIndex := anObject
]

{ #category : #accessing }
AlbTextEditorDeselectRequest >> toIndex [
	^ toIndex
]

{ #category : #accessing }
AlbTextEditorDeselectRequest >> toIndex: anObject [
	toIndex := anObject
]
