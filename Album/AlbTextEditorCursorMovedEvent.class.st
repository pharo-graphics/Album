Class {
	#name : #AlbTextEditorCursorMovedEvent,
	#superclass : #AlbTextEditorEvent,
	#instVars : [
		'cursor',
		'oldIndex',
		'newIndex',
		'dueTo'
	],
	#category : #'Album-Editor-Model - Events'
}

{ #category : #'instance creation' }
AlbTextEditorCursorMovedEvent class >> cursor: aCursor from: anOldIndex to: aNewIndex [
	<return: #AlbTextEditorCursorMovedEvent>

	^ self new
		cursor: aCursor;
		oldIndex: anOldIndex;
		newIndex: aNewIndex
]

{ #category : #'instance creation' }
AlbTextEditorCursorMovedEvent class >> cursor: aCursor from: anOldIndex to: aNewIndex dueTo: aTextEditorOperator [
	<return: #AlbTextEditorCursorMovedEvent>
	
	^ self new
		cursor: aCursor;
		oldIndex: anOldIndex;
		newIndex: aNewIndex;
		dueTo: aTextEditorOperator
]

{ #category : #accessing }
AlbTextEditorCursorMovedEvent >> cursor [
	<return: #BrTextEditorSingleCursor>

	^ cursor
]

{ #category : #accessing }
AlbTextEditorCursorMovedEvent >> cursor: aBrTextEditorSingleCursor [
	cursor := aBrTextEditorSingleCursor
]

{ #category : #accessing }
AlbTextEditorCursorMovedEvent >> dueTo [
	^ dueTo
]

{ #category : #accessing }
AlbTextEditorCursorMovedEvent >> dueTo: aTextEditorOperator [
	dueTo := aTextEditorOperator
]

{ #category : #accessing }
AlbTextEditorCursorMovedEvent >> newIndex [
	<return: #Number>

	^ newIndex
]

{ #category : #accessing }
AlbTextEditorCursorMovedEvent >> newIndex: aNumber [
	newIndex := aNumber
]

{ #category : #accessing }
AlbTextEditorCursorMovedEvent >> oldIndex [
	<return: #Number>

	^ oldIndex
]

{ #category : #accessing }
AlbTextEditorCursorMovedEvent >> oldIndex: aNumber [
	oldIndex := aNumber
]
