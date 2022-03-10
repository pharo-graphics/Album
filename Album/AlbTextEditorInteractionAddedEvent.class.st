Class {
	#name : #AlbTextEditorInteractionAddedEvent,
	#superclass : #AlbTextEditorEvent,
	#instVars : [
		'interaction'
	],
	#category : #'Album-Editor-Model - Events'
}

{ #category : #accessing }
AlbTextEditorInteractionAddedEvent >> interaction [
	^ interaction
]

{ #category : #accessing }
AlbTextEditorInteractionAddedEvent >> interaction: anObject [
	interaction := anObject
]
