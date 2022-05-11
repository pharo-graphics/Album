Class {
	#name : #AlbTextEditorModifiedEvent,
	#superclass : #AlbTextEditorEvent,
	#instVars : [
		'text'
	],
	#category : #'Album-Model-Events'
}

{ #category : #accessing }
AlbTextEditorModifiedEvent >> text [
	^ text
]

{ #category : #accessing }
AlbTextEditorModifiedEvent >> text: anObject [
	text := anObject
]
