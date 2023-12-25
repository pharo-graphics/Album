Class {
	#name : #AlbTextCursorAttributeEvent,
	#superclass : #BlEvent,
	#instVars : [
		'interval',
		'textualPiece',
		'textEditor',
		'wrappedEvent'
	],
	#category : 'Album-Attributes - Support'
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

{ #category : #accessing }
AlbTextCursorAttributeEvent >> textEditor [

	^ textEditor
]

{ #category : #accessing }
AlbTextCursorAttributeEvent >> textEditor: aTextEditor [

	textEditor := aTextEditor
]

{ #category : #accessing }
AlbTextCursorAttributeEvent >> textualPiece [

	^ textualPiece
]

{ #category : #accessing }
AlbTextCursorAttributeEvent >> textualPiece: aTextualPiece [

	textualPiece := aTextualPiece
]

{ #category : #accessing }
AlbTextCursorAttributeEvent >> wrappedEvent [
	^ wrappedEvent ifNil: [ self ]
]

{ #category : #accessing }
AlbTextCursorAttributeEvent >> wrappedEvent: anEvent [

	wrappedEvent := anEvent
]
