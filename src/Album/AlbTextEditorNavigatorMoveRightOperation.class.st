Class {
	#name : #AlbTextEditorNavigatorMoveRightOperation,
	#superclass : #AlbTextEditorNavigatorOperation,
	#category : #'Album-Model-Operators'
}

{ #category : #matching }
AlbTextEditorNavigatorMoveRightOperation >> performOn: aNavigator [
	aNavigator privateRegisterForMove: self cursor by: 1
]
