Class {
	#name : #AlbTextEditorCursorElementAddedEvent,
	#superclass : #BlEvent,
	#instVars : [
		'cursorElement'
	],
	#category : #'Album-UI-Events'
}

{ #category : #accessing }
AlbTextEditorCursorElementAddedEvent >> cursorElement [
	^ cursorElement
]

{ #category : #accessing }
AlbTextEditorCursorElementAddedEvent >> cursorElement: anObject [
	cursorElement := anObject
]
