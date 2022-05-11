Class {
	#name : #AlbTextEditorTextReplacedEvent,
	#superclass : #AlbTextEditorEvent,
	#instVars : [
		'text'
	],
	#category : #'Album-Model-Events'
}

{ #category : #accessing }
AlbTextEditorTextReplacedEvent >> text [
	^ text
]

{ #category : #accessing }
AlbTextEditorTextReplacedEvent >> text: anObject [
	text := anObject
]
