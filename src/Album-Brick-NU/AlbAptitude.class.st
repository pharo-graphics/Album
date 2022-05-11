Class {
	#name : #AlbAptitude,
	#superclass : #AlbActor,
	#instVars : [
		'changes'
	],
	#category : #'Album-Brick-NU-Actor and Aptitude'
}

{ #category : #'api - composition' }
AlbAptitude class >> + anotherLook [
	^ self asLook + anotherLook
]

{ #category : #'api - composition' }
AlbAptitude class >> - anotherLook [
	^ self asLook - anotherLook
]

{ #category : #'api - composition' }
AlbAptitude class >> asLook [
	^ self new
]

{ #category : #'api - composition' }
AlbAptitude >> + anotherLook [
	self add: anotherLook asLook
]

{ #category : #'api - composition' }
AlbAptitude >> - aLookClass [
	| toBeRemoved |
	self
		assert: [ aLookClass isClass ]
		description: [ 'It is only possible to remove a look by its type (class) using this API' ].

	toBeRemoved := actors select: [ :eachLook | eachLook class = aLookClass ].
	toBeRemoved reverseDo: [ :eachLook | self remove: eachLook ].
	actors do: [ :eachLook | eachLook - aLookClass ]
]

{ #category : #'api - composition' }
AlbAptitude >> add: aLook [
	"Add a given look instance if it does not exist already"
	| aLookInstance |

	aLookInstance := aLook asLook.
	
	(actors includes: aLookInstance)
		ifTrue: [ ^ self ].

	actors := actors copyWith: aLookInstance.

	self widgetDo: [ :anElement | aLookInstance onInstalledIn: anElement ]
]

{ #category : #'api - composition' }
AlbAptitude >> addAll: aCollectionOfLooks [
	aCollectionOfLooks do: [ :aLook | self add: aLook ]
]

{ #category : #'api - changes' }
AlbAptitude >> addChange: aLookChange [
	changes add: aLookChange.
	widget ifNotNil: [ aLookChange upOn: self ]
]

{ #category : #'api - changes' }
AlbAptitude >> addChangeAddChild: aCollection with: aBlock [
	self
		addChange:
			(AlbLookAddChildChange new
				path: aCollection;
				value: aBlock;
				yourself)
]

{ #category : #'api - changes' }
AlbAptitude >> addChangeAddChildAs: aCollection with: aBlock [
	self
		addChange:
			(AlbLookAddChildAsChange new
				path: aCollection;
				value: aBlock;
				yourself)
]

{ #category : #'api - changes' }
AlbAptitude >> addChangeAddChildFirst: aCollection with: aBlock [
	"Add the supplied change, which will add an element as the first child of the target element"
	self
		addChange:
			(AlbLookAddChildFirstChange new
				path: aCollection;
				value: aBlock;
				yourself)
]

{ #category : #'api - changes' }
AlbAptitude >> addChangeProperty: aCollection with: aBlock [
	self
		addChange:
			(AlbLookPropertyChange new
				path: aCollection;
				value: aBlock;
				yourself)
]

{ #category : #'api - changes' }
AlbAptitude >> addChangeProperty: aCollection withCopy: aBlock [
	self
		addChange:
			(AlbLookPropertyCopyChange new
				path: aCollection;
				value: aBlock;
				yourself)
]

{ #category : #'api - composition' }
AlbAptitude >> asLook [
	^ self
]

{ #category : #'api - changes' }
AlbAptitude >> changes [
	^ changes
]

{ #category : #'event management' }
AlbAptitude >> dispatchEvent: anEvent [

	super dispatchEvent: anEvent.
]

{ #category : #initialization }
AlbAptitude >> initialize [
	super initialize.
	changes := AlbLookChanges new
]

{ #category : #initialization }
AlbAptitude >> initializeRequests [
	"Override me to implement requests to the view model to synchronise its properties"
]

{ #category : #accessing }
AlbAptitude >> looks [
	^ self children
]

{ #category : #'api - hooks' }
AlbAptitude >> onAttachedTo: anElement [
	"Is sent when I am added to an element (or to the other actor which is added to the element)"

	self
		assert: [ widget isNil ]
		description: [ 'Can not install the same look instance on multiple widgets' ].

	widget := anElement.
	
	self transferEventHandlersToWidget
]

{ #category : #'api - hooks' }
AlbAptitude >> onInstalledIn: anElement [
	self withAllActorsBreadthFirstDo: [ :eachLook | eachLook onAttachedTo: anElement ].
	self withAllActorsBreadthFirstDo: [ :eachLook | eachLook changes upOn: eachLook ].
	self withAllActorsBreadthFirstDo: [ :eachLook | eachLook initializeRequests ]
]

{ #category : #'api - hooks' }
AlbAptitude >> onUninstalledIn: anElement [
	super onUninstalledIn: anElement.

	self
		assert: [ self widget == anElement ]
		description: [ 'Can not uninstall from a different widget' ].

	self looks reversed do: [ :aLook | aLook onUninstalledIn: anElement ].

	changes downOn: self.
	widget := nil.
	
	self initializeListeners
]

{ #category : #'api - composition' }
AlbAptitude >> remove: aLook [
	"Remove a given look if it exists"
	| aLookInstance |

	aLookInstance := aLook asLook.
	
	(actors includes: aLookInstance)
		ifFalse: [ ^ self ].
	
	actors := actors copyWithout: aLookInstance.
	aLookInstance widgetDo: [ :anElement | aLookInstance onUninstalledIn: anElement ]
]

{ #category : #accessing }
AlbAptitude >> theme [
	^ widget ifNil: [ AlbTheme default ] ifNotNil: #theme
]

{ #category : #accessing }
AlbAptitude >> widgetContent [
	"Return widget's content container element"
	<return: #BlElement>

	self
		assert: [ widget isNotNil ]
		description: [ 'I must be attached to the widget first' ].

	"if widget does not have explicit #content container, we treat widget as a container itself"
	^ widget
		directChildNamed: #content
		ifFound: [ :anElement | anElement ]
		ifNone: [ widget ]
]
