Class {
	#name : #AlbTextDeletedEvent,
	#superclass : #BlEvent,
	#instVars : [
		'fromIndex',
		'toIndex'
	],
	#category : 'Album-Model-Events'
}

{ #category : #'instance creation' }
AlbTextDeletedEvent class >> from: aFromIndex to: aToIndex [
	<return: #AlbTextDeletedEvent>

	^ self new
		fromIndex: aFromIndex;
		toIndex: aToIndex
]

{ #category : #accessing }
AlbTextDeletedEvent >> fromIndex [
	^ fromIndex
]

{ #category : #accessing }
AlbTextDeletedEvent >> fromIndex: anObject [
	fromIndex := anObject
]

{ #category : #accessing }
AlbTextDeletedEvent >> toIndex [
	^ toIndex
]

{ #category : #accessing }
AlbTextDeletedEvent >> toIndex: anObject [
	toIndex := anObject
]
