Class {
	#name : #AlbTextHoverAttribute,
	#superclass : #AlbTextEventHandlerAttribute,
	#instVars : [
		'enterAction',
		'leaveAction',
		'isHovered'
	],
	#category : #'Album-Attributes'
}

{ #category : #accessing }
AlbTextHoverAttribute >> enterAction [
	^ enterAction
]

{ #category : #accessing }
AlbTextHoverAttribute >> enterAction: anObject [
	enterAction := anObject
]

{ #category : #events }
AlbTextHoverAttribute >> handleEvent: anEvent in: aTextEditor on: aTTextEditorTextualPiece [
	"Handle a given event or dispatch it using #sendTo:"

	(anEvent isKindOf: BlMouseEnterEvent)
		ifTrue: [ self performEnterAction: anEvent in: aTextEditor ].

	(anEvent isKindOf: BlMouseLeaveEvent)
		ifTrue: [ self performLeaveAction: anEvent in: aTextEditor ].
]

{ #category : #initialization }
AlbTextHoverAttribute >> initialize [
	super initialize.

	enterAction := [ :aText :aTextElement :aTextEditor :anEvent | ].
	leaveAction := [ :aText :aTextElement :aTextEditor :anEvent | ].
	isHovered := false
]

{ #category : #accessing }
AlbTextHoverAttribute >> leaveAction [
	^ leaveAction
]

{ #category : #accessing }
AlbTextHoverAttribute >> leaveAction: aBlock [
	self 
		assert: [ aBlock notNil ] 
		description: [ 'Leave action should be initialized' ].

	leaveAction := aBlock
]

{ #category : #private }
AlbTextHoverAttribute >> performEnterAction: anEvent in: aTextEditor [

	isHovered ifTrue: [ ^ self ].

	isHovered := true.

	self enterAction
		value: anEvent currentTarget text
		value: anEvent currentTarget
		value: aTextEditor
		value: anEvent
]

{ #category : #private }
AlbTextHoverAttribute >> performLeaveAction: anEvent in: aTextEditor [

	isHovered ifFalse: [ ^ self ].

	isHovered := false.

	self leaveAction
		value: anEvent currentTarget text
		value: anEvent currentTarget
		value: aTextEditor
		value: anEvent
]

{ #category : #events }
AlbTextHoverAttribute >> wantsEvent: anEvent in: aTextEditor [
	"Return true if I am interested in a given event and want to handle it,
	false otherwise"
	<return: #Boolean>

	^ (anEvent isKindOf: BlMouseEnterEvent)
		or: [ anEvent isKindOf: BlMouseLeaveEvent ]
]
