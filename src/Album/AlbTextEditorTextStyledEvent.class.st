Class {
	#name : #AlbTextEditorTextStyledEvent,
	#superclass : #AlbTextEditorEvent,
	#instVars : [
		'styledText'
	],
	#category : #'Album-Model-Events'
}

{ #category : #sending }
AlbTextEditorTextStyledEvent >> sendTo: anEventHandler [

	anEventHandler textStyledEvent: self
]

{ #category : #accessing }
AlbTextEditorTextStyledEvent >> styledText [
	^ styledText
]

{ #category : #accessing }
AlbTextEditorTextStyledEvent >> styledText: anObject [
	styledText := anObject
]
