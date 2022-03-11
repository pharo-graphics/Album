Class {
	#name : #AlbTextEditorCursorElementRemovedEvent,
	#superclass : #BlEvent,
	#instVars : [
		'cursorElement'
	],
	#category : #'Album-UI-Events'
}

{ #category : #accessing }
AlbTextEditorCursorElementRemovedEvent >> cursorElement [
	^ cursorElement
]

{ #category : #accessing }
AlbTextEditorCursorElementRemovedEvent >> cursorElement: anObject [
	cursorElement := anObject
]
