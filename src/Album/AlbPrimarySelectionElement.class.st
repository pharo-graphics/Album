Class {
	#name : #AlbPrimarySelectionElement,
	#superclass : #AlbSubtextElement,
	#instVars : [
		'focusHandler',
		'blurHandler',
		'selectionHandler',
		'editorChangeHandler'
	],
	#category : #'Album-UI'
}

{ #category : #private }
AlbPrimarySelectionElement >> computedAdjacentRectangles [

	"return all selections rectangles from coordinate system of text elements with selection to my local coordinates"

	^ Array streamContents: [ :stream | 
		  editorElement textElementsDo: [ :te | 
			  te selectionRectangles do: [ :r | 
					stream nextPut: ((editorElement localBoundsToMine: (BlBounds fromRectangle: r) fromChild: te) translateBy: 0 @ (te position y) negated ) ] ] ]
]

{ #category : #private }
AlbPrimarySelectionElement >> onGotFocus [

	self background: editorElement selectionColor.
	self border:	(BlBorder paint: editorElement selectionColor twiceDarker  width: self borderWidth)
]

{ #category : #'api - install/uninstall  hook' }
AlbPrimarySelectionElement >> onInstalledIn: anEditorElement [

	super onInstalledIn: anEditorElement.

	self background: anEditorElement selectionColor.
	self border: (BlBorderBuilder new 
		paint: anEditorElement selectionColor twiceDarker; 
		width: self borderWidth; 
		lineCap: BlStrokeLineCap round; 
		build).
	self outskirts: BlOutskirts centered.

	selectionHandler := BlEventHandler on: AlbSelectionChangedEvent do: [ self updateVertices ].
	focusHandler := BlEventHandler on: BlFocusEvent do: [ self onGotFocus ].
	blurHandler := BlEventHandler on: BlBlurEvent do: [ self onLostFocus ].

	editorChangeHandler := 
		BlEventHandler 
			on: AlbTextEditorReplacedEvent 
			do: [ :event | 
				event previous ifNotNil: [ :prev | prev removeEventHandler: selectionHandler ].
				event current ifNotNil: [ :curr | curr addEventHandler: selectionHandler ] ].

	anEditorElement editor addEventHandler: selectionHandler.
	anEditorElement infinite addEventHandler: editorChangeHandler.
	anEditorElement infinite addEventHandler: focusHandler.
	anEditorElement infinite addEventHandler: blurHandler
]

{ #category : #private }
AlbPrimarySelectionElement >> onLostFocus [

	self background: (editorElement selectionColor alpha: 0.1)
]

{ #category : #initialization }
AlbPrimarySelectionElement >> onUninstalledIn: anEditorElement [

	anEditorElement editor removeEventHandler: selectionHandler.
	anEditorElement infinite removeEventHandler: focusHandler.
	anEditorElement infinite removeEventHandler: blurHandler.
	anEditorElement infinite removeEventHandler: editorChangeHandler.
	
	super onUninstalledIn: anEditorElement

]

{ #category : #initialization }
AlbPrimarySelectionElement >> updateVertices [

	editorElement ifNil: [ ^ self ].
	self computedAdjacentRectangles
		ifEmpty: [ self parentDo: [ :p | self removeFromParent ] ]
		ifNotEmpty: [ :rects |
			self adjacentRectangles: rects.
			self hasParent ifFalse: [ editorElement addChild: self ] ]
]
