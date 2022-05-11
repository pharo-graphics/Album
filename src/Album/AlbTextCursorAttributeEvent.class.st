Class {
	#name : #AlbTextCursorAttributeEvent,
	#superclass : #BlEvent,
	#instVars : [
		'interval'
	],
	#category : #'Album-Attributes - Support'
}

{ #category : #accessing }
AlbTextCursorAttributeEvent >> attributeEnd [
	^ interval last
]

{ #category : #accessing }
AlbTextCursorAttributeEvent >> attributeStart [
	^ interval first
]

{ #category : #accessing }
AlbTextCursorAttributeEvent >> interval [

	^ interval
]

{ #category : #accessing }
AlbTextCursorAttributeEvent >> interval: anObject [

	interval := anObject
]
