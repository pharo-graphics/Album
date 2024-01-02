"
I'm an infinite element for text viewing and editing. I support scrolling, selection and other classical text editing features.
Text editing operations are driven by my data source (called textEditor). I also own a view model (viewModel) that serve as an interface for clients applicative model (such as a browser as an example).


"
Class {
	#name : #AlbEditorElement,
	#superclass : #BlElement,
	#traits : 'TAlbInfiniteDecorator + TBlLayoutResizable',
	#classTraits : 'TAlbInfiniteDecorator classTrait + TBlLayoutResizable classTrait',
	#instVars : [
		'next',
		'frontLayer',
		'primarySelectionElementClass',
		'primarySelectionElement',
		'modeFrontLayerEventHandlers',
		'modeRemanentSubtextEventHandlers'
	],
	#category : #'Album-UI'
}

{ #category : #initialization }
AlbEditorElement >> defaultFrontLayer [

	| layer |
	layer := BlElement new.
	layer constraintsDo: [ :c | 
		c horizontal matchParent.
		c vertical matchParent ].
	^ layer
]

{ #category : #initialization }
AlbEditorElement >> defaultFrontLayerEventHandlers [

	^ self mode defaultFrontLayerEventHandlers.

]

{ #category : #initialization }
AlbEditorElement >> defaultInfiniteElement [  

	^ AlbInfiniteEditorElement new
]

{ #category : #initialization }
AlbEditorElement >> defaultLayout [

	^ BlFrameLayout new
]

{ #category : #initialization }
AlbEditorElement >> defaultRemanentSubtextEventHandlers [

	^ self mode defaultRemanentSubtextEventHandlers

]

{ #category : #'selection changing' }
AlbEditorElement >> dispatchPrimarySelectionInvalidateEvent [
	" dispatch to primary selection, to myself to reach remanents updater to all frontLayer children "

	self withAllChildrenBreadthFirstDo: [ :child |
		child dispatchEvent: AlbSubtextElementInvalidateEvent new ]
]

{ #category : #accessing }
AlbEditorElement >> frontLayer [

	^ frontLayer
]

{ #category : #initialization }
AlbEditorElement >> initialize [

	| distributor |
	super initialize.
	self layout: self defaultLayout.
	self next: self defaultInfiniteElement.
	self setupPrimarySelectionElement.
	self setupTextEditor.
	self addChild: next.

	self addEventHandler: AlbEditorElementEventHandler new.

	frontLayer := self defaultFrontLayer.
	self addChild: frontLayer as: #frontLayer.
	distributor := BlSharedEventDistributor new
		               adjustMousePosition: false;
		               shareEvents: {
				               BlMouseEvent.
				               BlElementScrolledEvent.
				               AlbTextEditedEvent.
				               AlbInfiniteModeChangedEvent };
		               yourself.
	" to handle the mouse events that are dispatcehd to the front layer "
	self frontLayer addEventHandler: distributor.
	self infinite addEventHandler: distributor.
	self addEventHandler: distributor.
	self matchParent.
	self setupModeEventHandlers
]

{ #category : #initialization }
AlbEditorElement >> modeFrontLayerEventHandlersDo: aBlock [

	modeFrontLayerEventHandlers ifNotNil: [ modeFrontLayerEventHandlers do: aBlock ] 
]

{ #category : #initialization }
AlbEditorElement >> modeRemanentSubtextEventHandlersDo: aBlock [

	modeRemanentSubtextEventHandlers ifNotNil: [ modeRemanentSubtextEventHandlers do: aBlock ] 
]

{ #category : #initialization }
AlbEditorElement >> newPrimarySelectionElement [

	^ self primarySelectionElementClass new
		  editorElement: self;
		  yourself
]

{ #category : #'t - infinite editor accessing' }
AlbEditorElement >> next [

	^ next
]

{ #category : #'t - infinite editor accessing' }
AlbEditorElement >> next: aDecoratorOrInfinite [

	next := aDecoratorOrInfinite
]

{ #category : #accessing }
AlbEditorElement >> primarySelectionElement [

	^ primarySelectionElement
]

{ #category : #initialization }
AlbEditorElement >> primarySelectionElementClass [

	^ primarySelectionElementClass ifNil: [
		  primarySelectionElementClass := AlbPrimarySelectionElement ]
]

{ #category : #initialization }
AlbEditorElement >> primarySelectionElementClass: aSelectionElementClass [
	" aSelectionElementClass is AlbPrimarySelectionElement or one of it subclass "

	primarySelectionElementClass = aSelectionElementClass ifTrue: [
		^ self ].
	primarySelectionElementClass := aSelectionElementClass.
	self dispatchEvent: AlbPrimarySelectionElementClassChangedEvent new
]

{ #category : #accessing }
AlbEditorElement >> primarySelectionElementDo: aValuable [

	primarySelectionElement ifNil: [ ^ self ].
	aValuable value: primarySelectionElement
]

{ #category : #'t  - layout resizeable' }
AlbEditorElement >> resizableConstraintsDo: aBlock [
	"Perform aBlock with my constraints as argument.
	Note: After evaluation I request a layout update!
	aBlock must not be nil.
	aBlock must accept exactly one argument
	
	Can be basically defined with #constraintsDo: aBlock.
	
	Introduced a an explicit requirement to let user
	implement additional actions when resizing is changed
	
	"
	self constraintsDo: aBlock
]

{ #category : #initialization }
AlbEditorElement >> setupModeEventHandlers [

	self modeFrontLayerEventHandlersDo: [ :handler |
		self frontLayer removeEventHandler: handler ].
	modeFrontLayerEventHandlers := self defaultFrontLayerEventHandlers.
	self modeFrontLayerEventHandlersDo: [ :handler |
		self frontLayer addEventHandler: (handler
				 element: self infinite;
				 yourself) ].

	self modeRemanentSubtextEventHandlersDo: [ :handler |
		self removeEventHandler: handler ].
	modeRemanentSubtextEventHandlers := self defaultRemanentSubtextEventHandlers.
	self modeRemanentSubtextEventHandlersDo: [ :handler |
		self addEventHandler: handler ]
]

{ #category : #initialization }
AlbEditorElement >> setupPrimarySelectionElement [

	primarySelectionElement ifNotNil: [ :pse | pse removeFromParent ].
	primarySelectionElement := self newPrimarySelectionElement.
	primarySelectionElement ifNotNil: [ :pse | self addChild: pse ]
]

{ #category : #initialization }
AlbEditorElement >> setupTextEditor [

	self editor addEventHandler: (BlEventHandler
			 on: AlbSelectionChangedEvent
			 do: [ :event |
				 self dispatchPrimarySelectionInvalidateEvent ])
]
