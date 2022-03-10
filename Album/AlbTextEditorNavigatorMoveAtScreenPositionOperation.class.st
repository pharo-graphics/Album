Class {
	#name : #AlbTextEditorNavigatorMoveAtScreenPositionOperation,
	#superclass : #AlbTextEditorNavigatorOperation,
	#instVars : [
		'screenPosition'
	],
	#category : #'Album-Editor-Model - Operators'
}

{ #category : #matching }
AlbTextEditorNavigatorMoveAtScreenPositionOperation >> performOn: aNavigator [
	| aGlobalTextIndex |
	
	aGlobalTextIndex := aNavigator
		findTextIndexAtScreenPosition: self screenPosition
		ifAbsent: [ ^ self ].

	aNavigator
		privateRegisterForMove: self cursor
		by: (aGlobalTextIndex - self cursor position)
]

{ #category : #accessing }
AlbTextEditorNavigatorMoveAtScreenPositionOperation >> screenPosition [
	^ screenPosition
]

{ #category : #accessing }
AlbTextEditorNavigatorMoveAtScreenPositionOperation >> screenPosition: anObject [
	screenPosition := anObject
]
