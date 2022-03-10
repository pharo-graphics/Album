Class {
	#name : #AlbTextEditorCursorReachedBoundaryEvent,
	#superclass : #AlbTextEditorEvent,
	#instVars : [
		'cursor',
		'boundary'
	],
	#classVars : [
		'Bottom',
		'Top'
	],
	#category : #'Album-Model-Events'
}

{ #category : #'class initialization' }
AlbTextEditorCursorReachedBoundaryEvent class >> initialize [
	Top := #top.
	Bottom := #bottom
]

{ #category : #location }
AlbTextEditorCursorReachedBoundaryEvent >> beBottom [
	boundary := Bottom
]

{ #category : #location }
AlbTextEditorCursorReachedBoundaryEvent >> beTop [
	boundary := Top
]

{ #category : #accessing }
AlbTextEditorCursorReachedBoundaryEvent >> cursor [
	^ cursor
]

{ #category : #accessing }
AlbTextEditorCursorReachedBoundaryEvent >> cursor: anObject [
	cursor := anObject
]

{ #category : #testing }
AlbTextEditorCursorReachedBoundaryEvent >> isBottom [
	^ boundary = Bottom
]

{ #category : #testing }
AlbTextEditorCursorReachedBoundaryEvent >> isTop [
	^ boundary = Top
]

{ #category : #printing }
AlbTextEditorCursorReachedBoundaryEvent >> printOn: aStream [

	aStream
		<< 'ReachedBoundaryEvent(';
		print: boundary;
		<< ', ';
		print: cursor;
		<< ')'
]
