Class {
	#name : #AlbTextEditedEvent,
	#superclass : #BlEvent,
	#instVars : [
		'text',
		'sourceEvent'
	],
	#category : #'Album-Model-Events'
}

{ #category : #sending }
AlbTextEditedEvent >> sendTo: anEventHandler [

	anEventHandler textEditedEvent: self
]

{ #category : #accessing }
AlbTextEditedEvent >> text [
	^ text
]

{ #category : #accessing }
AlbTextEditedEvent >> text: anObject [
	text := anObject
]
