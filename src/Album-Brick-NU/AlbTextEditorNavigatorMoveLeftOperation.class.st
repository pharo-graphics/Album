Class {
	#name : #AlbTextEditorNavigatorMoveLeftOperation,
	#superclass : #AlbTextEditorNavigatorOperation,
	#category : #'Album-Brick-NU-Model-Operators'
}

{ #category : #matching }
AlbTextEditorNavigatorMoveLeftOperation >> performOn: aNavigator [
	aNavigator privateRegisterForMove: self cursor by: -1
]
