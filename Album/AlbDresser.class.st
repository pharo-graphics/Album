Class {
	#name : #AlbDresser,
	#superclass : #Object,
	#traits : 'TBlEventTarget',
	#classTraits : 'TBlEventTarget classTrait',
	#instVars : [
		'widget',
		'eventDispatcher'
	],
	#category : #'Album-Brick-Core'
}

{ #category : #'api - changes' }
AlbDresser >> addChangeAddChild: aCollection with: aBlock [
	self
		addChange:
			(AlbLookAddChildChange new
				path: aCollection;
				value: aBlock;
				yourself)
]

{ #category : #'api - changes' }
AlbDresser >> addChangeAddChildAs: aCollection with: aBlock [
	self
		addChange:
			(AlbLookAddChildAsChange new
				path: aCollection;
				value: aBlock;
				yourself)
]

{ #category : #'api - changes' }
AlbDresser >> addChangeAddChildFirst: aCollection with: aBlock [
	"Add the supplied change, which will add an element as the first child of the target element"
	self
		addChange:
			(AlbLookAddChildFirstChange new
				path: aCollection;
				value: aBlock;
				yourself)
]

{ #category : #'event management' }
AlbDresser >> addEventHandler: anEventHandler [
	self isAttachedToWidget
		ifTrue: [ self widget addEventHandler: (BlEventForwarder forwardTo: anEventHandler from: self) ]
		ifFalse: [ self eventDispatcher addEventHandler: anEventHandler ]
]

{ #category : #'event management' }
AlbDresser >> dispatchEvent: anEvent [
	"If I am attached to the widget I dispatch event to the widget,
	otherwise I dispatch a given event to myself and my children "

	anEvent hasSource
		ifFalse: [ anEvent source: self ].

	"first, we dispatch to my direct listeners"
	self dispatchEventToMyself: anEvent.

	"then let the rest of the element components receive it"
	anEvent target dispatchEvent: anEvent
]

{ #category : #'event management' }
AlbDresser >> dispatchEventToMyself: anEvent [

	anEvent target: self.
	anEvent forwardingTarget: self.

	(self eventDispatcher wantsEvent: anEvent)
		ifTrue: [ self eventDispatcher dispatchEvent: anEvent ]
]

{ #category : #'event management accessing' }
AlbDresser >> eventDispatcher [
	"Return an object responsible for event dispatching"
	<return: #BlDirectEventDispatcher>

	^ eventDispatcher
]

{ #category : #'event management' }
AlbDresser >> fireEvent: anEvent [
	"I fire provided event while building an event dispatcher chain
	(from target to the root element) and dispatch the event with it.
	anEvent must not be nil"

	anEvent hasSource
		ifFalse: [ anEvent source: self ].

	"first, we fire to my direct listeners"
	"self fireEventToMyself: anEvent."

	"then let the rest of the element components receive it"
	anEvent target fireEvent: anEvent.

]

{ #category : #'event management' }
AlbDresser >> fireEventToMyself: anEvent [
	
	anEvent forwardingTarget: self.
	anEvent target: self.

	BlEvent fireEvent: anEvent target: self
]

{ #category : #'api - testing' }
AlbDresser >> hasOwner [
	"Utility #owner message makes it possible to have a polymorphic way to visualise a tree structure of the elements"
	<return: #Boolean>

	^ self isAttachedToWidget
]

{ #category : #initialization }
AlbDresser >> initialize [
	super initialize.
	eventDispatcher := BlDirectEventDispatcher on: self.
	self initializeListeners
]

{ #category : #initialization }
AlbDresser >> initializeListeners [
	"Override me to initialize event listeners such as property updates from the view model"
]

{ #category : #initialization }
AlbDresser >> initializeListenersFrom: anElement [
	"Override me to initialize event listeners such as property updates from the view model"
]

{ #category : #initialization }
AlbDresser >> initializeRequests [
	"Override me to implement requests to the view model to synchronise its properties"
]

{ #category : #initialization }
AlbDresser >> initializeRequestsFrom: anElement [
	"Override me to implement requests to the view model to synchronise its properties"
]

{ #category : #'api - testing' }
AlbDresser >> isAttachedToWidget [
	"Return true if I am attached to a widget element, false otherwise.
	When an actor (look or model) is not attached to the element it can not send or receive events"
	<return: #Boolean>

	^ widget isNotNil
]

{ #category : #'api - hooks' }
AlbDresser >> onAttachedTo: anElement [
	"Is sent when I am added to an element (or to the other actor which is added to the element)"
	self transferEventHandlersTo: anElement
]

{ #category : #'api - hooks' }
AlbDresser >> onInstalledIn: anElement [
	"Is sent when I am added to an element (or to the other actor which is added to the element)"

	self onAttachedTo: anElement.
	self initializeRequestsFrom: anElement
]

{ #category : #'api - hooks' }
AlbDresser >> onUninstalledIn: anElement [
	"Is sent when I am removed from an element (or from the other actor which was part of the element)"
	
	self
		assert: [ self widget == anElement ]
		description: [ 'Can not uninstall from a different widget' ].

	self removeEventHandlersFromWidget.
	widget := nil.
	
	self initializeListenersFrom: anElement
]

{ #category : #accessing }
AlbDresser >> owner [
	"Utility #owner message makes it possible to have a polymorphic way to visualise a tree structure of the elements"
	<return: #BlElement>

	^ self widget
]

{ #category : #'private - event management' }
AlbDresser >> removeEventHandlersFromWidget [
	self widget removeEventHandlersSuchThat: [ :eachEventHandler |
		(eachEventHandler isKindOf: BlEventForwarder) and: [ eachEventHandler eventTarget == self ] ]
]

{ #category : #'event management' }
AlbDresser >> request: aRequest [

	aRequest canBePropagated
		ifTrue: [ self fireEvent: aRequest ]
		ifFalse: [ self dispatchEvent: aRequest ].

	^ aRequest response
]

{ #category : #accessing }
AlbDresser >> theme [
	^ widget ifNil: [ AlbTheme default ] ifNotNil: #theme
]

{ #category : #'private - event management' }
AlbDresser >> transferEventHandlersTo: anElement [
	| theEventHandlers |
	
	theEventHandlers := self eventDispatcher handlers.
	self eventDispatcher removeEventHandlers.
	
	theEventHandlers do: [ :eachHandler | anElement addEventHandler: (BlEventForwarder forwardTo: eachHandler from: self) ]
]

{ #category : #'private - event management' }
AlbDresser >> transferEventHandlersToWidget [
	| theEventHandlers |
	
	theEventHandlers := self eventDispatcher handlers.
	self eventDispatcher removeEventHandlers.
	
	theEventHandlers do: [ :eachHandler | self widget addEventHandler: (BlEventForwarder forwardTo: eachHandler from: self) ]
]

{ #category : #accessing }
AlbDresser >> widget [
	<return: #BlElement>
	self deprecated: 'not used, widget is not stored in a dresser. It is passed as argument'.
	self
		assert: [ self isAttachedToWidget ]
		description: [ 'Must be attached to a widget in order to access it' ].

	^ widget
]

{ #category : #accessing }
AlbDresser >> widgetContent [
	"Return widget's content container element"
	<return: #BlElement>
	self deprecated: 'not used, widget is not stored here'.
	self
		assert: [ widget isNotNil ]
		description: [ 'I must be attached to the widget first' ].

	"if widget does not have explicit #content container, we treat widget as a container itself"
	^ widget
		directChildNamed: #content
		ifFound: [ :anElement | anElement ]
		ifNone: [ widget ]
]

{ #category : #accessing }
AlbDresser >> widgetDo: aBlockClosure [
self deprecated: 'not used; widget is not stored here'.
	widget ifNotNil: aBlockClosure
]
