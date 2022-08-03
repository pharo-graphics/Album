"
!Event handler attribute
Is the superclass of all attributes with the ability to handle some text events received by the visual text elements.
"
Class {
	#name : #AlbTextCrappyEventHandlerAttribute,
	#superclass : #BlTextAttribute,
	#category : #'Album-Attributes'
}

{ #category : #events }
AlbTextCrappyEventHandlerAttribute >> handleEvent: anEvent [ 
	self subclassResponsibility
]

{ #category : #testing }
AlbTextCrappyEventHandlerAttribute >> isEventHandler [
	"Return true if attribute is designed to handle UI events such as mouse,
	false otherwise"
	<return: #Boolean>

	^ true
]

{ #category : #testing }
AlbTextCrappyEventHandlerAttribute >> mayHaveExternalReferences [
	"Answer if this attribute can have references to some external objects like AST nodes or computation results"

	^ true
]

{ #category : #comparing }
AlbTextCrappyEventHandlerAttribute >> type [
	^ self
]

{ #category : #events }
AlbTextCrappyEventHandlerAttribute >> wantsEvent: anEvent [ 
	"Return true if I am interested in a given event and want to handle it,
	false otherwise"
	<return: #Boolean>

	^ self subclassResponsibility
]
