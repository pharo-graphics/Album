Class {
	#name : #AlbTextEditorInteractionAddedEvent,
	#superclass : #AlbTextEditorEvent,
	#instVars : [
		'interaction'
	],
	#category : #'Album-Model-Events'
}

{ #category : #accessing }
AlbTextEditorInteractionAddedEvent >> interaction [
	^ interaction
]

{ #category : #accessing }
AlbTextEditorInteractionAddedEvent >> interaction: anObject [
	interaction := anObject
]
