Class {
	#name : #AlbTextEditorCursorChangedEvent,
	#superclass : #AlbTextEditorEvent,
	#instVars : [
		'cursors'
	],
	#category : #'Album-Model-Events'
}

{ #category : #accessing }
AlbTextEditorCursorChangedEvent >> cursors [
	^ cursors
]

{ #category : #accessing }
AlbTextEditorCursorChangedEvent >> cursors: anObject [
	cursors := anObject
]
