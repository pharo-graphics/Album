Class {
	#name : #AlbTextEditorShowCursorRequest,
	#superclass : #AlbTextEditorRequest,
	#instVars : [
		'cursorPosition',
		'hasFocus',
		'isPrimary'
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

{ #category : #accessing }
AlbTextEditorShowCursorRequest >> isPrimary [

	^ isPrimary ifNil: [ true ]
]

{ #category : #accessing }
AlbTextEditorShowCursorRequest >> isPrimary: aBoolean [

	isPrimary := aBoolean
]
