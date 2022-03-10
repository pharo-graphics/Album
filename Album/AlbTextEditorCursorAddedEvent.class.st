Class {
	#name : #AlbTextEditorCursorAddedEvent,
	#superclass : #AlbTextEditorEvent,
	#instVars : [
		'cursor'
	],
	#category : #'Album-Editor-Model - Events'
}

{ #category : #'instance creation' }
AlbTextEditorCursorAddedEvent class >> cursor: aCursor [
	^ self new cursor: aCursor
]

{ #category : #accessing }
AlbTextEditorCursorAddedEvent >> cursor [
	<return: #BrTextEditorSingleCursor>

	^ cursor
]

{ #category : #accessing }
AlbTextEditorCursorAddedEvent >> cursor: aBrTextEditorSingleCursor [
	cursor := aBrTextEditorSingleCursor
]
