Class {
	#name : #AlbTextEditorNavigatorOperation,
	#superclass : #Object,
	#instVars : [
		'cursor'
	],
	#category : 'Album-Model-Operators'
}

{ #category : #'instance creation' }
AlbTextEditorNavigatorOperation class >> cursor: aCursor [
	^ self new cursor: aCursor
]

{ #category : #accessing }
AlbTextEditorNavigatorOperation >> cursor [
	^ cursor
]

{ #category : #accessing }
AlbTextEditorNavigatorOperation >> cursor: anObject [
	cursor := anObject
]

{ #category : #matching }
AlbTextEditorNavigatorOperation >> performOn: aNavigator [
	self subclassResponsibility
]
