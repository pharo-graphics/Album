Class {
	#name : 'AlbTextPortionUpdater',
	#superclass : 'Object',
	#instVars : [
		'cursorMoveHandler',
		'selectionHandler',
		'extentChangeHandler',
		'scrollHandler',
		'updaterProcess',
		'textEditionHandler',
		'infiniteEditorChangeHandler',
		'portions'
	],
	#category : 'Album-UI-Text-Portion',
	#package : 'Album',
	#tag : 'UI-Text-Portion'
}

{ #category : 'infinite element changes' }
AlbTextPortionUpdater >> cursorMovedIn: anEditorElement [ 
]

{ #category : 'infinite element changes' }
AlbTextPortionUpdater >> extentChangedIn: anInfiniteElement [

	self updatePortionsIn: anInfiniteElement
]

{ #category : 'initialization' }
AlbTextPortionUpdater >> initialize [ 

	super initialize.
	portions := OrderedCollection new
]

{ #category : 'api - install/uninstall  hook' }
AlbTextPortionUpdater >> onInstalledIn: anEditorElement [


	cursorMoveHandler := BlEventHandler
		                     on: AlbCursorMovedEvent
		                     do: [ :evt | 
		                     self cursorMovedIn: anEditorElement ].
	selectionHandler := BlEventHandler 
								on: AlbSelectionChangedEvent 
								do: [ self selectionChangedIn: anEditorElement ].
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

{ #category : 'api - install/uninstall  hook' }
AlbTextPortionUpdater >> onUninstalledIn: anEditorElement [

	anEditorElement removeEventHandler: extentChangeHandler.
	anEditorElement editor removeEventHandler: textEditionHandler.
	anEditorElement editor removeEventHandler: cursorMoveHandler.
	anEditorElement editor removeEventHandler: selectionHandler.
	anEditorElement infinite removeEventHandler: scrollHandler.
	anEditorElement infinite removeEventHandler: infiniteEditorChangeHandler


]

{ #category : 'private' }
AlbTextPortionUpdater >> resetPortionsIn: anEditorElement [

	anEditorElement frontLayer removeChildren: portions.
	portions reset
]

{ #category : 'infinite element changes' }
AlbTextPortionUpdater >> scrollEventIn: anInfiniteElement [

	self updatePortionsIn: anInfiniteElement
]

{ #category : 'infinite element changes' }
AlbTextPortionUpdater >> selectionChangedIn: anInfiniteElement [
]

{ #category : 'private' }
AlbTextPortionUpdater >> setPortionsIn: anEditorElement [

	anEditorElement frontLayer addChildren: portions
]

{ #category : 'private' }
AlbTextPortionUpdater >> terminateUpdater [

	updaterProcess ifNotNil: #terminate.
	updaterProcess := nil
]

{ #category : 'infinite element changes' }
AlbTextPortionUpdater >> textEditedIn: anInfiniteElement [

	self updatePortionsIn: anInfiniteElement
]

{ #category : 'infinite element changes' }
AlbTextPortionUpdater >> updatePortionsIn: anEditorElement [

]
