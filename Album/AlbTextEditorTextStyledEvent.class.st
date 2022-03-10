Class {
	#name : #AlbTextEditorTextStyledEvent,
	#superclass : #AlbTextEditorEvent,
	#instVars : [
		'styledText'
	],
	#category : #'Album-Model-Events'
}

{ #category : #accessing }
AlbTextEditorTextStyledEvent >> styledText [
	^ styledText
]

{ #category : #accessing }
AlbTextEditorTextStyledEvent >> styledText: anObject [
	styledText := anObject
]
