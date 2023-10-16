Class {
	#name : 'AlbTextHoverAttribute',
	#superclass : 'AlbTextCrappyEventHandlerAttribute',
	#instVars : [
		'enterAction',
		'leaveAction',
		'isHovered'
	],
	#category : 'Album-Attributes',
	#package : 'Album',
	#tag : 'Attributes'
}

{ #category : 'accessing' }
AlbTextHoverAttribute >> enterAction [
	^ enterAction
]

{ #category : 'accessing' }
AlbTextHoverAttribute >> enterAction: anObject [
	enterAction := anObject
]

{ #category : 'events' }
AlbTextHoverAttribute >> handleEvent: anEvent [ 
	"Handle a given event or dispatch it using #sendTo:"

	(anEvent wrappedEvent isKindOf: BlMouseEnterEvent)
		ifTrue: [ self performEnterAction: anEvent ].

	(anEvent wrappedEvent isKindOf: BlMouseLeaveEvent)
		ifTrue: [ self performLeaveAction: anEvent ].
]

{ #category : 'initialization' }
AlbTextHoverAttribute >> initialize [
	super initialize.

	enterAction := [ :aText :aTextElement :aTextEditor :anEvent | ].
	leaveAction := [ :aText :aTextElement :aTextEditor :anEvent | ].
	isHovered := false
]

{ #category : 'accessing' }
AlbTextHoverAttribute >> leaveAction [
	^ leaveAction
]

{ #category : 'accessing' }
AlbTextHoverAttribute >> leaveAction: aBlock [
	self 
		assert: [ aBlock notNil ] 
		description: [ 'Leave action should be initialized' ].

	leaveAction := aBlock
]

{ #category : 'private' }
AlbTextHoverAttribute >> performEnterAction: anEvent [ 

	isHovered ifTrue: [ ^ self ].

	isHovered := true.

	self enterAction
		value: anEvent wrappedEvent currentTarget text
		value: anEvent wrappedEvent currentTarget
		value: anEvent textEditor
		value: anEvent wrappedEvent
]

{ #category : 'private' }
AlbTextHoverAttribute >> performLeaveAction: anEvent [ 

	isHovered ifFalse: [ ^ self ].

	isHovered := false.

	self leaveAction
		value: anEvent wrappedEvent currentTarget text
		value: anEvent wrappedEvent currentTarget
		value: anEvent textEditor
		value: anEvent wrappedEvent
]

{ #category : 'events' }
AlbTextHoverAttribute >> wantsEvent: anEvent [
	"Return true if I am interested in a given event and want to handle it,
	false otherwise"
	<return: #Boolean>

	^ (anEvent wrappedEvent isKindOf: BlMouseEnterEvent)
		or: [ anEvent wrappedEvent isKindOf: BlMouseLeaveEvent ]
]
