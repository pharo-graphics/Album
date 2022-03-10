Class {
	#name : #AlbTextEditorSelectionChangedEvent,
	#superclass : #AlbTextEditorEvent,
	#instVars : [
		'selection'
	],
	#category : #'Album-Editor-Model - Events'
}

{ #category : #accessing }
AlbTextEditorSelectionChangedEvent >> selection [
	^ selection
]

{ #category : #accessing }
AlbTextEditorSelectionChangedEvent >> selection: anObject [
	selection := anObject
]
