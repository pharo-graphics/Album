Class {
	#name : #AlbTextEditorNavigatorMoveLeftOperation,
	#superclass : #AlbTextEditorNavigatorOperation,
	#category : #'Album-Editor-Model - Operators'
}

{ #category : #matching }
AlbTextEditorNavigatorMoveLeftOperation >> performOn: aNavigator [
	aNavigator privateRegisterForMove: self cursor by: -1
]
