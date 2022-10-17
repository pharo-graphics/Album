Class {
	#name : #AlbTextModifiedEvent,
	#superclass : #BlEvent,
	#instVars : [
		'text'
	],
	#category : #'Album-Model-Events'
}

{ #category : #sending }
AlbTextModifiedEvent >> sendTo: anEventHandler [

	anEventHandler textModifiedEvent: self
]

{ #category : #accessing }
AlbTextModifiedEvent >> text [
	^ text
]

{ #category : #accessing }
AlbTextModifiedEvent >> text: anObject [
	text := anObject
]
