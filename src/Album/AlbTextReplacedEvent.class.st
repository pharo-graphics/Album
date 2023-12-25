Class {
	#name : #AlbTextReplacedEvent,
	#superclass : #BlEvent,
	#instVars : [
		'text'
	],
	#category : 'Album-Model-Events'
}

{ #category : #sending }
AlbTextReplacedEvent >> sendTo: anEventHandler [
	anEventHandler textReplacedEvent: self
]

{ #category : #accessing }
AlbTextReplacedEvent >> text [
	^ text
]

{ #category : #accessing }
AlbTextReplacedEvent >> text: anObject [
	text := anObject
]
