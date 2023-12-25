Class {
	#name : #AlbTextEditorRelativeScreenToCursorTransformation,
	#superclass : #AlbTextEditorScreenToCursorTransformation,
	#instVars : [
		'cursor',
		'direction'
	],
	#category : 'Album-Model-Cursor'
}

{ #category : #accessing }
AlbTextEditorRelativeScreenToCursorTransformation >> beDown [
	self direction: #down
]

{ #category : #accessing }
AlbTextEditorRelativeScreenToCursorTransformation >> beUp [
	self direction: #up
]

{ #category : #accessing }
AlbTextEditorRelativeScreenToCursorTransformation >> cursor [
	^ cursor
]

{ #category : #accessing }
AlbTextEditorRelativeScreenToCursorTransformation >> cursor: anObject [
	cursor := anObject
]

{ #category : #accessing }
AlbTextEditorRelativeScreenToCursorTransformation >> direction [
	^ direction
]

{ #category : #accessing }
AlbTextEditorRelativeScreenToCursorTransformation >> direction: aSymbol [
	direction := aSymbol
]

{ #category : #dispatching }
AlbTextEditorRelativeScreenToCursorTransformation >> evaluateOn: anObject [
	anObject relativeScreenToCursor: self
]

{ #category : #dispatching }
AlbTextEditorRelativeScreenToCursorTransformation >> evaluateOn: anObject for: anEvent [
	anObject relativeScreenToCursor: self for: anEvent
]

{ #category : #testing }
AlbTextEditorRelativeScreenToCursorTransformation >> isDown [
	^ self direction = #down
]

{ #category : #testing }
AlbTextEditorRelativeScreenToCursorTransformation >> isUp [
	^ self direction = #up
]
