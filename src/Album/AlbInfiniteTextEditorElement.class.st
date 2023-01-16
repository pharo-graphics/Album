Class {
	#name : #AlbInfiniteTextEditorElement,
	#superclass : #OBlInfiniteElement,
	#traits : 'TObservable + TOBlLayoutResizable',
	#classTraits : 'TObservable classTrait + TOBlLayoutResizable classTrait',
	#instVars : [
		'#mode => ObservableSlot',
		'#selectionView',
		'#cursorStencil',
		'#wordStencil',
		'#modeEventHandlers',
		'#modeShortcuts'
	],
	#category : #'Album-UI'
}

{ #category : #'accessing - editor' }
AlbInfiniteTextEditorElement >> addEditorShortcut: aTextEditorInteraction [

	self editor addEditorShortcut: aTextEditorInteraction
]

{ #category : #converting }
AlbInfiniteTextEditorElement >> asScrollableElement [
	^ self
]

{ #category : #'private - view accessing' }
AlbInfiniteTextEditorElement >> atTextIndex: aTextIndex do: aBlock [

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

{ #category : #'view - configuration' }
AlbInfiniteTextEditorElement >> beEditable [

	self mode: AlbEditableMode new
]

{ #category : #'view - configuration' }
AlbInfiniteTextEditorElement >> beReadonlyWithSelection [

	self mode: AlbReadonlyWithSelectionMode new
]

{ #category : #'view - configuration' }
AlbInfiniteTextEditorElement >> beReadonlyWithoutSelection [

	self mode: AlbReadonlyWithoutSelectionMode new
]

{ #category : #'private - accessing editor' }
AlbInfiniteTextEditorElement >> cacheSize: aNumber [
	self editor cacheSize: aNumber
]

{ #category : #'accessing - cursor' }
AlbInfiniteTextEditorElement >> cursor [
	^ self editor cursor
]

{ #category : #'accessing - cursor' }
AlbInfiniteTextEditorElement >> cursorElement [

	^ cursorStencil currentCursorElement
]

{ #category : #'accessing - cursor' }
AlbInfiniteTextEditorElement >> cursorStencil [

	^ cursorStencil
]

{ #category : #'private - accessing editor' }
AlbInfiniteTextEditorElement >> cursors [
	<return: #AlbTextEditorCursor>
	^ self editor cursors
]

{ #category : #initialization }
AlbInfiniteTextEditorElement >> defaulTextEditor [

	^ AlbTextEditor new.
]

{ #category : #initialization }
AlbInfiniteTextEditorElement >> defaultBackground [

	^ BlBackground paint: Color transparent
]

{ #category : #initialization }
AlbInfiniteTextEditorElement >> defaultLayout [

	^ OBlInfiniteLinearLayout vertical
]

{ #category : #initialization }
AlbInfiniteTextEditorElement >> defaultMargin [

	^ BlInsets empty
]

{ #category : #initialization }
AlbInfiniteTextEditorElement >> defaultMode [

	^ AlbEditableMode new
]

{ #category : #initialization }
AlbInfiniteTextEditorElement >> defaultModeEventHandlers [

	^ self mode defaultEditorElementEventHandlers.

]

{ #category : #initialization }
AlbInfiniteTextEditorElement >> defaultModeShortcuts [

	^ self mode defaultShortcuts
]

{ #category : #initialization }
AlbInfiniteTextEditorElement >> defaultPadding [

	^ BlInsets empty
]

{ #category : #initialization }
AlbInfiniteTextEditorElement >> defaultRecycler [

	^ OBlInfiniteRecycler new
]

{ #category : #initialization }
AlbInfiniteTextEditorElement >> defaultSystemFontName [

	^ 'Source Code Pro'"AeFontManager defaultFontFamilyName"
]

{ #category : #initialization }
AlbInfiniteTextEditorElement >> defaultWordStencil [

	^ mode defaultWordStencil
]

{ #category : #'editor - operator' }
AlbInfiniteTextEditorElement >> deleter [
	<return: #AlbTextEditorDeleter>

	^ self editor deleter
]

{ #category : #'editor - operator' }
AlbInfiniteTextEditorElement >> deselecter [
	<return: #AlbTextEditorDeselecter>

	^ self editor deselecter
]

{ #category : #'private - accessing editor' }
AlbInfiniteTextEditorElement >> editor [
	<return: #AlbTextEditor>

	^ self dataSource
]

{ #category : #'private - accessing editor' }
AlbInfiniteTextEditorElement >> editor: aTextEditor [

	self dataSource: aTextEditor.

]

{ #category : #'focus accessing' }
AlbInfiniteTextEditorElement >> focusables: aBlFocusFinderCandidates along: aBlFocusSearchDirection [
	"Sort candidates according the bounds left, to ensure that rightmost are favored for up and down. "

	super
		focusables: aBlFocusFinderCandidates
		along: aBlFocusSearchDirection.
	aBlFocusFinderCandidates candidates sort: [ :a :b | 
		a bounds left > b bounds left ]
]

{ #category : #'private - geometry change' }
AlbInfiniteTextEditorElement >> geometryChanged [
	"My geometry has possibly changed as a result of extent change, scrolling or layout re-computing"
	
	self hasParent
		ifFalse: [ ^ self ].

	"re-compute the positionInEdtor that is used to compute and draw selection.
	Done here because during drawing, elements can be temporarly detached by the layout"
	self textPiecesAndTheirElementsDo: [ :piece :pieceElement | 
		pieceElement positionInEditor: (self localPointToMine: self position fromChild: pieceElement) ]
]

{ #category : #'focus testing' }
AlbInfiniteTextEditorElement >> hasFocus [
	^ self editor isFocused
]

{ #category : #'accessing - selection' }
AlbInfiniteTextEditorElement >> hasSelection [

	^ self selection isNotEmpty
]

{ #category : #accessing }
AlbInfiniteTextEditorElement >> infinite [

	^ self
]

{ #category : #initialization }
AlbInfiniteTextEditorElement >> initialize [
	
	self class initializeSlots: self.
	super initialize.
	
	self background: self defaultBackground.
	cursorStencil := AlbCursorStencil new.
	self editor: self defaulTextEditor.

	" action when  mode change (Observable slot) "
	self whenModeChangedDo: [ :m | self modeChanged ].
	mode := self defaultMode.
	self matchParent.
	self margin: self defaultMargin.
	self padding: self defaultPadding.
	self whenLayoutedDo: [ 
		self geometryChanged.
		self selectionChanged ].
	self elevation: ((BlRelativeElevation elevation: SmallInteger maxVal)).
]

{ #category : #'accessing - editor' }
AlbInfiniteTextEditorElement >> inputFilter: aTextEditorInputFilter [

	self editor inputFilter: aTextEditorInputFilter
]

{ #category : #'editor - operator' }
AlbInfiniteTextEditorElement >> inserter [
	<return: #AlbTextEditorInserter>

	^ self editor inserter
]

{ #category : #'private - view accessing' }
AlbInfiniteTextEditorElement >> layoutPositionsRange: anInterval [
	super layoutPositionsRange: anInterval.
	"copy this interval to the text editor (data source) to be used by AlbTextEditorCommand"
	self editor layoutPositionsRange: anInterval
]

{ #category : #'accessing - mode' }
AlbInfiniteTextEditorElement >> mode [

	<return: #BlText>

	^ mode
]

{ #category : #'accessing - mode' }
AlbInfiniteTextEditorElement >> mode: anEditabilityMode [

	mode = anEditabilityMode ifTrue: [ ^ self ].
	mode := anEditabilityMode
]

{ #category : #'view - configuration' }
AlbInfiniteTextEditorElement >> modeChanged [

	wordStencil := self defaultWordStencil.
	self editor whenEditionModeChanged: self mode.
	self setupModeEventHandlers.
	self setupModeShortcuts.
	self selectionView: self mode defaultSelectionView
]

{ #category : #'private - accessing editor' }
AlbInfiniteTextEditorElement >> modeEventHandlersDo: aBlock [

	modeEventHandlers ifNotNil: [ modeEventHandlers do: aBlock ]
]

{ #category : #'private - accessing editor' }
AlbInfiniteTextEditorElement >> modeShortcutsDo: aBlock [

	modeShortcuts ifNotNil: [ modeShortcuts do: aBlock ]
]

{ #category : #'event management' }
AlbInfiniteTextEditorElement >> mouseDownEvent: anEvent [
	self selectionChanged
]

{ #category : #'editor - operator' }
AlbInfiniteTextEditorElement >> navigator [
	<return: #AlbTextEditorNavigator>

	^ self editor navigator
]

{ #category : #'hooks - geometry' }
AlbInfiniteTextEditorElement >> onExtentChanged [
	super onExtentChanged.
	self geometryChanged.
	self selectionViewDo: [ :selView | "selView extentChangedIn: self" ]
	
]

{ #category : #'focus accessing' }
AlbInfiniteTextEditorElement >> onGotFocus [

	self editor onGotFocus.
	self cursorElement ifNotNil: [ :c | c onGotFocus ]
]

{ #category : #'focus accessing' }
AlbInfiniteTextEditorElement >> onLostFocus [

	self editor onLostFocus.
	self cursorElement ifNotNil: [:ce | ce onLostFocus]
]

{ #category : #'hooks - scrolling' }
AlbInfiniteTextEditorElement >> onScrolled: aPoint [
	super onScrolled: aPoint.
	self geometryChanged.
	self selectionViewDo: [ :selView | "selView selectionScrolled: aPoint in: self" ]


]

{ #category : #'private - view accessing' }
AlbInfiniteTextEditorElement >> piecesAndTheirElementsDo: aBlock [

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

{ #category : #'private - view accessing' }
AlbInfiniteTextEditorElement >> piecesAndTheirElementsWithinIndexInterval: anInterval do: aBlock [

	self piecesAndTheirElementsDo: [ :piece :pieceElement | 
		(piece textEnd < anInterval first or: [ piece textStart > (anInterval last)]) ifFalse: [ 
			aBlock value: piece value: pieceElement ] ]
]

{ #category : #'accessing - editor' }
AlbInfiniteTextEditorElement >> removeEditorShortcut: aTextEditorInteraction [
	self editor removeEditorShortcut: aTextEditorInteraction
]

{ #category : #scrolling }
AlbInfiniteTextEditorElement >> scrollToLast [
	"Scroll instantly to the last segment"
	
	self scrollToPosition: self editor segmentCollector computedSegmentsCount
]

{ #category : #'private - accessing editor' }
AlbInfiniteTextEditorElement >> segments [
	^ self editor segmentCollector segments
]

{ #category : #'accessing - selection' }
AlbInfiniteTextEditorElement >> selectedText [

	^ self editor selectedText
]

{ #category : #'editor - operator' }
AlbInfiniteTextEditorElement >> selecter [
	<return: #AlbTextEditorSelecter>

	^ self editor selecter
]

{ #category : #'accessing - selection' }
AlbInfiniteTextEditorElement >> selection [
	<return: #BlSelection>

	^ self editor selection
]

{ #category : #'event management' }
AlbInfiniteTextEditorElement >> selectionChanged [

	"self selectionViewDo: [ :selView | selView selectionChangedIn: self ]"
]

{ #category : #'accessing - selection' }
AlbInfiniteTextEditorElement >> selectionColor [

	^ Color
		  r: 0.9530791788856305
		  g: 0.8084066471163245
		  b: 0.1906158357771261
		  alpha: 1.0
]

{ #category : #'accessing - selection' }
AlbInfiniteTextEditorElement >> selectionView: anEditorSelectionView [

	"anEditorSelectionView ifNotNil: [ 
		anEditorSelectionView
			borderWidth: 2;
			borderColor: self selectionColor twiceDarker;
			selectionColor: self selectionColor ].
	selectionView := anEditorSelectionView"
]

{ #category : #'accessing - selection' }
AlbInfiniteTextEditorElement >> selectionViewDo: aBlock [
	^ selectionView ifNotNil: aBlock
]

{ #category : #'private - view accessing' }
AlbInfiniteTextEditorElement >> setRemanents [

	self selectionViewDo: [ :selView | "selView setRemanentsIn: self" ]
]

{ #category : #'private - accessing editor' }
AlbInfiniteTextEditorElement >> setupModeEventHandlers [

	self modeEventHandlersDo: [ :e | self removeEventHandler: e ].
	modeEventHandlers := self defaultModeEventHandlers.
	self modeEventHandlersDo: [ :e | 
		self addEventHandler: (e
				 element: self;
				 yourself) ]	

]

{ #category : #'private - accessing editor' }
AlbInfiniteTextEditorElement >> setupModeShortcuts [

	self modeShortcutsDo: [ :eachShortcut | self editor removeEditorShortcut: eachShortcut ].
	modeShortcuts := self defaultModeShortcuts.
	self modeShortcutsDo: [ :eachShortcut | self editor addEditorShortcut: eachShortcut ]
	
]

{ #category : #'accessing - text' }
AlbInfiniteTextEditorElement >> subTextOnScreen [
	
	| interval |
	interval := self subTextOnScreenInterval.
	^ self text from: (interval first max: 1) to: (interval last max: 0)

]

{ #category : #'accessing - text' }
AlbInfiniteTextEditorElement >> subTextOnScreenInterval [
	
	| holder first last |
	self text isEmpty ifTrue: [ ^ 0 to: -1 ].
	self hasChildren ifFalse: [ ^ 0 to: -1 ]. 
	holder := self elementHolderOf: self children first.
	first := holder textInterval first.
	holder := self elementHolderOf: self children last.
	last := holder textInterval last.
	^ first to: last

]

{ #category : #'accessing - text' }
AlbInfiniteTextEditorElement >> text [
	"Return a text I work with. All modifications to a text must be done from UI thread"
	<return: #BlText>

	^ self editor privateText
]

{ #category : #'accessing - text' }
AlbInfiniteTextEditorElement >> text: aText [

	aText == self editor privateText ifTrue: [ ^ self ].
	self editor privateText: aText asRopedText
]

{ #category : #'api - editor' }
AlbInfiniteTextEditorElement >> textEdited [

	self selectionViewDo: [ :selView | "selView textEditedIn: self" ]
]

{ #category : #'private - view accessing' }
AlbInfiniteTextEditorElement >> textElementsDo: aBlock [

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

{ #category : #'private - view accessing' }
AlbInfiniteTextEditorElement >> textElementsSelect: aSelectBlock [

	^ Array streamContents: [ :stream | 
		self childrenDo: [ :segmentElement | 
		| holder |
		"Use the holder here to find piece. needed for non text element element (instance of BlElement)"
		holder := self elementHolderOf: segmentElement.
		segmentElement childrenDo: [ :textElement | 
			holder
				pieceForElement: textElement
				ifPresent: [ :foundPiece | 
					(foundPiece isText and: [ aSelectBlock value: textElement ]) ifTrue: [ stream nextPut: textElement ] ]
				ifAbsent: [  ] ] ] ]
]

{ #category : #'private - accessing text' }
AlbInfiniteTextEditorElement >> textInternalRepresentationChanged [

	self editor processCursorAttributes.
	self editor updater
					 all;
					 update
]

{ #category : #'private - view accessing' }
AlbInfiniteTextEditorElement >> textPiecesAndTheirElementsDo: aBlock [

	self piecesAndTheirElementsDo: [ :piece :pieceElement | 
		piece isText ifTrue: [ aBlock value: piece value: pieceElement ] ]
]

{ #category : #'private - view accessing' }
AlbInfiniteTextEditorElement >> textPiecesAndTheirElementsWithinIndexInterval: anInterval do: aBlock [

	self textPiecesAndTheirElementsDo: [ :piece :pieceElement | 
		(piece textEnd < anInterval first or: [ piece textStart > (anInterval last)]) ifFalse: [ 
			aBlock value: piece value: pieceElement ] ]
]

{ #category : #'accessing - text' }
AlbInfiniteTextEditorElement >> textSnapshot [
	"Return a snaphost (copy) of the current text.
	I am safe to use from a non-UI thread because the returned text is independent from the
	current one and can be safely modified"
	<return: #BlText>

	^ self editor textSnapshot
]

{ #category : #'view - configuration' }
AlbInfiniteTextEditorElement >> whenModeChangedDo: aBlock [

	"set a block to perform after that the mode has been chanbed, and its action performed"

	self property: #mode whenChangedDo: aBlock
]

{ #category : #'view - configuration' }
AlbInfiniteTextEditorElement >> whenTextEditedDo: aBlock [

	self editor when: AlbTextEditedEvent do: aBlock
]

{ #category : #'view - configuration' }
AlbInfiniteTextEditorElement >> whenTextReplacedDo: aBlock [

	self editor when: AlbTextReplacedEvent do: aBlock
]

{ #category : #'view - configuration' }
AlbInfiniteTextEditorElement >> withRowNumbers [

	self withDecoration: AlbRowNumberDecoration
]

{ #category : #accessing }
AlbInfiniteTextEditorElement >> withoutCacheLimit [

	self editor withoutCacheLimit
]

{ #category : #'view - configuration' }
AlbInfiniteTextEditorElement >> withoutRowNumbers [

	self withoutDecoration: AlbRowNumberDecoration
]

{ #category : #'private - view accessing' }
AlbInfiniteTextEditorElement >> wordStencil [

	<return: #AlbTextWordPieceStencil>
	^ wordStencil
]

{ #category : #'private - view accessing' }
AlbInfiniteTextEditorElement >> wordStencil: aWordStencil [

	wordStencil := aWordStencil
]
