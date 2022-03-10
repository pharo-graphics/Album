Class {
	#name : #AlbTextEditorTextReplacedEvent,
	#superclass : #AlbTextEditorEvent,
	#instVars : [
		'text'
	],
	#category : #'Album-Editor-Model - Events'
}

{ #category : #accessing }
AlbTextEditorTextReplacedEvent >> text [
	^ text
]

{ #category : #accessing }
AlbTextEditorTextReplacedEvent >> text: anObject [
	text := anObject
]
