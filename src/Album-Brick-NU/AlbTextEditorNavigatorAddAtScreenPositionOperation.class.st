Class {
	#name : #AlbTextEditorNavigatorAddAtScreenPositionOperation,
	#superclass : #AlbTextEditorNavigatorOperation,
	#instVars : [
		'screenPosition'
	],
	#category : #'Album-Brick-NU-Model-Operators'
}

{ #category : #matching }
AlbTextEditorNavigatorAddAtScreenPositionOperation >> performOn: aNavigator [
	| aGlobalTextIndex |

	aGlobalTextIndex := aNavigator
		findTextIndexAtScreenPosition: self screenPosition
		ifAbsent: [ ^ self ].
	
	aNavigator privateRegisterForMove: self cursor to: aGlobalTextIndex
]

{ #category : #accessing }
AlbTextEditorNavigatorAddAtScreenPositionOperation >> screenPosition [
	^ screenPosition
]

{ #category : #accessing }
AlbTextEditorNavigatorAddAtScreenPositionOperation >> screenPosition: anObject [
	screenPosition := anObject
]
