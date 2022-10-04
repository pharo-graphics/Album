Class {
	#name : #AlbEditorTextChangedEvent,
	#superclass : #AlbEditorChangedEvent,
	#instVars : [
		'text'
	],
	#category : #'Album-Model-Events'
}

{ #category : #accessing }
AlbEditorTextChangedEvent class >> text: aText [
	^ self new text: aText
]

{ #category : #sending }
AlbEditorTextChangedEvent >> sendTo: anEventHandler [

	anEventHandler textChangedEvent: self
]

{ #category : #accessing }
AlbEditorTextChangedEvent >> text [
	^ text
]

{ #category : #accessing }
AlbEditorTextChangedEvent >> text: anObject [
	text := anObject
]
