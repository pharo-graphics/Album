Class {
	#name : #AlbTextEditorNavigatorAddAtScreenPositionOperation,
	#superclass : #AlbTextEditorNavigatorOperation,
	#instVars : [
		'screenPosition'
	],
	#category : #'Album-Model-Operators'
}

{ #category : #matching }
AlbTextEditorNavigatorAddAtScreenPositionOperation >> performOn: aNavigator [
	| aGlobalTextIndex |

	aGlobalTextIndex := aNavigator
		findTextIndexAtScreenPosition: self screenPosition
		ifAbsent: [ ^ self ].
	
	self cursor position: aGlobalTextIndex.
	aNavigator privateRegisterForAdd: self cursor
]

{ #category : #accessing }
AlbTextEditorNavigatorAddAtScreenPositionOperation >> screenPosition [
	^ screenPosition
]

{ #category : #accessing }
AlbTextEditorNavigatorAddAtScreenPositionOperation >> screenPosition: anObject [
	screenPosition := anObject
]
