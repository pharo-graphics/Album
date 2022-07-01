Class {
	#name : #AlbTextEditorNavigatorAddCursorOperation,
	#superclass : #AlbTextEditorNavigatorOperation,
	#category : #'Album-Brick-NU-Model-Operators'
}

{ #category : #matching }
AlbTextEditorNavigatorAddCursorOperation >> performOn: aNavigator [
	aNavigator privateRegisterForAdd: self cursor
]
