Class {
	#name : #AlbTextEditorDeletedEvent,
	#superclass : #AlbTextEditorEvent,
	#instVars : [
		'fromIndex',
		'toIndex'
	],
	#category : #'Album-Editor-Model - Events'
}

{ #category : #'instance creation' }
AlbTextEditorDeletedEvent class >> from: aFromIndex to: aToIndex [
	<return: #AlbTextEditorDeletedEvent>

	^ self new
		fromIndex: aFromIndex;
		toIndex: aToIndex
]

{ #category : #accessing }
AlbTextEditorDeletedEvent >> fromIndex [
	^ fromIndex
]

{ #category : #accessing }
AlbTextEditorDeletedEvent >> fromIndex: anObject [
	fromIndex := anObject
]

{ #category : #accessing }
AlbTextEditorDeletedEvent >> toIndex [
	^ toIndex
]

{ #category : #accessing }
AlbTextEditorDeletedEvent >> toIndex: anObject [
	toIndex := anObject
]
