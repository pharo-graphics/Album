"
I'm an infinite element for text viewing and editing. I support scrolling, selection and other classical text editing features.
Text editing operations are driven by my data source (called textEditor). I also own a view model (viewModel) that serve as an interface for clients applicative model (such as a browser as an example).


"
Class {
	#name : #AlbEditorElement,
	#superclass : #BlElement,
	#traits : 'TAlbInfiniteDecorator + TOBlLayoutResizable',
	#classTraits : 'TAlbInfiniteDecorator classTrait + TOBlLayoutResizable classTrait',
	#instVars : [
		'next',
		'selectionElement',
		'oppositeUpdater',
		'remanentUpdater',
		'modeEventHandlers',
		'frontLayer'
	],
	#category : #'Album-UI'
}

{ #category : #initialization }
AlbEditorElement >> defaultBackground [

	^ BlBackground paint: Color white
]

{ #category : #initialization }
AlbEditorElement >> defaultFrontLayer [

	| layer |
	layer := BlElement new.
	layer elevation: (BlRelativeElevation elevation: SmallInteger maxVal).
	layer constraintsDo: [ :c | 
		c horizontal matchParent.
		c vertical matchParent ].
	^ layer
]

{ #category : #initialization }
AlbEditorElement >> defaultLayout [

	^ BlFrameLayout new
]

{ #category : #initialization }
AlbEditorElement >> defaultMargin [

	^ BlInsets all: 1
]

{ #category : #initialization }
AlbEditorElement >> defaultModeEventHandlers [

	^ self mode defaultFrontLayerEventHandlers.

]

{ #category : #initialization }
AlbEditorElement >> defaultPadding [

	^ BlInsets empty

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
	self background: self defaultBackground.
	self margin: self defaultMargin.
	self padding: self defaultPadding.
	self next: AlbInfiniteEditorElement new.
	self installSelectionElement.
	self installOppositeUpdater.
	self installRemanentUpdater.
	self addChild: next.
	self next whenModeChangedDo: [ self reinstallStructure ].
	frontLayer := self defaultFrontLayer.
	self addChild: frontLayer as: #frontLayer.
	distributor := AlbEditorElementEventDistributor new.
	self frontLayer addEventHandler: distributor.
	self infinite addEventHandler: distributor.
	self matchParent.
	self installModeEventHandlers  

]

{ #category : #initialization }
AlbEditorElement >> installModeEventHandlers [

	self modeEventHandlersDo: [ :e | self removeEventHandler: e ].
	modeEventHandlers := self defaultModeEventHandlers.
	self modeEventHandlersDo: [ :e | 
		self frontLayer addEventHandler: (e
				 element: self infinite;
				 yourself) ]	

]

{ #category : #initialization }
AlbEditorElement >> installOppositeUpdater [

	oppositeUpdater ifNotNil: [ oppositeUpdater onUninstalledIn: self ].
	oppositeUpdater := AlbOppositeUpdater new.
	oppositeUpdater onInstalledIn: self
]

{ #category : #initialization }
AlbEditorElement >> installRemanentUpdater [

	remanentUpdater ifNotNil: [ remanentUpdater onUninstalledIn: self ].
	remanentUpdater := AlbRemanentUpdater new.
	remanentUpdater onInstalledIn: self
]

{ #category : #initialization }
AlbEditorElement >> installSelectionElement [

	selectionElement ifNotNil: [ :se | 
		se onUninstalledIn: self.
		se parentDo: [ se removeFromParent ] ].
	selectionElement := self mode selectionElement.
	selectionElement ifNotNil: [ :se | se onInstalledIn: self ]
]

{ #category : #initialization }
AlbEditorElement >> modeEventHandlersDo: aBlock [

	modeEventHandlers ifNotNil: [ modeEventHandlers do: aBlock ]
]

{ #category : #initialization }
AlbEditorElement >> reinstallStructure [

	self installSelectionElement.
	self installOppositeUpdater.
	self installRemanentUpdater.
	self installModeEventHandlers 
]

{ #category : #initialization }
AlbEditorElement >> selectionColor [

	^  (Color
		  r: 0.9530791788856305
		  g: 0.8084066471163245
		  b: 0.1906158357771261
		  alpha: 1.0)
]
