Class {
	#name : #AlbTextEditorNavigatorMoveToOperation,
	#superclass : #AlbTextEditorNavigatorOperation,
	#instVars : [
		'position'
	],
	#category : #'Album-Editor-Model - Operators'
}

{ #category : #matching }
AlbTextEditorNavigatorMoveToOperation >> performOn: aNavigator [
	aNavigator privateRegisterForMove: self cursor by: (self position - self cursor position)
]

{ #category : #accessing }
AlbTextEditorNavigatorMoveToOperation >> position [
	^ position
]

{ #category : #accessing }
AlbTextEditorNavigatorMoveToOperation >> position: anObject [
	position := anObject
]
