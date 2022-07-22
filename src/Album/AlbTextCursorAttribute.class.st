"
Allows users to react to the cursor movement within the editor. 
`AlbTextCursorAttributeExamples>>#changingForeground`
"
Class {
	#name : #AlbTextCursorAttribute,
	#superclass : #AlbTextEventHandlerAttribute,
	#instVars : [
		'enterAction',
		'leaveAction',
		'isInside'
	],
	#category : #'Album-Attributes'
}

{ #category : #accessing }
AlbTextCursorAttribute >> enterAction [
	^ enterAction
]

{ #category : #accessing }
AlbTextCursorAttribute >> enterAction: aBlock [
	"A Block in a form [ :aTextEditor :anEvent :aTextStart :aTextEnd | ]"
	self 
		assert: [ aBlock notNil ] 
		description: [ 'Leave action should be initialized' ].
	
	enterAction := aBlock
]

{ #category : #events }
AlbTextCursorAttribute >> handleEvent: anEvent [ 
	"Handle a given event or dispatch it using #sendTo:"

	(anEvent isKindOf: AlbTextCursorAttributeEnterEvent)
		ifTrue: [ self performEnterAction: anEvent ].

	(anEvent isKindOf: AlbTextCursorAttributeLeaveEvent)
		ifTrue: [ self performLeaveAction: anEvent ]
]

{ #category : #initialization }
AlbTextCursorAttribute >> initialize [
	super initialize.

	enterAction := [ :aTextEditor :anEvent :aTextStart :aTextEnd | ].
	leaveAction := [ :aTextEditor :anEvent :aTextStart :aTextEnd | ].
	isInside := nil
]

{ #category : #accessing }
AlbTextCursorAttribute >> leaveAction [
	^ leaveAction
]

{ #category : #accessing }
AlbTextCursorAttribute >> leaveAction: aBlock [
	"A Block in a form [ :aTextEditor :anEvent :aTextStart :aTextEnd | ]"
	self 
		assert: [ aBlock notNil ] 
		description: [ 'Leave action should be initialized' ].

	leaveAction := aBlock
]

{ #category : #private }
AlbTextCursorAttribute >> performEnterAction: anEvent [

	isInside = true ifTrue: [ ^ self ].

	isInside := true.

	self enterAction
		value: anEvent textEditor
		value: anEvent
		value: anEvent attributeStart
		value: anEvent attributeEnd
]

{ #category : #private }
AlbTextCursorAttribute >> performLeaveAction: anEvent [ 

	isInside = false ifTrue: [ ^ self ].

	isInside := false.

	self leaveAction
		value: anEvent textEditor
		value: anEvent
		value: anEvent attributeStart
		value: anEvent attributeEnd
]

{ #category : #events }
AlbTextCursorAttribute >> wantsEvent: anEvent [ 
	"Return true if I am interested in a given event and want to handle it,
	false otherwise"
	<return: #Boolean>

	^ (anEvent isKindOf: AlbTextCursorAttributeEnterEvent)
		or: [ anEvent isKindOf: AlbTextCursorAttributeLeaveEvent ]
]
