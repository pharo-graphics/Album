Class {
	#name : #AlbTextEditorNavigatorAddCursorOperation,
	#superclass : #AlbTextEditorNavigatorOperation,
	#category : #'Album-Model-Operators'
}

{ #category : #matching }
AlbTextEditorNavigatorAddCursorOperation >> performOn: aNavigator [
	aNavigator privateRegisterForAdd: self cursor
]
