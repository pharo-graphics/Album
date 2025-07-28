Class {
	#name : #AlbInfiniteEditorElement,
	#superclass : #BlInfiniteElement,
	#traits : 'TBlLayoutResizable',
	#classTraits : 'TBlLayoutResizable classTrait',
	#instVars : [
		'mode',
		'cursorElement',
		'wordStencil',
		'modeEventHandlers',
		'modeShortcuts'
	],
	#category : #'Album-UI'
}

{ #category : #'accessing - editor' }
AlbInfiniteEditorElement >> addEditorShortcut: aTextEditorInteraction [

	self editor addEditorShortcut: aTextEditorInteraction
]

{ #category : #converting }
AlbInfiniteEditorElement >> asScrollableElement [
	^ self
]

{ #category : #'private - view accessing' }
AlbInfiniteEditorElement >> atTextIndex: aTextIndex do: aBlock [

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
AlbInfiniteEditorElement >> beEditable [

	self mode: AlbEditableMode new
]

{ #category : #'view - configuration' }
AlbInfiniteEditorElement >> beReadonlyWithSelection [

	self mode: AlbReadonlyWithSelectionMode new
]

{ #category : #'view - configuration' }
AlbInfiniteEditorElement >> beReadonlyWithoutSelection [

	self mode: AlbReadonlyWithoutSelectionMode new
]

{ #category : #'private - accessing editor' }
AlbInfiniteEditorElement >> cacheSize: aNumber [
	self editor cacheSize: aNumber
]

{ #category : #completion }
AlbInfiniteEditorElement >> completeWordSuffixFromString: aString [

	| insertPos wordStart prefixSize suffix |
	insertPos := self cursor position.
	self navigator
		moveToStartPreviousWord;
		apply.
	wordStart := self cursor position.
	prefixSize := insertPos - wordStart.
	suffix := aString copyFrom: prefixSize + 1 to: aString size.
	self navigator
		moveBy: prefixSize;
		apply.
	self inserter
		text: suffix;
		apply.
	self selecter
		from: insertPos to: insertPos + suffix size;
		apply
]

{ #category : #'accessing - cursor' }
AlbInfiniteEditorElement >> cursor [
	^ self editor cursor
]

{ #category : #'accessing - cursor' }
AlbInfiniteEditorElement >> cursorBackground [

	^ self cursorElement background
]

{ #category : #'accessing - cursor' }
AlbInfiniteEditorElement >> cursorBackground: aBackground [

	self cursorElement focusedBackground: aBackground
]

{ #category : #'accessing - cursor' }
AlbInfiniteEditorElement >> cursorColor: aColor [

	self cursorBackground: aColor
]

{ #category : #'accessing - cursor' }
AlbInfiniteEditorElement >> cursorElement [

	^ cursorElement
]

{ #category : #'private - accessing editor' }
AlbInfiniteEditorElement >> cursors [
	<return: #AlbTextEditorCursor>
	^ self editor cursors
]

{ #category : #initialization }
AlbInfiniteEditorElement >> defaultCursorBackground [

	^ Color red
]

{ #category : #initialization }
AlbInfiniteEditorElement >> defaultDataSource [ 

	^ self defaultTextEditor 
]

{ #category : #initialization }
AlbInfiniteEditorElement >> defaultLayout [

	^ BlInfiniteLinearLayout vertical
]

{ #category : #initialization }
AlbInfiniteEditorElement >> defaultMode [

	^ AlbEditableMode new
]

{ #category : #initialization }
AlbInfiniteEditorElement >> defaultModeEventHandlers [

	^ self mode defaultEditorElementEventHandlers.

]

{ #category : #initialization }
AlbInfiniteEditorElement >> defaultModeShortcuts [

	
	^ self mode defaultShortcuts
]

{ #category : #initialization }
AlbInfiniteEditorElement >> defaultRecycler [

	^ BlInfiniteRecycler new
]

{ #category : #initialization }
AlbInfiniteEditorElement >> defaultTextEditor [

	^ AlbTextEditor new.
]

{ #category : #initialization }
AlbInfiniteEditorElement >> defaultWordStencil [

	^ mode defaultWordStencil
]

{ #category : #'editor - operator' }
AlbInfiniteEditorElement >> deleter [
	<return: #AlbTextEditorDeleter>

	^ self editor deleter
]

{ #category : #'editor - operator' }
AlbInfiniteEditorElement >> deselecter [
	<return: #AlbTextEditorDeselecter>

	^ self editor deselecter
]

{ #category : #'private - accessing editor' }
AlbInfiniteEditorElement >> editor [
	<return: #AlbTextEditor>

	^ self dataSource
]

{ #category : #'private - accessing editor' }
AlbInfiniteEditorElement >> editor: aTextEditor [

	^ (BlImmutableObjectChangeError object: self) signal
]

{ #category : #'private - accessing editor' }
AlbInfiniteEditorElement >> editorDo: aBlock [

	aBlock value: self editor
]

{ #category : #'accessing - text' }
AlbInfiniteEditorElement >> enlargedSubTextOnScreen [
	
	| interval |
	interval := self subTextOnScreenInterval.
	
	^ self text 
		from: ((interval first - interval size) max: 1) 
		to: (((interval last + interval size) max: 0) min: self text size)

]

{ #category : #'focus accessing' }
AlbInfiniteEditorElement >> focusables: aBlFocusFinderCandidates along: aBlFocusSearchDirection [
	"Sort candidates according the bounds left, to ensure that rightmost are favored for up and down. "

	super
		focusables: aBlFocusFinderCandidates
		along: aBlFocusSearchDirection.
		
	self flag: 'Added then removed because it does not work if the cursor is at the left side'.		
	"aBlFocusFinderCandidates candidates sort: [ :a :b | 
		a bounds left > b bounds left ]"
]

{ #category : #'private - geometry change' }
AlbInfiniteEditorElement >> geometryChanged [
	"My geometry has possibly changed as a result of extent change, scrolling or layout re-computing"
	
	self hasParent
		ifFalse: [ ^ self ].

	"re-compute the positionInEdtor that is used to compute and draw selection.
	Done here because during drawing, elements can be temporarly detached by the layout"
	self textPiecesAndTheirElementsDo: [ :piece :pieceElement | 
		pieceElement positionInEditor: (self localPointToMine: self position fromChild: pieceElement) ]
]

{ #category : #'focus testing' }
AlbInfiniteEditorElement >> hasFocus [
	^ self editor isFocused
]

{ #category : #'accessing - selection' }
AlbInfiniteEditorElement >> hasSelection [

	^ self selection isNotEmpty
]

{ #category : #accessing }
AlbInfiniteEditorElement >> infinite [

	^ self
]

{ #category : #initialization }
AlbInfiniteEditorElement >> initialize [

	super initialize.
	self mode: self defaultMode.
	self matchParent
]

{ #category : #initialization }
AlbInfiniteEditorElement >> initializeCursorElement [
	"Pay attention: a CursorElement ** must be a unique ** inside an editor element. 
	If not, dbl clicking will not work because the target of the first click may 
	be different from the one of the second click"

	cursorElement ifNotNil: [ cursorElement removeFromParent ].
	cursorElement := AlbCursorElement new
		                 background: self defaultCursorBackground;
		                 yourself
]

{ #category : #initialization }
AlbInfiniteEditorElement >> initializeEventHandlers [

	super initializeEventHandlers.
	self addEventHandler: (BlEventHandler
			 on: AlbInfiniteModeChangedEvent
			 do: [ self modeChanged ])
]

{ #category : #'accessing - editor' }
AlbInfiniteEditorElement >> inputFilter: aTextEditorInputFilter [

	self editor inputFilter: aTextEditorInputFilter
]

{ #category : #'editor - operator' }
AlbInfiniteEditorElement >> inserter [
	<return: #AlbTextEditorInserter>

	^ self editor inserter
]

{ #category : #'accessing - editor' }
AlbInfiniteEditorElement >> isEditable [

	^ self mode isEditable
]

{ #category : #'private - view accessing' }
AlbInfiniteEditorElement >> layoutPositionsRange: anInterval [
	super layoutPositionsRange: anInterval.
	"copy this interval to the text editor (data source) to be used by AlbTextEditorCommand"
	self editor layoutPositionsRange: anInterval
]

{ #category : #'accessing - mode' }
AlbInfiniteEditorElement >> mode [

	<return: #BlText>

	^ mode
]

{ #category : #'accessing - mode' }
AlbInfiniteEditorElement >> mode: anEditabilityMode [

	mode = anEditabilityMode ifTrue: [ ^ self ].
	mode := anEditabilityMode.
	self initializeCursorElement.
	self dispatchEvent: AlbInfiniteModeChangedEvent new
]

{ #category : #'view - configuration' }
AlbInfiniteEditorElement >> modeChanged [

	wordStencil := self defaultWordStencil.
	self editor modeChanged: self mode.
	self setupModeEventHandlers.
	self setupModeShortcuts
]

{ #category : #'private - accessing editor' }
AlbInfiniteEditorElement >> modeEventHandlersDo: aBlock [

	modeEventHandlers ifNotNil: [ modeEventHandlers do: aBlock ]
]

{ #category : #'private - accessing editor' }
AlbInfiniteEditorElement >> modeShortcutsDo: aBlock [

	modeShortcuts ifNotNil: [ modeShortcuts do: aBlock ]
]

{ #category : #'event management' }
AlbInfiniteEditorElement >> mouseDownEvent: anEvent [

]

{ #category : #'editor - operator' }
AlbInfiniteEditorElement >> navigator [
	<return: #AlbTextEditorNavigator>

	^ self editor navigator
]

{ #category : #'focus accessing' }
AlbInfiniteEditorElement >> onGotFocus [

	self editor onGotFocus.
	self cursorElement onGotFocusIn: self
]

{ #category : #'hooks - layout' }
AlbInfiniteEditorElement >> onLayoutDone [

	super onLayoutDone.
	self geometryChanged
]

{ #category : #'focus accessing' }
AlbInfiniteEditorElement >> onLostFocus [

	self editor onLostFocus.
	self cursorElement onLostFocusIn: self
]

{ #category : #'private - view accessing' }
AlbInfiniteEditorElement >> piecesAndTheirElementsDo: aBlock [

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
AlbInfiniteEditorElement >> piecesAndTheirElementsWithinIndexInterval: anInterval do: aBlock [

	self piecesAndTheirElementsDo: [ :piece :pieceElement | 
		(piece textEnd < anInterval first or: [ piece textStart > (anInterval last)]) ifFalse: [ 
			aBlock value: piece value: pieceElement ] ]
]

{ #category : #'accessing - editor' }
AlbInfiniteEditorElement >> removeEditorShortcut: aTextEditorInteraction [

	self editor removeEditorShortcut: aTextEditorInteraction
]

{ #category : #accessing }
AlbInfiniteEditorElement >> rootAlbumElement [

	^ self userData at: #rootAlbumElement 
]

{ #category : #accessing }
AlbInfiniteEditorElement >> rootAlbumElement: anAlbumElement [

	self userData at: #rootAlbumElement put: anAlbumElement.
]

{ #category : #scrolling }
AlbInfiniteEditorElement >> scrollToLast [
	"Scroll instantly to the last segment"
	
	self scrollToPosition: self editor segmentCollector computedSegmentsCount
]

{ #category : #'private - accessing editor' }
AlbInfiniteEditorElement >> segments [
	^ self editor segmentCollector segments
]

{ #category : #'accessing - selection' }
AlbInfiniteEditorElement >> selectedText [

	^ self editor selectedText
]

{ #category : #'editor - operator' }
AlbInfiniteEditorElement >> selecter [
	<return: #AlbTextEditorSelecter>

	^ self editor selecter
]

{ #category : #'accessing - selection' }
AlbInfiniteEditorElement >> selection [
	<return: #BlSelection>

	^ self editor selection
]

{ #category : #'event management' }
AlbInfiniteEditorElement >> selectionChanged [
]

{ #category : #'private - accessing editor' }
AlbInfiniteEditorElement >> setupModeEventHandlers [

	self modeEventHandlersDo: [ :e | self removeEventHandler: e ].
	modeEventHandlers := self defaultModeEventHandlers.
	self modeEventHandlersDo: [ :e | 
		self addEventHandler: (e
				 element: self;
				 yourself) ]	

]

{ #category : #'private - accessing editor' }
AlbInfiniteEditorElement >> setupModeShortcuts [

	self modeShortcutsDo: [ :eachShortcut | self editor removeEditorShortcut: eachShortcut ].
	modeShortcuts := self defaultModeShortcuts.
	self modeShortcutsDo: [ :eachShortcut | self editor addEditorShortcut: eachShortcut ]
	
]

{ #category : #'accessing - text' }
AlbInfiniteEditorElement >> subTextOnScreen [
	
	| interval |
	interval := self subTextOnScreenInterval.
	^ self text from: (interval first max: 1) to: (interval last max: 0)

]

{ #category : #'accessing - text' }
AlbInfiniteEditorElement >> subTextOnScreenInterval [
	
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
AlbInfiniteEditorElement >> text [
	"Return a text I work with. All modifications to a text must be done from UI thread"
	<return: #BlText>

	^ self editor privateText
]

{ #category : #'accessing - text' }
AlbInfiniteEditorElement >> text: aText [

	aText == self editor privateText ifTrue: [ ^ self ].
	self editor privateText: aText asRopedText
]

{ #category : #'api - editor' }
AlbInfiniteEditorElement >> textEdited [

]

{ #category : #'private - view accessing' }
AlbInfiniteEditorElement >> textElementsDo: aBlock [

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
AlbInfiniteEditorElement >> textElementsSelect: aSelectBlock [

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
AlbInfiniteEditorElement >> textInternalRepresentationChanged [

	self editor processCursorAttributes.
	self editor updater
		all;
		update
]

{ #category : #'t - infinite editor accessing - text' }
AlbInfiniteEditorElement >> textLeft [

	^ self margin left + self padding left 
]

{ #category : #'private - view accessing' }
AlbInfiniteEditorElement >> textPiecesAndTheirElementsDo: aBlock [

	self piecesAndTheirElementsDo: [ :piece :pieceElement | 
		piece isText ifTrue: [ aBlock value: piece value: pieceElement ] ]
]

{ #category : #'private - view accessing' }
AlbInfiniteEditorElement >> textPiecesAndTheirElementsWithinIndexInterval: anInterval do: aBlock [

	self textPiecesAndTheirElementsDo: [ :piece :pieceElement | 
		(piece textEnd < anInterval first or: [ piece textStart > (anInterval last)]) ifFalse: [ 
			aBlock value: piece value: pieceElement ] ]
]

{ #category : #'api - editor' }
AlbInfiniteEditorElement >> textReplaced [

	self editor notifyPrimarySelectionChanged: self selection
]

{ #category : #'accessing - text' }
AlbInfiniteEditorElement >> textSnapshot [
	"Return a snaphost (copy) of the current text.
	I am safe to use from a non-UI thread because the returned text is independent from the
	current one and can be safely modified"
	<return: #BlText>

	^ self editor textSnapshot
]

{ #category : #'view - configuration' }
AlbInfiniteEditorElement >> whenTextEditedDo: aBlock [

	self deprecated: 'Use directly editorDo: [:ed | ed when: AlbTextEditedEvent do: ] instead'. 
	self editor whenTextEditedDo: aBlock
]

{ #category : #'view - configuration' }
AlbInfiniteEditorElement >> whenTextReplacedDo: aBlock [

	self editor addEventHandler: (BlEventHandler
			 on: AlbTextReplacedEvent
			 do: aBlock)
]

{ #category : #'view - configuration' }
AlbInfiniteEditorElement >> withRowNumbers [

	self withDecoration: AlbRowNumberDecoration
]

{ #category : #'view - configuration' }
AlbInfiniteEditorElement >> withSoftLine [

	self hMatchParent
]

{ #category : #accessing }
AlbInfiniteEditorElement >> withoutCacheLimit [

	self editor withoutCacheLimit
]

{ #category : #'view - configuration' }
AlbInfiniteEditorElement >> withoutRowNumbers [

	self withoutDecoration: AlbRowNumberDecoration
]

{ #category : #'view - configuration' }
AlbInfiniteEditorElement >> withoutSoftLine [

	self constraintsDo: [ :c | c horizontal fitContent ]
]

{ #category : #'private - view accessing' }
AlbInfiniteEditorElement >> wordStencil [

	<return: #AlbTextWordPieceStencil>
	^ wordStencil
]

{ #category : #'private - view accessing' }
AlbInfiniteEditorElement >> wordStencil: aWordStencil [

	wordStencil := aWordStencil
]
