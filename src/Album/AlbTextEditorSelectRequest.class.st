Class {
	#name : 'AlbTextEditorSelectRequest',
	#superclass : 'AlbTextEditorRequest',
	#instVars : [
		'fromIndex',
		'toIndex'
	],
	#category : 'Album-UI-Requests',
	#package : 'Album',
	#tag : 'UI-Requests'
}

{ #category : 'accessing' }
AlbTextEditorSelectRequest >> fromIndex [
	^ fromIndex
]

{ #category : 'accessing' }
AlbTextEditorSelectRequest >> fromIndex: anObject [
	fromIndex := anObject
]

{ #category : 'accessing' }
AlbTextEditorSelectRequest >> toIndex [
	^ toIndex
]

{ #category : 'accessing' }
AlbTextEditorSelectRequest >> toIndex: anObject [
	toIndex := anObject
]
