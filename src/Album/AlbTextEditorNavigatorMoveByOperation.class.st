Class {
	#name : 'AlbTextEditorNavigatorMoveByOperation',
	#superclass : 'AlbTextEditorNavigatorOperation',
	#instVars : [
		'delta'
	],
	#category : 'Album-Model-Operators',
	#package : 'Album',
	#tag : 'Model-Operators'
}

{ #category : 'accessing' }
AlbTextEditorNavigatorMoveByOperation >> delta [
	^ delta
]

{ #category : 'accessing' }
AlbTextEditorNavigatorMoveByOperation >> delta: anObject [
	delta := anObject
]

{ #category : 'matching' }
AlbTextEditorNavigatorMoveByOperation >> performOn: aNavigator [
	aNavigator privateRegisterForMove: self cursor by: self delta
]
