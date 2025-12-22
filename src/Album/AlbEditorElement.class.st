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
		'modeRemanentSubtextEventHandlers',
		'beneathLayer',
		'modeBeneathLayerEventHandlers'
	],
	#category : #'Album-UI'
}

{ #category : #accessing }
AlbEditorElement >> beneathLayer [

	^ beneathLayer
]

{ #category : #initialization }
AlbEditorElement >> defaultBeneathLayer [

	| layer |
	layer := BlElement new.
	layer layout: BlBasicLayout new.
	layer constraintsDo: [ :c | 
		c horizontal matchParent.
		c vertical matchParent ].
	^ layer
]

{ #category : #initialization }
AlbEditorElement >> defaultBeneathLayerEventHandlers [

	^ self mode defaultBeneathLayerEventHandlers.

]

{ #category : #initialization }
AlbEditorElement >> defaultFrontLayer [

	| layer |
	layer := BlElement new.
	layer layout: BlBasicLayout new.
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

	self withAllChildrenDo: [ :child | 
		child dispatchEvent: AlbSubtextElementInvalidateEvent new ].
	self beneathLayer childrenDo: [ :child | 
		child dispatchEvent: AlbSubtextElementInvalidateEvent new ].
	self frontLayer childrenDo: [ :child | 
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
	self matchParent.
	self next: self defaultInfiniteElement.
	self setupTextEditor.

	beneathLayer := self defaultBeneathLayer.
	frontLayer := self defaultFrontLayer.
	self addChild: beneathLayer as: #beneathLayer.
	self addChild: self next as: #infiniteEditor.
	self addChild: frontLayer as: #frontLayer.

	" the editor element must be over the front layer "
	self next elevation: (BlRelativeElevation elevation: 2).
	self frontLayer elevation: (BlRelativeElevation elevation: 3).
	self beneathLayer elevation: (BlRelativeElevation elevation: 1).

	self setupPrimarySelectionElement.
	self setupModeEventHandlers.
	self addEventHandler: AlbEditorElementEventHandler new.
	distributor := BlSharedEventDistributor new
		               adjustMousePosition: false;
		               shareEvents: {
				               BlMouseEvent.
				               BlElementScrolledEvent.
				               AlbTextInsertedEvent.
				               AlbTextDeletedEvent.
				               AlbTextEditedEvent.
				               AlbInfiniteModeChangedEvent};
		               yourself.
	" to handle the mouse events that are dispatcehd to the front layer "
	self frontLayer addEventHandler: distributor.
	self next addEventHandler: distributor.
	self addEventHandler: distributor
]

{ #category : #accessing }
AlbEditorElement >> lineIndexAtTextIndex: aCharacterIndex [

	self
		atTextIndex: aCharacterIndex
		do: [ :textElement :localPos | ^ textElement lineIndex ].
	^ nil
]

{ #category : #initialization }
AlbEditorElement >> modeBeneathLayerEventHandlersDo: aBlock [

	modeBeneathLayerEventHandlers ifNotNil: [ modeBeneathLayerEventHandlers do: aBlock ] 
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
		  elevation: (BlRelativeElevation elevation: 1);
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

{ #category : #initialization }
AlbEditorElement >> setupModeEventHandlers [

	self modeFrontLayerEventHandlersDo: [ :handler |
		self frontLayer removeEventHandler: handler ].
	self modeBeneathLayerEventHandlersDo: [ :handler |
		self beneathLayer removeEventHandler: handler ].
	modeFrontLayerEventHandlers := self defaultFrontLayerEventHandlers.
	modeBeneathLayerEventHandlers := self defaultBeneathLayerEventHandlers.
	self modeFrontLayerEventHandlersDo: [ :handler |
		self frontLayer addEventHandler: (handler
				 element: self infinite;
				 yourself) ].
	self modeBeneathLayerEventHandlersDo: [ :handler |
		self beneathLayer addEventHandler: (handler
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
	primarySelectionElement ifNotNil: [ :pse | self beneathLayer addChild: pse ]
]

{ #category : #initialization }
AlbEditorElement >> setupTextEditor [

	self editor addEventHandler: (BlEventHandler
			 on: AlbSelectionChangedEvent
			 do: [ :event |
				 self dispatchPrimarySelectionInvalidateEvent.
				 self dispatchEvent: event copy ])
]
