Class {
	#name : #AlbInfiniteElement,
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
AlbInfiniteElement >> addEditorShortcut: aTextEditorInteraction [

	self editor addEditorShortcut: aTextEditorInteraction
]

{ #category : #converting }
AlbInfiniteElement >> asScrollableElement [
	^ self
]

{ #category : #'private - view accessing' }
AlbInfiniteElement >> atTextIndex: aTextIndex do: aBlock [

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
AlbInfiniteElement >> beEditable [

	self mode: AlbEditableMode new
]

{ #category : #'view - configuration' }
AlbInfiniteElement >> beReadonlyWithSelection [

	self mode: AlbReadonlyWithSelectionMode new
]

{ #category : #'view - configuration' }
AlbInfiniteElement >> beReadonlyWithoutSelection [

	self mode: AlbReadonlyWithoutSelectionMode new
]

{ #category : #'private - accessing editor' }
AlbInfiniteElement >> cacheSize: aNumber [
	self editor cacheSize: aNumber
]

{ #category : #'accessing - cursor' }
AlbInfiniteElement >> cursor [
	^ self editor cursor
]

{ #category : #'accessing - cursor' }
AlbInfiniteElement >> cursorElement [

	^ cursorStencil currentCursorElement
]

{ #category : #'accessing - cursor' }
AlbInfiniteElement >> cursorStencil [

	^ cursorStencil
]

{ #category : #'private - accessing editor' }
AlbInfiniteElement >> cursors [
	<return: #AlbTextEditorCursor>
	^ self editor cursors
]

{ #category : #initialization }
AlbInfiniteElement >> defaulTextEditor [

	^ AlbTextEditor new.
]

{ #category : #initialization }
AlbInfiniteElement >> defaultBackground [

	^ BlBackground paint: Color transparent
]

{ #category : #initialization }
AlbInfiniteElement >> defaultLayout [

	^ OBlInfiniteLinearLayout vertical
]

{ #category : #initialization }
AlbInfiniteElement >> defaultMargin [

	^ BlInsets empty
]

{ #category : #initialization }
AlbInfiniteElement >> defaultMode [

	^ AlbEditableMode new
]

{ #category : #initialization }
AlbInfiniteElement >> defaultModeEventHandlers [

	^ self mode defaultEditorElementEventHandlers.

]

{ #category : #initialization }
AlbInfiniteElement >> defaultModeShortcuts [

	^ self mode defaultShortcuts
]

{ #category : #initialization }
AlbInfiniteElement >> defaultPadding [

	^ BlInsets empty
]

{ #category : #initialization }
AlbInfiniteElement >> defaultRecycler [

	^ OBlInfiniteRecycler new
]

{ #category : #initialization }
AlbInfiniteElement >> defaultSystemFontName [

	^ 'Source Code Pro'"AeFontManager defaultFontFamilyName"
]

{ #category : #initialization }
AlbInfiniteElement >> defaultWordStencil [

	^ mode defaultWordStencil
]

{ #category : #'editor - operator' }
AlbInfiniteElement >> deleter [
	<return: #AlbTextEditorDeleter>

	^ self editor deleter
]

{ #category : #'editor - operator' }
AlbInfiniteElement >> deselecter [
	<return: #AlbTextEditorDeselecter>

	^ self editor deselecter
]

{ #category : #'private - accessing editor' }
AlbInfiniteElement >> editor [
	<return: #AlbTextEditor>

	^ self dataSource
]

{ #category : #'private - accessing editor' }
AlbInfiniteElement >> editor: aTextEditor [

	self dataSource: aTextEditor.

]

{ #category : #'focus accessing' }
AlbInfiniteElement >> focusables: aBlFocusFinderCandidates along: aBlFocusSearchDirection [
	"Sort candidates according the bounds left, to ensure that rightmost are favored for up and down. "

	super
		focusables: aBlFocusFinderCandidates
		along: aBlFocusSearchDirection.
	aBlFocusFinderCandidates candidates sort: [ :a :b | 
		a bounds left > b bounds left ]
]

{ #category : #'private - geometry change' }
AlbInfiniteElement >> geometryChanged [
	"My geometry has possibly changed as a result of extent change, scrolling or layout re-computing"
	
	self hasParent
		ifFalse: [ ^ self ].

	"re-compute the positionInEdtor that is used to compute and draw selection.
	Done here because during drawing, elements can be temporarly detached by the layout"
	self textPiecesAndTheirElementsDo: [ :piece :pieceElement | 
		pieceElement positionInEditor: (self localPointToMine: self position fromChild: pieceElement) ]
]

{ #category : #'focus testing' }
AlbInfiniteElement >> hasFocus [
	^ self editor isFocused
]

{ #category : #'accessing - selection' }
AlbInfiniteElement >> hasSelection [

	^ self selection isNotEmpty
]

{ #category : #initialization }
AlbInfiniteElement >> initialize [
	
	self class initializeSlots: self.
	super initialize.
	
	self background: self defaultBackground.
	cursorStencil := AlbCursorStencil new.
	self padding: self defaultPadding.
	self editor: self defaulTextEditor.

	" action when  mode change (Observable slot) "
	self whenModeChangedDo: [ :m | self modeChanged ].
	mode := self defaultMode.
	self matchParent.
	self margin: self defaultMargin.
	self padding: self defaultPadding.
	self whenLayoutedDo: [ 
		self geometryChanged.
		self selectionChanged ]
]

{ #category : #'accessing - editor' }
AlbInfiniteElement >> inputFilter: aTextEditorInputFilter [

	self editor inputFilter: aTextEditorInputFilter
]

{ #category : #'editor - operator' }
AlbInfiniteElement >> inserter [
	<return: #AlbTextEditorInserter>

	^ self editor inserter
]

{ #category : #'private - view accessing' }
AlbInfiniteElement >> layoutPositionsRange: anInterval [
	super layoutPositionsRange: anInterval.
	"copy this interval to the text editor (data source) to be used by AlbTextEditorCommand"
	self editor layoutPositionsRange: anInterval
]

{ #category : #'accessing - mode' }
AlbInfiniteElement >> mode [

	<return: #BlText>

	^ mode
]

{ #category : #'accessing - mode' }
AlbInfiniteElement >> mode: anEditabilityMode [

	mode = anEditabilityMode ifTrue: [ ^ self ].
	mode := anEditabilityMode
]

{ #category : #'view - configuration' }
AlbInfiniteElement >> modeChanged [

	wordStencil := self defaultWordStencil.
	self editor whenEditionModeChanged: self mode.
	self setupModeEventHandlers.
	self setupModeShortcuts.
	self selectionView: self mode defaultSelectionView
]

{ #category : #'private - accessing editor' }
AlbInfiniteElement >> modeEventHandlersDo: aBlock [

	modeEventHandlers ifNotNil: [ modeEventHandlers do: aBlock ]
]

{ #category : #'private - accessing editor' }
AlbInfiniteElement >> modeShortcutsDo: aBlock [

	modeShortcuts ifNotNil: [ modeShortcuts do: aBlock ]
]

{ #category : #'event management' }
AlbInfiniteElement >> mouseDownEvent: anEvent [
	self selectionChanged
]

{ #category : #'editor - operator' }
AlbInfiniteElement >> navigator [
	<return: #AlbTextEditorNavigator>

	^ self editor navigator
]

{ #category : #'hooks - geometry' }
AlbInfiniteElement >> onExtentChanged [
	super onExtentChanged.
	self geometryChanged.
	self selectionViewDo: [ :selView | selView extentChangedIn: self ]
	
]

{ #category : #'focus accessing' }
AlbInfiniteElement >> onGotFocus [

	self editor onGotFocus.
	self cursorElement ifNotNil: [ :c | c onGotFocus ]
]

{ #category : #'focus accessing' }
AlbInfiniteElement >> onLostFocus [

	self editor onLostFocus.
	self cursorElement ifNotNil: [:ce | ce onLostFocus]
]

{ #category : #'hooks - scrolling' }
AlbInfiniteElement >> onScrolled: aPoint [
	super onScrolled: aPoint.
	self geometryChanged.
	self selectionViewDo: [ :selView | selView selectionScrolled: aPoint in: self ]


]

{ #category : #'private - view accessing' }
AlbInfiniteElement >> piecesAndTheirElementsDo: aBlock [

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
AlbInfiniteElement >> piecesAndTheirElementsWithinIndexInterval: anInterval do: aBlock [

	self piecesAndTheirElementsDo: [ :piece :pieceElement | 
		(piece textEnd < anInterval first or: [ piece textStart > (anInterval last)]) ifFalse: [ 
			aBlock value: piece value: pieceElement ] ]
]

{ #category : #'accessing - editor' }
AlbInfiniteElement >> removeEditorShortcut: aTextEditorInteraction [
	self editor removeEditorShortcut: aTextEditorInteraction
]

{ #category : #scrolling }
AlbInfiniteElement >> scrollToLast [
	"Scroll instantly to the last segment"
	
	self scrollToPosition: self editor segmentCollector computedSegmentsCount
]

{ #category : #'private - accessing editor' }
AlbInfiniteElement >> segments [
	^ self editor segmentCollector segments
]

{ #category : #'accessing - selection' }
AlbInfiniteElement >> selectedText [

	^ self editor selectedText
]

{ #category : #'editor - operator' }
AlbInfiniteElement >> selecter [
	<return: #AlbTextEditorSelecter>

	^ self editor selecter
]

{ #category : #'accessing - selection' }
AlbInfiniteElement >> selection [
	<return: #BlSelection>

	^ self editor selection
]

{ #category : #'event management' }
AlbInfiniteElement >> selectionChanged [

	self selectionViewDo: [ :selView | selView selectionChangedIn: self ]
]

{ #category : #'accessing - selection' }
AlbInfiniteElement >> selectionColor [

	^ Color
		  r: 0.9530791788856305
		  g: 0.8084066471163245
		  b: 0.1906158357771261
		  alpha: 1.0
]

{ #category : #'accessing - selection' }
AlbInfiniteElement >> selectionView: anEditorSelectionView [

	anEditorSelectionView ifNotNil: [ 
		anEditorSelectionView
			borderWidth: 2;
			borderColor: self selectionColor twiceDarker;
			selectionColor: self selectionColor ].
	selectionView := anEditorSelectionView
]

{ #category : #'accessing - selection' }
AlbInfiniteElement >> selectionViewDo: aBlock [
	^ selectionView ifNotNil: aBlock
]

{ #category : #'private - view accessing' }
AlbInfiniteElement >> setRemanents [

	self selectionViewDo: [ :selView | selView setRemanentsIn: self ]
]

{ #category : #'private - accessing editor' }
AlbInfiniteElement >> setupModeEventHandlers [

	self modeEventHandlersDo: [ :e | self removeEventHandler: e ].
	modeEventHandlers := self defaultModeEventHandlers.
	self modeEventHandlersDo: [ :e | 
		self addEventHandler: (e
				 element: self;
				 yourself) ]	

]

{ #category : #'private - accessing editor' }
AlbInfiniteElement >> setupModeShortcuts [

	self modeShortcutsDo: [ :eachShortcut | self editor removeEditorShortcut: eachShortcut ].
	modeShortcuts := self defaultModeShortcuts.
	self modeShortcutsDo: [ :eachShortcut | self editor addEditorShortcut: eachShortcut ]
	
]

{ #category : #'accessing - text' }
AlbInfiniteElement >> subTextOnScreen [
	
	| interval |
	interval := self subTextOnScreenInterval.
	^ self text from: (interval first max: 1) to: (interval last max: 0)

]

{ #category : #'accessing - text' }
AlbInfiniteElement >> subTextOnScreenInterval [
	
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
AlbInfiniteElement >> text [
	"Return a text I work with. All modifications to a text must be done from UI thread"
	<return: #BlText>

	^ self editor privateText
]

{ #category : #'accessing - text' }
AlbInfiniteElement >> text: aText [

	aText == self editor privateText ifTrue: [ ^ self ].
	self editor privateText: aText asRopedText
]

{ #category : #'api - editor' }
AlbInfiniteElement >> textEdited [

	self selectionViewDo: [ :selView | selView textEditedIn: self ]
]

{ #category : #'private - view accessing' }
AlbInfiniteElement >> textElementsDo: aBlock [

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
AlbInfiniteElement >> textElementsSelect: aSelectBlock [

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
AlbInfiniteElement >> textInternalRepresentationChanged [

	self editor processCursorAttributes.
	self editor updater
					 all;
					 update
]

{ #category : #'private - view accessing' }
AlbInfiniteElement >> textPiecesAndTheirElementsDo: aBlock [

	self piecesAndTheirElementsDo: [ :piece :pieceElement | 
		piece isText ifTrue: [ aBlock value: piece value: pieceElement ] ]
]

{ #category : #'private - view accessing' }
AlbInfiniteElement >> textPiecesAndTheirElementsWithinIndexInterval: anInterval do: aBlock [

	self textPiecesAndTheirElementsDo: [ :piece :pieceElement | 
		(piece textEnd < anInterval first or: [ piece textStart > (anInterval last)]) ifFalse: [ 
			aBlock value: piece value: pieceElement ] ]
]

{ #category : #'accessing - text' }
AlbInfiniteElement >> textSnapshot [
	"Return a snaphost (copy) of the current text.
	I am safe to use from a non-UI thread because the returned text is independent from the
	current one and can be safely modified"
	<return: #BlText>

	^ self editor textSnapshot
]

{ #category : #'model - events' }
AlbInfiniteElement >> whenActionRequired: anActionRequiredAnnouncement [

	anActionRequiredAnnouncement value: self
]

{ #category : #'view - configuration' }
AlbInfiniteElement >> whenModeChangedDo: aBlock [

	"set a block to perform after that the mode has been chanbed, and its action performed"

	self property: #mode whenChangedDo: aBlock
]

{ #category : #'view - configuration' }
AlbInfiniteElement >> whenTextEditedDo: aBlock [

	self editor when: AlbTextEditedEvent do: aBlock
]

{ #category : #'view - configuration' }
AlbInfiniteElement >> whenTextReplacedDo: aBlock [

	self editor when: AlbTextReplacedEvent do: aBlock
]

{ #category : #'view - configuration' }
AlbInfiniteElement >> withRowNumbers [

	self withDecoration: AlbRowNumberDecoration
]

{ #category : #accessing }
AlbInfiniteElement >> withoutCacheLimit [

	self editor withoutCacheLimit
]

{ #category : #'view - configuration' }
AlbInfiniteElement >> withoutRowNumbers [

	self withoutDecoration: AlbRowNumberDecoration
]

{ #category : #'private - view accessing' }
AlbInfiniteElement >> wordStencil [

	<return: #AlbTextWordPieceStencil>
	^ wordStencil
]

{ #category : #'private - view accessing' }
AlbInfiniteElement >> wordStencil: aWordStencil [

	wordStencil := aWordStencil
]
