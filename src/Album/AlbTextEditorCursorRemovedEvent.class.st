Class {
	#name : #AlbTextEditorCursorRemovedEvent,
	#superclass : #AlbTextEditorEvent,
	#instVars : [
		'cursor'
	],
	#category : #'Album-Model-Events'
}

{ #category : #'instance creation' }
AlbTextEditorCursorRemovedEvent class >> cursor: aCursor [
	^ self new cursor: aCursor
]

{ #category : #accessing }
AlbTextEditorCursorRemovedEvent >> cursor [
	<return: #AlbTextEditorSingleCursor>

	^ cursor
]

{ #category : #accessing }
AlbTextEditorCursorRemovedEvent >> cursor: aTextEditorSingleCursor [
	cursor := aTextEditorSingleCursor
]
