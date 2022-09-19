"
I represent a scrollable editor element. I support scrolling, selection and other various features.
"
Class {
	#name : #AlbEditorElement,
	#superclass : #OBlInfiniteElement,
	#instVars : [
		'hasFocus',
		'textStyleHandler',
		'selectionView'
	],
	#category : #'Album-UI'
}

{ #category : #converting }
AlbEditorElement >> asScrollableElement [
	^ self
]

{ #category : #accessing }
AlbEditorElement >> cursor [
	^ self editor cursor
]

{ #category : #initialization }
AlbEditorElement >> defaultLayout [
	^ OBlInfiniteLinearLayout vertical
]

{ #category : #initialization }
AlbEditorElement >> defaultRecycler [
	^ OBlInfiniteRecycler new
]

{ #category : #'ui - events managing' }
AlbEditorElement >> doubleClickEvent: anEvent [
	
]

{ #category : #'ui - events managing' }
AlbEditorElement >> dragEndEvent: anEvent [
	
]

{ #category : #'ui - events managing' }
AlbEditorElement >> dragEvent: anEvent [
	
]

{ #category : #'ui - events managing' }
AlbEditorElement >> dragStartEvent: anEvent [
	
]

{ #category : #accessing }
AlbEditorElement >> editor [
	<return: #AlbTextEditor>

	^ self dataSource
]

{ #category : #accessing }
AlbEditorElement >> editor: aTextEditor [
	self editor removeEventHandler: textStyleHandler.
	self dataSource: aTextEditor.
	self editor addEventHandler: textStyleHandler.
]

{ #category : #'focus testing' }
AlbEditorElement >> hasFocus [
	^ hasFocus or: [ self isFocused ]
]

{ #category : #initialization }
AlbEditorElement >> initialize [

	super initialize.
	selectionView := AlbEditorSelectionView new.
	hasFocus := false.
	self when: BlFocusInEvent do: [ hasFocus := true ].
	self when: BlFocusOutEvent do: [ hasFocus := false ].
	textStyleHandler := BlEventHandler
		                    on: AlbTextEditorTextStyleRequested
		                    do: [ :anEvent | 
		                    self editor stylerStrategy styleTextInEditorElement: self thenDo: anEvent afterAction ]
]

{ #category : #accessing }
AlbEditorElement >> layoutPositionsRange: anInterval [
	super layoutPositionsRange: anInterval.
	"copy this interval to the text editor (data source) to be used by AlbTextEditorCommand"
	self editor layoutPositionsRange: anInterval
]

{ #category : #'ui - events managing' }
AlbEditorElement >> mouseDownEvent: anEvent [
	
]

{ #category : #'hooks - layout' }
AlbEditorElement >> onLayoutDone [

	super onLayoutDone.
	self selectionChanged

]

{ #category : #'hooks - scrolling' }
AlbEditorElement >> onScrolled: aPoint [
	super onScrolled: aPoint.
	selectionView selectionScrolled: aPoint


]

{ #category : #scrolling }
AlbEditorElement >> scrollToLast [
	"Scroll instantly to the last segment"
	
	self scrollToPosition: self editor segmentCollector computedSegmentsCount
]

{ #category : #'ui - events managing' }
AlbEditorElement >> selectionChanged [
	selectionView selectionChangedIn: self
]

{ #category : #accessing }
AlbEditorElement >> selectionColor [

	^ Color
		  r: 0.9530791788856305
		  g: 0.8084066471163245
		  b: 0.1906158357771261
		  alpha: 1.0
]

{ #category : #'private - accessing' }
AlbEditorElement >> selectionRectangles [

	"return all selections rectangles from coordinate system of text elements with selection to my local coordinates"

	^ Array streamContents: [ :stream | 
		  self textElementsDo: [ :te | 
			  stream nextPutAll: (te selectionRectangles collect: [ :r | 
					   (self localBoundsToMine: (BlBounds fromRectangle: r) fromChild: te) translateBy: (0 @ te position y) negated ]) ] ]
]

{ #category : #'private - accessing' }
AlbEditorElement >> textElementsDo: aBlock [

	self childrenDo: [ :segmentElement | 
		| holder |
		"Use the holder here to find piece. needed for non text element element (instance of BlElement)"
		holder := self elementHolderOf: segmentElement.
		segmentElement childrenDo: [ :textElement | 
			holder
				pieceForElement: textElement
				ifPresent: [ :foundPiece | 
					foundPiece isText ifTrue: [ aBlock value: textElement ] ]
				ifAbsent: [  ] ] ]
]
