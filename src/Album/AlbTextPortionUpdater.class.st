Class {
	#name : #AlbTextPortionUpdater,
	#superclass : #Object,
	#instVars : [
		'cursorMoveHandler',
		'selectionHandler',
		'extentChangeHandler',
		'scrollHandler',
		'monitor',
		'updaterProcess',
		'textEditionHandler',
		'infiniteEditorChangeHandler',
		'portions'
	],
	#category : #'Album-UI'
}

{ #category : #'infinite element changes' }
AlbTextPortionUpdater >> cursorMovedIn: anEditorElement [ 
]

{ #category : #'infinite element changes' }
AlbTextPortionUpdater >> extentChangedIn: anInfiniteElement [

	self updatePortionsIn: anInfiniteElement
]

{ #category : #initialization }
AlbTextPortionUpdater >> initialize [ 

	super initialize.
	monitor := Monitor new.
	portions := OrderedCollection new
]

{ #category : #'api - install/uninstall  hook' }
AlbTextPortionUpdater >> onInstalledIn: anEditorElement [


	cursorMoveHandler := BlEventHandler
		                     on: AlbCursorMovedEvent
		                     do: [ :evt | 
		                     self cursorMovedIn: anEditorElement ].
	selectionHandler := BlEventHandler on: AlbSelectionChangedEvent do: [ self selectionChangedIn: anEditorElement ].
	extentChangeHandler := BlEventHandler
		                       on: BlElementExtentChangedEvent
		                       do: [ :evt | 
		                       self extentChangedIn: anEditorElement ].

	scrollHandler := BlEventHandler
		                 on: BlElementScrolledEvent
		                 do: [ :evt | self scrollEventIn: anEditorElement ].


	textEditionHandler := BlEventHandler
		                      on: AlbTextEditedEvent
		                      do: [ :evt | 
		                      self textEditedIn: anEditorElement ].

	infiniteEditorChangeHandler := BlEventHandler
		                               on: AlbTextEditorReplacedEvent
		                               do: [ :event | 
			event previous ifNotNil: [ :prev | 			
				prev removeEventHandler: textEditionHandler ].
			event current ifNotNil: [ :curr | 
				curr addEventHandler: textEditionHandler ] ].

	anEditorElement addEventHandler: extentChangeHandler.
	anEditorElement editor addEventHandler: selectionHandler.
	anEditorElement editor addEventHandler: cursorMoveHandler.
	anEditorElement editor addEventHandler: textEditionHandler.
	anEditorElement infinite addEventHandler: scrollHandler.
	anEditorElement infinite addEventHandler: infiniteEditorChangeHandler
]

{ #category : #'api - install/uninstall  hook' }
AlbTextPortionUpdater >> onUninstalledIn: anEditorElement [

	anEditorElement removeEventHandler: extentChangeHandler.
	anEditorElement editor removeEventHandler: textEditionHandler.
	anEditorElement editor removeEventHandler: cursorMoveHandler.
	anEditorElement editor removeEventHandler: selectionHandler.
	anEditorElement infinite removeEventHandler: scrollHandler.
	anEditorElement infinite removeEventHandler: infiniteEditorChangeHandler


]

{ #category : #private }
AlbTextPortionUpdater >> resetPortions [

	| rems |
	rems := portions copy.
	rems do: [ :r | 
		r removeFromParent.
		portions remove: r ]
]

{ #category : #'infinite element changes' }
AlbTextPortionUpdater >> scrollEventIn: anInfiniteElement [

	self updatePortionsIn: anInfiniteElement
]

{ #category : #'infinite element changes' }
AlbTextPortionUpdater >> selectionChangedIn: anInfiniteElement [
]

{ #category : #private }
AlbTextPortionUpdater >> terminateUpdater [

	updaterProcess ifNotNil: #terminate.
	updaterProcess := nil
]

{ #category : #'infinite element changes' }
AlbTextPortionUpdater >> textEditedIn: anInfiniteElement [

	self updatePortionsIn: anInfiniteElement
]

{ #category : #private }
AlbTextPortionUpdater >> updateDelay [

	^ 50
]

{ #category : #'infinite element changes' }
AlbTextPortionUpdater >> updatePortionsIn: anEditorElement [

]
