Class {
	#name : #AlbTextEditorCursorRemovedEvent,
	#superclass : #AlbTextEditorEvent,
	#instVars : [
		'cursor'
	],
	#category : #'Album-Editor-Model - Events'
}

{ #category : #'instance creation' }
AlbTextEditorCursorRemovedEvent class >> cursor: aCursor [
	^ self new cursor: aCursor
]

{ #category : #accessing }
AlbTextEditorCursorRemovedEvent >> cursor [
	<return: #BrTextEditorSingleCursor>

	^ cursor
]

{ #category : #accessing }
AlbTextEditorCursorRemovedEvent >> cursor: aBrTextEditorSingleCursor [
	cursor := aBrTextEditorSingleCursor
]
