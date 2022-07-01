Class {
	#name : #AlbTextEditorNavigatorRemoveCursorOperation,
	#superclass : #AlbTextEditorNavigatorOperation,
	#category : #'Album-Brick-NU-Model-Operators'
}

{ #category : #matching }
AlbTextEditorNavigatorRemoveCursorOperation >> performOn: aNavigator [
	aNavigator privateRegisterForRemove: self cursor
]
