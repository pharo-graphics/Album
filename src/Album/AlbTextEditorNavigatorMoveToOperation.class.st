Class {
	#name : 'AlbTextEditorNavigatorMoveToOperation',
	#superclass : 'AlbTextEditorNavigatorOperation',
	#instVars : [
		'position'
	],
	#category : 'Album-Model-Operators',
	#package : 'Album',
	#tag : 'Model-Operators'
}

{ #category : 'matching' }
AlbTextEditorNavigatorMoveToOperation >> performOn: aNavigator [
	aNavigator privateRegisterForMove: self cursor to: self position 
]

{ #category : 'accessing' }
AlbTextEditorNavigatorMoveToOperation >> position [
	^ position
]

{ #category : 'accessing' }
AlbTextEditorNavigatorMoveToOperation >> position: anObject [
	position := anObject
]
