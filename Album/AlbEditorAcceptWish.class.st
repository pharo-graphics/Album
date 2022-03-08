Class {
	#name : #AlbEditorAcceptWish,
	#superclass : #AlbEditorWish,
	#instVars : [
		'text'
	],
	#category : #'Album-Editor - Events'
}

{ #category : #accessing }
AlbEditorAcceptWish >> text [
	^ text
]

{ #category : #accessing }
AlbEditorAcceptWish >> text: anObject [
	text := anObject
]
