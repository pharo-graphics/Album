Class {
	#name : #AlbSelectionElement,
	#superclass : #AlbTextPortionElement,
	#instVars : [
		'focusHandler',
		'blurHandler',
		'scrollHandler',
		'extentHandler',
		'editorChangeHandler',
		'selectionHandler'
	],
	#category : #'Album-UI'
}

{ #category : #'private - infinite element changes' }
AlbSelectionElement >> extentChangedIn: anInfiniteElement [

	self updateMainSelectionVerticesIn: anInfiniteElement
]

{ #category : #'private - focus' }
AlbSelectionElement >> onGotFocusIn: anEditorElement [ 

	self background: anEditorElement selectionColor.
	self border:	(BlBorder paint: anEditorElement selectionColor twiceDarker  width: self borderWidth)
]

{ #category : #initialization }
AlbSelectionElement >> onInstalledIn: anEditorElement [

	self background: anEditorElement selectionColor.
	self border: (BlBorder paint: anEditorElement selectionColor twiceDarker width: self borderWidth).
	
	selectionHandler := BlEventHandler on: AlbSelectionChangedEvent do: [ self selectionChangedIn: anEditorElement ].
	extentHandler := BlEventHandler on: BlElementExtentChangedEvent do: [ self extentChangedIn: anEditorElement ].
	scrollHandler := BlEventHandler on: BlElementScrolledEvent do: [ :event | self selectionScrolled: event delta in: anEditorElement].
	focusHandler := BlEventHandler on: BlFocusEvent do: [ self onGotFocusIn: anEditorElement ].
	blurHandler := BlEventHandler on: BlBlurEvent do: [ self onLostFocusIn: anEditorElement ].

	editorChangeHandler := 
		BlEventHandler 
			on: AlbTextEditorReplacedEvent 
			do: [ :event | 
				event previous ifNotNil: [ :prev | prev removeEventHandler: selectionHandler ].
				event current ifNotNil: [ :curr | curr addEventHandler: selectionHandler ] ].

	anEditorElement editor addEventHandler: selectionHandler.
	anEditorElement addEventHandler: extentHandler.
	anEditorElement infinite addEventHandler: scrollHandler.
	anEditorElement infinite addEventHandler: focusHandler.
	anEditorElement infinite addEventHandler: blurHandler.
	anEditorElement infinite addEventHandler: editorChangeHandler

]

{ #category : #'private - focus' }
AlbSelectionElement >> onLostFocusIn: anEditorElement [  

	| c |
	c := Color lightGray alpha: 0.2.
	self background: c.
	self border:	(BlBorder paint: c twiceDarker  width: self borderWidth)
]

{ #category : #initialization }
AlbSelectionElement >> onUninstalledIn: anEditorElement [

	anEditorElement editor removeEventHandler: selectionHandler.
	anEditorElement removeEventHandler: extentHandler.
	anEditorElement infinite removeEventHandler: scrollHandler.
	anEditorElement infinite removeEventHandler: focusHandler.
	anEditorElement infinite removeEventHandler: blurHandler.
	anEditorElement infinite removeEventHandler: editorChangeHandler

]

{ #category : #'private - infinite element changes' }
AlbSelectionElement >> selectionChangedIn: anInfiniteElement [

	self updateMainSelectionVerticesIn: anInfiniteElement.
]

{ #category : #'private - infinite element changes' }
AlbSelectionElement >> selectionRectanglesIn: anInfiniteElement [

	"return all selections rectangles from coordinate system of text elements with selection to my local coordinates"

	^ Array streamContents: [ :stream | 
		  anInfiniteElement textElementsDo: [ :te | 
			  te selectionRectangles do: [ :r | 
					stream nextPut: ((anInfiniteElement localBoundsToMine: (BlBounds fromRectangle: r) fromChild: te) translateBy: 0 @ (te position y) negated ) ] ] ]
]

{ #category : #'private - infinite element changes' }
AlbSelectionElement >> selectionScrolled: aPoint in: anInfiniteElement [

	self updateMainSelectionVerticesIn: anInfiniteElement
]

{ #category : #'private - infinite element changes' }
AlbSelectionElement >> updateMainSelectionVerticesIn: anInfiniteElement [

	anInfiniteElement ifNil: [ ^ self ].
	(self selectionRectanglesIn: anInfiniteElement)
		ifEmpty: [ self parentDo: [ :p | self removeFromParent ] ]
		ifNotEmpty: [ :rects |
			self adjacentRectangles: rects.
			self hasParent ifFalse: [ anInfiniteElement addChild: self ] ]
]
