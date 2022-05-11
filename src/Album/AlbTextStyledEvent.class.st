Class {
	#name : #AlbTextStyledEvent,
	#superclass : #BlEvent,
	#instVars : [
		'text',
		'afterAction',
		'editorElement'
	],
	#category : #'Album-Model-Events'
}

{ #category : #accessing }
AlbTextStyledEvent >> afterAction [
	^ afterAction ifNil: [ [ :aStyleText | "do nothing" ] ]
]

{ #category : #accessing }
AlbTextStyledEvent >> afterAction: anObject [
	afterAction := anObject
]

{ #category : #accessing }
AlbTextStyledEvent >> editorElement [
	^ editorElement
]

{ #category : #accessing }
AlbTextStyledEvent >> editorElement: anObject [
	editorElement := anObject
]

{ #category : #accessing }
AlbTextStyledEvent >> text [
	^ text
]

{ #category : #accessing }
AlbTextStyledEvent >> text: anObject [
	text := anObject
]
