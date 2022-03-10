Class {
	#name : #AlbTextEditorInteractionRemovedEvent,
	#superclass : #AlbTextEditorEvent,
	#instVars : [
		'interaction'
	],
	#category : #'Album-Editor-Model - Events'
}

{ #category : #accessing }
AlbTextEditorInteractionRemovedEvent >> interaction [
	^ interaction
]

{ #category : #accessing }
AlbTextEditorInteractionRemovedEvent >> interaction: anObject [
	interaction := anObject
]
