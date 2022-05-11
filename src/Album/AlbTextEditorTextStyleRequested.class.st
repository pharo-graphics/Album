Class {
	#name : #AlbTextEditorTextStyleRequested,
	#superclass : #AlbTextEditorEvent,
	#instVars : [
		'afterAction'
	],
	#category : #'Album-Model-Events'
}

{ #category : #accessing }
AlbTextEditorTextStyleRequested >> afterAction [
	^ afterAction
]

{ #category : #accessing }
AlbTextEditorTextStyleRequested >> afterAction: anObject [
	afterAction := anObject
]
