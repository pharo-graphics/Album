Class {
	#name : #AlbEditorAcceptWish,
	#superclass : #AlbEditorWish,
	#instVars : [
		'text'
	],
	#category : #'Album-Brick-NU-Events'
}

{ #category : #accessing }
AlbEditorAcceptWish >> text [
	^ text
]

{ #category : #accessing }
AlbEditorAcceptWish >> text: anObject [
	text := anObject
]
