"
I represent a scrollable editor element. I support scrolling, selection and other various features.
"
Class {
	#name : #AlbEditorElement,
	#superclass : #OBlInfiniteElement,
	#traits : 'TOBlLayoutResizable',
	#classTraits : 'TOBlLayoutResizable classTrait',
	#instVars : [
		'textEditorHandlers',
		'selectionView',
		'cursorStencil'
	],
	#category : #'Album-UI'
}

{ #category : #'api - editor' }
AlbEditorElement >> addEditorShortcut: aTextEditorInteraction [
	self editor addEditorShortcut: aTextEditorInteraction
]

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

{ #category : #accessing }
AlbEditorElement >> cursorStencil [

	^ cursorStencil
]

{ #category : #'editor - accessing' }
AlbEditorElement >> cursors [
	<return: #AlbTextEditorCursor>
	^ self editor cursors
]

{ #category : #initialization }
AlbEditorElement >> defaulEditorModel [

	^ AlbEditorModel new.
]

{ #category : #initialization }
AlbEditorElement >> defaulTextEditor [

	^ AlbTextEditor new.
]

{ #category : #initialization }
AlbEditorElement >> defaultCodeFontName [

	^ BlFont defaultFontName
]

{ #category : #initialization }
AlbEditorElement >> defaultLayout [

	^ OBlInfiniteLinearLayout vertical
]

{ #category : #initialization }
AlbEditorElement >> defaultPaddings [

	^ BlInsets
		  top: 5
		  left: 1
		  bottom: 5
		  right: 5
]

{ #category : #initialization }
AlbEditorElement >> defaultRecycler [
	^ OBlInfiniteRecycler new
]

{ #category : #initialization }
AlbEditorElement >> defaultSelectionView [

	^ AlbEditorMainSelectionView new
		  borderWidth: 2;
		  borderColor: self selectionColor twiceDarker;
		  selectionColor: self selectionColor;
		  yourself
]

{ #category : #initialization }
AlbEditorElement >> defaultSystemFontName [

	^ 'Source Code Pro'"AeFontManager defaultFontFamilyName"
]

{ #category : #'editor - operations' }
AlbEditorElement >> deleter [
	<return: #AlbTextEditorDeleter>

	^ self editor deleter
]

{ #category : #'editor - operations' }
AlbEditorElement >> deselecter [
	<return: #AlbTextEditorDeselecter>

	^ self editor deselecter
]

{ #category : #accessing }
AlbEditorElement >> editor [
	<return: #AlbTextEditor>

	^ self dataSource
]

{ #category : #accessing }
AlbEditorElement >> editor: aTextEditor [

	textEditorHandlers do: [ :handler | self editor removeEventHandler: handler ].
	self dataSource: aTextEditor.
	textEditorHandlers do: [ :handler | self editor addEventHandler: handler ]
]

{ #category : #'editor - accessing' }
AlbEditorElement >> editorText [
	^ self editor text
]

{ #category : #'focus accessing' }
AlbEditorElement >> focusables: aBlFocusFinderCandidates along: aBlFocusSearchDirection [
	"Sort candidates according the bounds left, to ensure that rightmost are favored for up and down. "
	super
		focusables: aBlFocusFinderCandidates
		along: aBlFocusSearchDirection.
	aBlFocusFinderCandidates candidates sort: [ :a :b | 
		a bounds left > b bounds left ]
]

{ #category : #'private - geometry change' }
AlbEditorElement >> geometryChanged [
	"My geometry has possibly changed as a result of extent change, scrolling or layout re-computing"
	
	"re-compute the positionInEdtor that is used to compute and draw selection.
	Done here because during drawing, elements can be temporarly detached by the layout"
	self textPiecesAndTheirElementsDo: [ :piece :pieceElement | 
		pieceElement positionInEditor: (self localPointToMine: self position fromChild: pieceElement) ]
]

{ #category : #'focus testing' }
AlbEditorElement >> hasFocus [
	^ self editor isFocused
]

{ #category : #initialization }
AlbEditorElement >> initialize [

	super initialize.
	cursorStencil := AlbCursorStencil new.
	selectionView := self defaultSelectionView.
	textEditorHandlers := OrderedCollection new.
	textEditorHandlers add: (AlbTextEditorModeInstallHandler new element: self).
	textEditorHandlers add: (AlbTextEditorShortcutHandler new element: self).
	textEditorHandlers add: (AlbTextEditorTextStyleHandler new element: self).
	textEditorHandlers add: (AlbTextEditorTextReplaceHandler new element: self).
	textEditorHandlers add: (AlbTextEditorChangeHandler  new element: self).
	
	self padding: self defaultPaddings.
	self editor: self defaulTextEditor.
	self viewModel: self defaulEditorModel.
	self matchParent.

	

]

{ #category : #'api - editor' }
AlbEditorElement >> inputFilter: aTextEditorInputFilter [
	self editor inputFilter: aTextEditorInputFilter
]

{ #category : #'editor - operations' }
AlbEditorElement >> inserter [
	<return: #AlbTextEditorInserter>

	^ self editor inserter
]

{ #category : #'api - editor' }
AlbEditorElement >> isEditable [
	<return: #Boolean>

	^ self viewModel mode isEditable
]

{ #category : #'api - editor' }
AlbEditorElement >> isReadOnly [
	<return: #Boolean>

	^ self viewModel mode isReadOnly
]

{ #category : #'text - styling' }
AlbEditorElement >> launchTextStyle [

	self editor launchStyleFromElement: self
]

{ #category : #accessing }
AlbEditorElement >> layoutPositionsRange: anInterval [
	super layoutPositionsRange: anInterval.
	"copy this interval to the text editor (data source) to be used by AlbTextEditorCommand"
	self editor layoutPositionsRange: anInterval
]

{ #category : #accessing }
AlbEditorElement >> mode [

	<return: #AlbTextEditorMode>
	^ self viewModel mode
]

{ #category : #accessing }
AlbEditorElement >> mode: aTextEditorMode [

	^ self viewModel mode: aTextEditorMode
]

{ #category : #'model - events' }
AlbEditorElement >> modeChanged: aTextEditorMode [

	self editor editorMode: aTextEditorMode
]

{ #category : #'ui - events managing' }
AlbEditorElement >> mouseDownEvent: anEvent [
	self selectionChanged
]

{ #category : #'editor - operations' }
AlbEditorElement >> navigator [
	<return: #AlbTextEditorNavigator>

	^ self editor navigator
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
AlbEditorElement >> segments [
	^ self editor segmentCollector segments
]

{ #category : #'editor - accessing' }
AlbEditorElement >> selectedText [
	^ self editor selectedText
]

{ #category : #'editor - operations' }
AlbEditorElement >> selecter [
	<return: #AlbTextEditorSelecter>

	^ self editor selecter
]

{ #category : #'editor - accessing' }
AlbEditorElement >> selection [
	<return: #BlSelection>

	^ self editor selection
]

{ #category : #'ui - events managing' }
AlbEditorElement >> selectionChanged [
	self mode selectionChangedIn: self
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

{ #category : #'editor - accessing' }
AlbEditorElement >> styler [
	^ self viewModel styler
]

{ #category : #'editor - accessing' }
AlbEditorElement >> styler: aStyler [

	self viewModel styler: aStyler
]

{ #category : #'model - events' }
AlbEditorElement >> stylerChanged: aStyler [

	self editor styler: aStyler
]

{ #category : #'editor - accessing' }
AlbEditorElement >> subTextOnScreen [
	
	| interval |
	interval := self subTextOnScreenInterval.
	^ self editorText from: (interval first max: 1) to: (interval last max: 0)

]

{ #category : #'editor - accessing' }
AlbEditorElement >> subTextOnScreenInterval [
	
	| holder first last |
	self editorText isEmpty ifTrue: [ ^ 0 to: -1 ].
	holder := self elementHolderOf: self children first.
	first := holder textInterval first.
	holder := self elementHolderOf: self children last.
	last := holder textInterval last.
	^ first to: last

]

{ #category : #'editor - accessing' }
AlbEditorElement >> text [
	"Return a text I work with. All modifications to a text must be done from UI thread"
	<return: #BlText>

	^ self viewModel text
]

{ #category : #'editor - accessing' }
AlbEditorElement >> text: aBlText [

	self viewModel text: aBlText asRopedText
]

{ #category : #'model - events' }
AlbEditorElement >> textChanged: aText [

	self editor text: aText
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
AlbEditorElement >> textSnapshot [
	"Return a snaphost (copy) of the current text.
	I am safe to use from a non-UI thread because the returned text is independent from the
	current one and can be safely modified"
	<return: #BlText>

	^ self editor textSnapshot
]

{ #category : #'text - styling' }
AlbEditorElement >> textStyled: aStyledText [

	^ self viewModel textStyled: aStyledText
]

{ #category : #'accessing - decoration' }
AlbEditorElement >> withLineNumbers [

	self withDecoration: AlbLineNumberDecoration
]

{ #category : #'editor - accessing' }
AlbEditorElement >> withoutCacheLimit [
	self editor withoutCacheLimit
]

{ #category : #'accessing - decoration' }
AlbEditorElement >> withoutLineNumbers [

	self withoutDecoration: AlbLineNumberDecoration
]
