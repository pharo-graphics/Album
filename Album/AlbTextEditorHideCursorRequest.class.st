Class {
	#name : #AlbTextEditorHideCursorRequest,
	#superclass : #AlbTextEditorRequest,
	#instVars : [
		'cursorPosition'
	],
	#category : #'Album-UI-Requests'
}

{ #category : #accessing }
AlbTextEditorHideCursorRequest >> cursorPosition [
	<return: #Number>

	^ cursorPosition
]

{ #category : #accessing }
AlbTextEditorHideCursorRequest >> cursorPosition: aNumber [
	
	self
		assert: [ aNumber >= 0 ]
		description: [ 'Cursor position must not be negative' ].

	cursorPosition := aNumber
]
