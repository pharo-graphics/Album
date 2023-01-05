"
I'm an infinite element for text viewing and editing. I support scrolling, selection and other classical text editing features.
Text editing operations are driven by my data source (called textEditor). I also own a view model (viewModel) that serve as an interface for clients applicative model (such as a browser as an example).


"
Class {
	#name : #AlbEditorElement,
	#superclass : #OBlInfiniteElement,
	#traits : 'TObservable + TOBlLayoutResizable + TBlAnnouncerProvider',
	#classTraits : 'TObservable classTrait + TOBlLayoutResizable classTrait + TBlAnnouncerProvider classTrait',
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
AlbEditorElement >> addEditorShortcut: aTextEditorInteraction [

	self editor addEditorShortcut: aTextEditorInteraction
]

{ #category : #converting }
AlbEditorElement >> asScrollableElement [
	^ self
]

{ #category : #'private - view accessing' }
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

{ #category : #'view - configuration' }
AlbEditorElement >> beEditable [

	self mode: AlbEditableMode new
]

{ #category : #'view - configuration' }
AlbEditorElement >> beReadonlyWithSelection [

	self mode: AlbReadonlyWithSelectionMode new
]

{ #category : #'view - configuration' }
AlbEditorElement >> beReadonlyWithoutSelection [

	self mode: AlbReadonlyWithoutSelectionMode new
]

{ #category : #'private - accessing editor' }
AlbEditorElement >> cacheSize: aNumber [
	self editor cacheSize: aNumber
]

{ #category : #'accessing - cursor' }
AlbEditorElement >> cursor [
	^ self editor cursor
]

{ #category : #'accessing - cursor' }
AlbEditorElement >> cursorElement [

	^ cursorStencil currentCursorElement
]

{ #category : #'accessing - cursor' }
AlbEditorElement >> cursorStencil [

	^ cursorStencil
]

{ #category : #'private - accessing editor' }
AlbEditorElement >> cursors [
	<return: #AlbTextEditorCursor>
	^ self editor cursors
]

{ #category : #initialization }
AlbEditorElement >> defaulTextEditor [

	^ AlbTextEditor new.
]

{ #category : #initialization }
AlbEditorElement >> defaultBackground [

	^ BlBackground paint: Color white
]

{ #category : #initialization }
AlbEditorElement >> defaultLayout [

	^ OBlInfiniteLinearLayout vertical
]

{ #category : #initialization }
AlbEditorElement >> defaultMargin [

	^ BlInsets all: 1
]

{ #category : #initialization }
AlbEditorElement >> defaultMode [

	^ AlbEditableMode new
]

{ #category : #initialization }
AlbEditorElement >> defaultModeEventHandlers [

	^ self mode defaultEditorElementEventHandlers.

]

{ #category : #initialization }
AlbEditorElement >> defaultModeShortcuts [

	^ self mode defaultShortcuts
]

{ #category : #initialization }
AlbEditorElement >> defaultPadding [

	^ BlInsets
		  top: 2
		  left: 3
		  bottom: 2
		  right: 3
]

{ #category : #initialization }
AlbEditorElement >> defaultRecycler [
	^ OBlInfiniteRecycler new
]

{ #category : #initialization }
AlbEditorElement >> defaultSystemFontName [

	^ 'Source Code Pro'"AeFontManager defaultFontFamilyName"
]

{ #category : #initialization }
AlbEditorElement >> defaultWordStencil [

	^ mode defaultWordStencil
]

{ #category : #'editor - operator' }
AlbEditorElement >> deleter [
	<return: #AlbTextEditorDeleter>

	^ self editor deleter
]

{ #category : #'editor - operator' }
AlbEditorElement >> deselecter [
	<return: #AlbTextEditorDeselecter>

	^ self editor deselecter
]

{ #category : #'private - accessing editor' }
AlbEditorElement >> editor [
	<return: #AlbTextEditor>

	^ self dataSource
]

{ #category : #'private - accessing editor' }
AlbEditorElement >> editor: aTextEditor [

	self dataSource: aTextEditor.

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
	
	self hasParent
		ifFalse: [ ^ self ].

	"re-compute the positionInEdtor that is used to compute and draw selection.
	Done here because during drawing, elements can be temporarly detached by the layout"
	self textPiecesAndTheirElementsDo: [ :piece :pieceElement | 
		pieceElement positionInEditor: (self localPointToMine: self position fromChild: pieceElement) ]
]

{ #category : #'focus testing' }
AlbEditorElement >> hasFocus [
	^ self editor isFocused
]

{ #category : #'accessing - selection' }
AlbEditorElement >> hasSelection [

	^ self selection isNotEmpty
]

{ #category : #initialization }
AlbEditorElement >> initialize [

	self class initializeSlots: self.
	super initialize.

	privateAnnouncer := Announcer new.
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
AlbEditorElement >> inputFilter: aTextEditorInputFilter [

	self editor inputFilter: aTextEditorInputFilter
]

{ #category : #'editor - operator' }
AlbEditorElement >> inserter [
	<return: #AlbTextEditorInserter>

	^ self editor inserter
]

{ #category : #'private - view accessing' }
AlbEditorElement >> layoutPositionsRange: anInterval [
	super layoutPositionsRange: anInterval.
	"copy this interval to the text editor (data source) to be used by AlbTextEditorCommand"
	self editor layoutPositionsRange: anInterval
]

{ #category : #'accessing - mode' }
AlbEditorElement >> mode [

	<return: #BlText>

	^ mode
]

{ #category : #'accessing - mode' }
AlbEditorElement >> mode: anEditabilityMode [

	mode = anEditabilityMode ifTrue: [ ^ self ].
	mode := anEditabilityMode
]

{ #category : #'view - configuration' }
AlbEditorElement >> modeChanged [

	wordStencil := self defaultWordStencil.
	self editor whenEditionModeChanged: self mode.
	self setupModeEventHandlers.
	self setupModeShortcuts.
	self selectionView: self mode defaultSelectionView
]

{ #category : #'private - accessing editor' }
AlbEditorElement >> modeEventHandlersDo: aBlock [

	modeEventHandlers ifNotNil: [ modeEventHandlers do: aBlock ]
]

{ #category : #'private - accessing editor' }
AlbEditorElement >> modeShortcutsDo: aBlock [

	modeShortcuts ifNotNil: [ modeShortcuts do: aBlock ]
]

{ #category : #'event management' }
AlbEditorElement >> mouseDownEvent: anEvent [
	self selectionChanged
]

{ #category : #'editor - operator' }
AlbEditorElement >> navigator [
	<return: #AlbTextEditorNavigator>

	^ self editor navigator
]

{ #category : #'hooks - geometry' }
AlbEditorElement >> onExtentChanged [
	super onExtentChanged.
	self geometryChanged.
	self selectionViewDo: [ :selView | selView extentChangedIn: self ]
	
]

{ #category : #'focus accessing' }
AlbEditorElement >> onGotFocus [

	self editor onGotFocus.
	self cursorElement ifNotNil: [ :c | c onGotFocus ]
]

{ #category : #'focus accessing' }
AlbEditorElement >> onLostFocus [

	self editor onLostFocus.
	self cursorElement ifNotNil: [:ce | ce onLostFocus]
]

{ #category : #'hooks - scrolling' }
AlbEditorElement >> onScrolled: aPoint [
	super onScrolled: aPoint.
	self geometryChanged.
	self selectionViewDo: [ :selView | selView selectionScrolled: aPoint in: self ]


]

{ #category : #'private - view accessing' }
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

{ #category : #'private - view accessing' }
AlbEditorElement >> piecesAndTheirElementsWithinIndexInterval: anInterval do: aBlock [

	self piecesAndTheirElementsDo: [ :piece :pieceElement | 
		(piece textEnd < anInterval first or: [ piece textStart > (anInterval last)]) ifFalse: [ 
			aBlock value: piece value: pieceElement ] ]
]

{ #category : #'accessing - editor' }
AlbEditorElement >> removeEditorShortcut: aTextEditorInteraction [
	self editor removeEditorShortcut: aTextEditorInteraction
]

{ #category : #scrolling }
AlbEditorElement >> scrollToLast [
	"Scroll instantly to the last segment"
	
	self scrollToPosition: self editor segmentCollector computedSegmentsCount
]

{ #category : #'private - accessing editor' }
AlbEditorElement >> segments [
	^ self editor segmentCollector segments
]

{ #category : #'accessing - selection' }
AlbEditorElement >> selectedText [

	^ self editor selectedText
]

{ #category : #'editor - operator' }
AlbEditorElement >> selecter [
	<return: #AlbTextEditorSelecter>

	^ self editor selecter
]

{ #category : #'accessing - selection' }
AlbEditorElement >> selection [
	<return: #BlSelection>

	^ self editor selection
]

{ #category : #'event management' }
AlbEditorElement >> selectionChanged [

	self selectionViewDo: [ :selView | selView selectionChangedIn: self ]
]

{ #category : #'accessing - selection' }
AlbEditorElement >> selectionColor [

	^ Color
		  r: 0.9530791788856305
		  g: 0.8084066471163245
		  b: 0.1906158357771261
		  alpha: 1.0
]

{ #category : #'accessing - selection' }
AlbEditorElement >> selectionView: anEditorSelectionView [

	anEditorSelectionView ifNotNil: [ 
		anEditorSelectionView
			borderWidth: 2;
			borderColor: self selectionColor twiceDarker;
			selectionColor: self selectionColor ].
	selectionView := anEditorSelectionView
]

{ #category : #'accessing - selection' }
AlbEditorElement >> selectionViewDo: aBlock [
	^ selectionView ifNotNil: aBlock
]

{ #category : #'private - view accessing' }
AlbEditorElement >> setRemanents [

	self selectionViewDo: [ :selView | selView setRemanentsIn: self ]
]

{ #category : #'private - accessing editor' }
AlbEditorElement >> setupModeEventHandlers [

	self modeEventHandlersDo: [ :e | self removeEventHandler: e ].
	modeEventHandlers := self defaultModeEventHandlers.
	self modeEventHandlersDo: [ :e | 
		self addEventHandler: (e
				 element: self;
				 yourself) ]	

]

{ #category : #'private - accessing editor' }
AlbEditorElement >> setupModeShortcuts [

	self modeShortcutsDo: [ :eachShortcut | self editor removeEditorShortcut: eachShortcut ].
	modeShortcuts := self defaultModeShortcuts.
	self modeShortcutsDo: [ :eachShortcut | self editor addEditorShortcut: eachShortcut ]
	
]

{ #category : #'accessing - text' }
AlbEditorElement >> subTextOnScreen [
	
	| interval |
	interval := self subTextOnScreenInterval.
	^ self text from: (interval first max: 1) to: (interval last max: 0)

]

{ #category : #'accessing - text' }
AlbEditorElement >> subTextOnScreenInterval [
	
	| holder first last |
	self text isEmpty ifTrue: [ ^ 0 to: -1 ].
	holder := self elementHolderOf: self children first.
	first := holder textInterval first.
	holder := self elementHolderOf: self children last.
	last := holder textInterval last.
	^ first to: last

]

{ #category : #'accessing - text' }
AlbEditorElement >> text [
	"Return a text I work with. All modifications to a text must be done from UI thread"
	<return: #BlText>

	^ self editor privateText
]

{ #category : #'accessing - text' }
AlbEditorElement >> text: aText [

	aText == self editor privateText ifTrue: [ ^ self ].
	self editor privateText: aText asRopedText.
	self announce: (AlbTextReplaced new text: self text)
]

{ #category : #'api - editor' }
AlbEditorElement >> textEdited [

	self selectionViewDo: [ :selView | selView textEditedIn: self ].
	self announce: (AlbTextEdited new text: self text).

]

{ #category : #'private - view accessing' }
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

{ #category : #'private - accessing text' }
AlbEditorElement >> textInternalRepresentationChanged [

	self editor processCursorAttributes.
	self editor updater
					 all;
					 update
]

{ #category : #'private - view accessing' }
AlbEditorElement >> textPiecesAndTheirElementsDo: aBlock [

	self piecesAndTheirElementsDo: [ :piece :pieceElement | 
		piece isText ifTrue: [ aBlock value: piece value: pieceElement ] ]
]

{ #category : #'private - view accessing' }
AlbEditorElement >> textPiecesAndTheirElementsWithinIndexInterval: anInterval do: aBlock [

	self textPiecesAndTheirElementsDo: [ :piece :pieceElement | 
		(piece textEnd < anInterval first or: [ piece textStart > (anInterval last)]) ifFalse: [ 
			aBlock value: piece value: pieceElement ] ]
]

{ #category : #'accessing - text' }
AlbEditorElement >> textSnapshot [
	"Return a snaphost (copy) of the current text.
	I am safe to use from a non-UI thread because the returned text is independent from the
	current one and can be safely modified"
	<return: #BlText>

	^ self editor textSnapshot
]

{ #category : #'model - events' }
AlbEditorElement >> whenActionRequired: anActionRequiredAnnouncement [

	anActionRequiredAnnouncement value: self
]

{ #category : #'view - configuration' }
AlbEditorElement >> whenModeChangedDo: aBlock [

	"set a block to perform after that the mode has been chanbed, and its action performed"

	self property: #mode whenChangedDo: aBlock
]

{ #category : #'view - configuration' }
AlbEditorElement >> whenTextEditedDo: aBlock [

	self whenAnnouncement: AlbTextEdited do: aBlock
]

{ #category : #'view - configuration' }
AlbEditorElement >> whenTextReplacedDo: aBlock [

	self whenAnnouncement: AlbTextReplaced do: aBlock
]

{ #category : #'view - configuration' }
AlbEditorElement >> withRowNumbers [

	self withDecoration: AlbRowNumberDecoration
]

{ #category : #accessing }
AlbEditorElement >> withoutCacheLimit [

	self editor withoutCacheLimit
]

{ #category : #'view - configuration' }
AlbEditorElement >> withoutRowNumbers [

	self withoutDecoration: AlbRowNumberDecoration
]

{ #category : #'private - view accessing' }
AlbEditorElement >> wordStencil [

	<return: #AlbTextWordPieceStencil>
	^ wordStencil
]

{ #category : #'private - view accessing' }
AlbEditorElement >> wordStencil: aWordStencil [

	wordStencil := aWordStencil
]
