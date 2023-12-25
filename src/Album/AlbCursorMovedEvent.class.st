Class {
	#name : #AlbCursorMovedEvent,
	#superclass : #BlEvent,
	#instVars : [
		'cursor',
		'oldIndex',
		'newIndex',
		'dueTo'
	],
	#category : 'Album-Model-Events'
}

{ #category : #'instance creation' }
AlbCursorMovedEvent class >> cursor: aCursor from: anOldIndex to: aNewIndex [
	<return: #AlbCursorMovedEvent>

	^ self new
		cursor: aCursor;
		oldIndex: anOldIndex;
		newIndex: aNewIndex
]

{ #category : #'instance creation' }
AlbCursorMovedEvent class >> cursor: aCursor from: anOldIndex to: aNewIndex dueTo: aTextEditorOperator [
	<return: #AlbCursorMovedEvent>
	
	^ self new
		cursor: aCursor;
		oldIndex: anOldIndex;
		newIndex: aNewIndex;
		dueTo: aTextEditorOperator
]

{ #category : #accessing }
AlbCursorMovedEvent >> cursor [
	<return: #AlbTextEditorSingleCursor>

	^ cursor
]

{ #category : #accessing }
AlbCursorMovedEvent >> cursor: aTextEditorSingleCursor [
	cursor := aTextEditorSingleCursor
]

{ #category : #accessing }
AlbCursorMovedEvent >> dueTo [
	^ dueTo
]

{ #category : #accessing }
AlbCursorMovedEvent >> dueTo: aTextEditorOperator [
	dueTo := aTextEditorOperator
]

{ #category : #accessing }
AlbCursorMovedEvent >> newIndex [
	<return: #Number>

	^ newIndex
]

{ #category : #accessing }
AlbCursorMovedEvent >> newIndex: aNumber [
	newIndex := aNumber
]

{ #category : #accessing }
AlbCursorMovedEvent >> oldIndex [
	<return: #Number>

	^ oldIndex
]

{ #category : #accessing }
AlbCursorMovedEvent >> oldIndex: aNumber [
	oldIndex := aNumber
]
