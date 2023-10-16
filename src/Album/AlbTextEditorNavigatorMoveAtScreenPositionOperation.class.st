Class {
	#name : 'AlbTextEditorNavigatorMoveAtScreenPositionOperation',
	#superclass : 'AlbTextEditorNavigatorOperation',
	#instVars : [
		'screenPosition'
	],
	#category : 'Album-Model-Operators',
	#package : 'Album',
	#tag : 'Model-Operators'
}

{ #category : 'matching' }
AlbTextEditorNavigatorMoveAtScreenPositionOperation >> performOn: aNavigator [
	| aGlobalTextIndex |
	
	aGlobalTextIndex := aNavigator
		findTextIndexAtScreenPosition: self screenPosition
		ifAbsent: [ ^ self ].

	aNavigator
		privateRegisterForMove: self cursor
		to: aGlobalTextIndex
]

{ #category : 'accessing' }
AlbTextEditorNavigatorMoveAtScreenPositionOperation >> screenPosition [
	^ screenPosition
]

{ #category : 'accessing' }
AlbTextEditorNavigatorMoveAtScreenPositionOperation >> screenPosition: anObject [
	screenPosition := anObject
]
