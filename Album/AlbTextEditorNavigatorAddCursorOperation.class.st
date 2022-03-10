Class {
	#name : #AlbTextEditorNavigatorAddCursorOperation,
	#superclass : #AlbTextEditorNavigatorOperation,
	#category : #'Album-Editor-Model - Operators'
}

{ #category : #matching }
AlbTextEditorNavigatorAddCursorOperation >> performOn: aNavigator [
	aNavigator privateRegisterForAdd: self cursor
]
