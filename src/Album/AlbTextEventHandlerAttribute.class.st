Class {
	#name : 'AlbTextEventHandlerAttribute',
	#superclass : 'BlTextAttribute',
	#traits : 'TBlEventTarget',
	#classTraits : 'TBlEventTarget classTrait',
	#instVars : [
		'eventDispatcher'
	],
	#category : 'Album-Attributes',
	#package : 'Album',
	#tag : 'Attributes'
}

{ #category : 'event management accessing' }
AlbTextEventHandlerAttribute >> eventDispatcher [
	"Return an object responsible for event dispatching"
	<return: #BlDirectEventDispatcher>

	^ eventDispatcher 
]

{ #category : 'api - event managing' }
AlbTextEventHandlerAttribute >> handleEvent: aBlEvent [
	self dispatchEvent: aBlEvent
]

{ #category : 'initialization' }
AlbTextEventHandlerAttribute >> initialize [
	super initialize.
	eventDispatcher := BlDirectEventDispatcher on: self.

]

{ #category : 'testing' }
AlbTextEventHandlerAttribute >> isEventHandler [
	"Return true if attribute is designed to handle UI events such as mouse,
	false otherwise"
	<return: #Boolean>

	^ true
]

{ #category : 'api - event managing' }
AlbTextEventHandlerAttribute >> wantsEvent: aBlEvent [

Transcript show: 'wantsEvent: ', aBlEvent asString, ' ^ ', (self eventDispatcher wantsEvent: aBlEvent) asString; cr.
(aBlEvent isKindOf: BlClickEvent ) ifTrue: [ self halt ].
	^self eventDispatcher wantsEvent: aBlEvent
]
