Class {
	#name : #AlbTextEditorExplicitScreenToCursorTransformation,
	#superclass : #AlbTextEditorScreenToCursorTransformation,
	#instVars : [
		'screenPosition'
	],
	#category : 'Album-Model-Cursor'
}

{ #category : #dispatching }
AlbTextEditorExplicitScreenToCursorTransformation >> evaluateOn: anObject [
	anObject explicitScreenToCursor: self
]

{ #category : #dispatching }
AlbTextEditorExplicitScreenToCursorTransformation >> evaluateOn: anObject for: anEvent [
	anObject explicitScreenToCursor: self for: anEvent
]

{ #category : #accessing }
AlbTextEditorExplicitScreenToCursorTransformation >> screenPosition [
	^ screenPosition
]

{ #category : #accessing }
AlbTextEditorExplicitScreenToCursorTransformation >> screenPosition: anObject [
	screenPosition := anObject
]
