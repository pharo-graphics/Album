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

{ #category : #'private - accessing' }
AlbEditorElement >> atTextIndex: aTextIndex do: aBlock [

	" aBlock takes 2 arguments : the local text element and the local text index within the local text element"

	self childrenDo: [ :segmentElement | 
		| holder |
		holder := self elementHolderOf: segmentElement.
		segmentElement childrenDo: [ :element | 
			"Use the holder here to find piece. needed for non text element element (instance of BlElement)"
			holder
				 pieceForElement: element
				 ifPresent: [ :foundPiece | 
					(foundPiece isText and: [ element segmentPiece textInterval includes: aTextIndex ]) ifTrue: [ 
					"here, foundPiece can be ~~ element segmentPiece, it seems that the good one (uptodate) if found via children and not from the holder"
						aBlock
							value: element
							value: (element segmentPiece globalTextIndexToLocal: aTextIndex) ] ]
				 ifAbsent: [ ] ] ]
]

{ #category : #'editor - accessing' }
AlbEditorElement >> cacheSize: aNumber [
	self editor cacheSize: aNumber
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

{ #category : #'private - accessing' }
AlbEditorElement >> editorText [
	^ self editor text
]

{ #category : #'private - geometry change' }
AlbEditorElement >> geometryChanged [
	"My geometry has possibly changed as a result of extent change, scrolling or layout re-computing"
	
	"selectionView terminateUpdater."
	"re-compute the positionInEdtor that is used to compute and draw selection echo"
	self textPiecesAndTheirElementsDo: [ :piece :pieceElement | 
		pieceElement positionInEditor: (self localPointToMine: self position fromChild: pieceElement) ].


]

{ #category : #'focus testing' }
AlbEditorElement >> hasFocus [
	^ hasFocus or: [ self isFocused ]
]

{ #category : #initialization }
AlbEditorElement >> initialize [

	super initialize.
	selectionView := AlbEditorMainSelectionView new
		                 borderWidth: 2;
		                 borderColor: (self selectionColor alpha: 0.5);
		                 selectionColor: self selectionColor;
		                 yourself.
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

{ #category : #'geometry hooks' }
AlbEditorElement >> onExtentChanged [
	super onExtentChanged.
	self geometryChanged.
	selectionView extentChangedIn: self
	
]

{ #category : #'hooks - layout' }
AlbEditorElement >> onLayoutDone [

	super onLayoutDone.
	self geometryChanged.
	self selectionChanged
]

{ #category : #'hooks - scrolling' }
AlbEditorElement >> onScrolled: aPoint [
	super onScrolled: aPoint.
	self geometryChanged.
	selectionView selectionScrolled: aPoint in: self


]

{ #category : #'private - accessing' }
AlbEditorElement >> piecesAndTheirElementsDo: aBlock [

	self childrenDo: [ :segmentElement | 
		| holder |
		holder := self elementHolderOf: segmentElement.
		holder piecesAndTheirElementsDo: [ :piece :pieceElement | 
			aBlock value: piece value: pieceElement ] ].
	
"self childrenDo: [ :segmentElement | 
		| holder |
		holder := self elementHolderOf: segmentElement.
		segmentElement childrenDo: [ :element | 
			""Use the holder here to find piece. needed for non text element element (instance of BlElement)""
			(holder
				 pieceForElement: element
				 ifAbsent: [  ]) ifNotNil: [ :foundPiece | aBlock value: foundPiece value: element]]]"
]

{ #category : #'private - accessing' }
AlbEditorElement >> piecesAndTheirElementsWithinIndexInterval: anInterval do: aBlock [

	self piecesAndTheirElementsDo: [ :piece :pieceElement | 
		(piece textEnd < anInterval first or: [ piece textStart > (anInterval last)]) ifFalse: [ 
			aBlock value: piece value: pieceElement ] ]
]

{ #category : #scrolling }
AlbEditorElement >> scrollToLast [
	"Scroll instantly to the last segment"
	
	self scrollToPosition: self editor segmentCollector computedSegmentsCount
]

{ #category : #'editor - accessing' }
AlbEditorElement >> selectedText [
	^ self editor selectedText
]

{ #category : #'editor - accessing' }
AlbEditorElement >> selection [
	<return: #BlSelection>

	^ self editor selection
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
AlbEditorElement >> selectionEchoRectangles [

	"return all selections echo rectangles from coordinate system of text elements with selection to my local coordinates"

	^ Array streamContents: [ :stream | 
		  self textElementsDo: [ :te | 
			  stream nextPutAll: ((te highlightRectanglesOfCategory: #selectionEcho) collect: [ :r | 
					   (self localBoundsToMine: (BlBounds fromRectangle: r) fromChild: te) translateBy: (0 @ te position y) negated ]) ] ]
]

{ #category : #accessing }
AlbEditorElement >> selectionView [
	^ selectionView
]

{ #category : #'selection managing' }
AlbEditorElement >> setRemanents [
	selectionView setRemanentsIn: self
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

{ #category : #'private - accessing' }
AlbEditorElement >> textPiecesAndTheirElementsDo: aBlock [

	self piecesAndTheirElementsDo: [ :piece :pieceElement | 
		piece isText ifTrue: [ aBlock value: piece value: pieceElement ] ]
]

{ #category : #'private - accessing' }
AlbEditorElement >> textPiecesAndTheirElementsWithinIndexInterval: anInterval do: aBlock [

	self textPiecesAndTheirElementsDo: [ :piece :pieceElement | 
		(piece textEnd < anInterval first or: [ piece textStart > (anInterval last)]) ifFalse: [ 
			aBlock value: piece value: pieceElement ] ]
]

{ #category : #'editor - accessing' }
AlbEditorElement >> withoutCacheLimit [
	self editor withoutCacheLimit
]
