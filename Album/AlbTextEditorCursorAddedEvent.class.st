Class {
	#name : #AlbTextEditorCursorAddedEvent,
	#superclass : #AlbTextEditorEvent,
	#instVars : [
		'cursor'
	],
	#category : #'Album-Model-Events'
}

{ #category : #'instance creation' }
AlbTextEditorCursorAddedEvent class >> cursor: aCursor [
	^ self new cursor: aCursor
]

{ #category : #accessing }
AlbTextEditorCursorAddedEvent >> cursor [
	<return: #AlbTextEditorSingleCursor>

	^ cursor
]

{ #category : #accessing }
AlbTextEditorCursorAddedEvent >> cursor: aTextEditorSingleCursor [
	cursor := aTextEditorSingleCursor
]
