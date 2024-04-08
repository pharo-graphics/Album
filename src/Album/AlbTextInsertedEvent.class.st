Class {
	#name : #AlbTextInsertedEvent,
	#superclass : #BlEvent,
	#instVars : [
		'text',
		'index'
	],
	#category : #'Album-Model-Events'
}

{ #category : #'instance creation' }
AlbTextInsertedEvent class >> text: aBlText at: anIndex [
	<return: #AlbTextInsertedEvent>

	^ self new
		text: aBlText;
		index: anIndex
]

{ #category : #accessing }
AlbTextInsertedEvent >> index [
	^ index
]

{ #category : #accessing }
AlbTextInsertedEvent >> index: aNumber [
	index := aNumber
]

{ #category : #sending }
AlbTextInsertedEvent >> sendTo: anEventHandler [

	anEventHandler textInsertedEvent: self
]

{ #category : #accessing }
AlbTextInsertedEvent >> text [
	^ text
]

{ #category : #accessing }
AlbTextInsertedEvent >> text: aText [
	text := aText
]

{ #category : #accessing }
AlbTextInsertedEvent >> toIndex [

	^ self index + self text size
]
