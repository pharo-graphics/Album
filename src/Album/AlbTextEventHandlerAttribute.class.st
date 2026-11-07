Class {
	#name : #AlbTextEventHandlerAttribute,
	#superclass : #BlTextAttribute,
	#traits : 'TBlEventTarget',
	#classTraits : 'TBlEventTarget classTrait',
	#instVars : [
		'eventDispatcher'
	],
	#category : #'Album-Attributes'
}

{ #category : #'event management accessing' }
AlbTextEventHandlerAttribute >> eventDispatcher [
	"Return an object responsible for event dispatching"
	<return: #BlDirectEventDispatcher>

	^ eventDispatcher 
]

{ #category : #'api - event managing' }
AlbTextEventHandlerAttribute >> handleEvent: aBlEvent [
	self dispatchEvent: aBlEvent
]

{ #category : #initialization }
AlbTextEventHandlerAttribute >> initialize [
	super initialize.
	eventDispatcher := BlDirectEventDispatcher on: self.

]

{ #category : #testing }
AlbTextEventHandlerAttribute >> isEventHandler [
	"Return true if attribute is designed to handle UI events such as mouse,
	false otherwise"
	<return: #Boolean>

	^ true
]

{ #category : #registration }
AlbTextEventHandlerAttribute >> registerInEditor: aTextEditor [
	"Called by aTextEditor when I am part of its text. Move my event handlers to aTextEditor so that the events it receives are forwarded to them"

	| eventHandlers |
	eventHandlers := self eventDispatcher handlers.
	self eventDispatcher removeEventHandlers.
	eventHandlers do: [ :eachHandler | aTextEditor addEventHandler: (BlEventForwarder forwardTo: eachHandler from: self) ]
]

{ #category : #'api - event managing' }
AlbTextEventHandlerAttribute >> wantsEvent: aBlEvent [

Transcript show: 'wantsEvent: ', aBlEvent asString, ' ^ ', (self eventDispatcher wantsEvent: aBlEvent) asString; cr.
(aBlEvent isKindOf: BlClickEvent ) ifTrue: [ self halt ].
	^self eventDispatcher wantsEvent: aBlEvent
]
