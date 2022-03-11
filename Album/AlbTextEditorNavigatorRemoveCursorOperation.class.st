Class {
	#name : #AlbTextEditorNavigatorRemoveCursorOperation,
	#superclass : #AlbTextEditorNavigatorOperation,
	#category : #'Album-Model-Operators'
}

{ #category : #matching }
AlbTextEditorNavigatorRemoveCursorOperation >> performOn: aNavigator [
	aNavigator privateRegisterForRemove: self cursor
]
