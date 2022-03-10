Class {
	#name : #AlbTextEditorShowCursorRequest,
	#superclass : #AlbTextEditorRequest,
	#instVars : [
		'cursorPosition',
		'hasFocus'
	],
	#category : #'Album-UI-Requests'
}

{ #category : #accessing }
AlbTextEditorShowCursorRequest >> cursorPosition [
	<return: #Number>

	^ cursorPosition
]

{ #category : #accessing }
AlbTextEditorShowCursorRequest >> cursorPosition: aNumber [
	
	self
		assert: [ aNumber >= 0 ]
		description: [ 'Cursor position must not be negative' ].

	cursorPosition := aNumber
]

{ #category : #accessing }
AlbTextEditorShowCursorRequest >> hasFocus [
	^ hasFocus
]

{ #category : #accessing }
AlbTextEditorShowCursorRequest >> hasFocus: anObject [
	hasFocus := anObject
]
