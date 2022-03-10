"
!Event handler attribute
Is the superclass of all attributes with the ability to handle some text events received by the visual text elements.
"
Class {
	#name : #AlbTextEventHandlerAttribute,
	#superclass : #BlTextAttribute,
	#category : #'Album-Editor-Attributes'
}

{ #category : #events }
AlbTextEventHandlerAttribute >> handleEvent: anEvent in: aTextEditor on: aTTextEditorTextualPiece [
	self subclassResponsibility
]

{ #category : #testing }
AlbTextEventHandlerAttribute >> isEventHandler [
	"Return true if attribute is designed to handle UI events such as mouse,
	false otherwise"
	<return: #Boolean>

	^ true
]

{ #category : #testing }
AlbTextEventHandlerAttribute >> mayHaveExternalReferences [
	"Answer if this attribute can have references to some external objects like AST nodes or computation results"

	^ true
]

{ #category : #comparing }
AlbTextEventHandlerAttribute >> type [
	^ self
]

{ #category : #events }
AlbTextEventHandlerAttribute >> wantsEvent: anEvent in: aTextEditor [
	"Return true if I am interested in a given event and want to handle it,
	false otherwise"
	<return: #Boolean>

	^ self subclassResponsibility
]
