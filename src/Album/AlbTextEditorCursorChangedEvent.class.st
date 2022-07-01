Class {
	#name : #AlbTextEditorCursorChangedEvent,
	#superclass : #AlbTextEditorEvent,
	#instVars : [
		'cursors',
		'cursor'
	],
	#category : #'Album-Model-Events'
}

{ #category : #accessing }
AlbTextEditorCursorChangedEvent >> cursor [
	^ cursor
]

{ #category : #accessing }
AlbTextEditorCursorChangedEvent >> cursor: anObject [
	cursor := anObject
]
