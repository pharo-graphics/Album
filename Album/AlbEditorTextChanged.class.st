Class {
	#name : #AlbEditorTextChanged,
	#superclass : #AlbEditorChangedEvent,
	#instVars : [
		'text'
	],
	#category : #'Album-Editor - Events'
}

{ #category : #accessing }
AlbEditorTextChanged class >> text: aText [
	^ self new text: aText
]

{ #category : #accessing }
AlbEditorTextChanged >> text [
	^ text
]

{ #category : #accessing }
AlbEditorTextChanged >> text: anObject [
	text := anObject
]
