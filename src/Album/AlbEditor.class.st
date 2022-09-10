Class {
	#name : #AlbEditor,
	#superclass : #AlbEditorElement,
	#traits : 'TOBlLayoutResizable',
	#classTraits : 'TOBlLayoutResizable classTrait',
	#instVars : [
		'textReplacedHandler',
		'feltPens'
	],
	#category : #'Album-UI'
}

{ #category : #'api - editor' }
AlbEditor >> addEditorShortcut: aTextEditorInteraction [
	self editor addEditorShortcut: aTextEditorInteraction
]

{ #category : #'private - accessing' }
AlbEditor >> atTextIndex: aTextIndex do: aBlock [

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

{ #category : #'api - editor' }
AlbEditor >> beEditable [
	self beMode: AlbTextEditorEditableMode new
]

{ #category : #'api - editor' }
AlbEditor >> beMode: aTextEditorMode [
	self viewModel mode: aTextEditorMode
]

{ #category : #'api - editor' }
AlbEditor >> beReadOnlyWithSelection [
	self beMode: AlbTextEditorReadonlyWithSelectionMode new
]

{ #category : #'api - editor' }
AlbEditor >> beReadOnlyWithoutSelection [
	self beMode: AlbTextEditorReadonlyWithoutSelectionMode new
]

{ #category : #'editor - accessing' }
AlbEditor >> cursors [
	<return: #AlbTextEditorCursor>
	^ self editor cursors
]

{ #category : #initialization }
AlbEditor >> defaulEditorModel [

	^ AlbEditorModel new.
]

{ #category : #initialization }
AlbEditor >> defaulTextEditor [

	^ AlbTextEditor new.
]

{ #category : #initialization }
AlbEditor >> defaultPaddings [

	^ BlInsets
		  top: 5
		  left: 0
		  bottom: 5
		  right: 5
]

{ #category : #'editor - operations' }
AlbEditor >> deleter [
	<return: #AlbTextEditorDeleter>

	^ self editor deleter
]

{ #category : #'editor - operations' }
AlbEditor >> deselecter [
	<return: #AlbTextEditorDeselecter>

	^ self editor deselecter
]

{ #category : #'ui - events managing' }
AlbEditor >> doubleClickEvent: anEvent [
	super doubleClickEvent: anEvent.
	self feltPensDo: [ :fp | fp doubleClickEvent: anEvent ]
]

{ #category : #'ui - events managing' }
AlbEditor >> dragEndEvent: anEvent [
	super dragEndEvent: anEvent.
	self feltPensDo: [ :fp | fp dragEndEvent: anEvent ]
	
]

{ #category : #'ui - events managing' }
AlbEditor >> dragEvent: anEvent [
	super dragEvent: anEvent.
	"self feltPensDo: [ :fp | fp dragEvent: anEvent ]"

]

{ #category : #'ui - events managing' }
AlbEditor >> dragStartEvent: anEvent [
	super dragStartEvent: anEvent.
	self feltPensDo: [ :fp | fp dragStartEvent: anEvent ]

]

{ #category : #accessing }
AlbEditor >> editor: aTextEditor [
	self editor removeEventHandler: textReplacedHandler.

	super editor: aTextEditor.

	aTextEditor addEventHandler: textReplacedHandler
]

{ #category : #'private - accessing' }
AlbEditor >> editorText [
	^ self editor text
]

{ #category : #'private - accessing' }
AlbEditor >> feltPensDo: aBlock [
	feltPens ifNil: [ ^self ].
	feltPens do: aBlock
]

{ #category : #'focus accessing' }
AlbEditor >> focusables: aBlFocusFinderCandidates along: aBlFocusSearchDirection [
	"Sort candidates according the bounds left, to ensure that rightmost are favored for up and down. "
	super
		focusables: aBlFocusFinderCandidates
		along: aBlFocusSearchDirection.
	aBlFocusFinderCandidates candidates sort: [ :a :b | 
		a bounds left > b bounds left ]
]

{ #category : #initialization }
AlbEditor >> initialize [

	super initialize.
	feltPens := OrderedCollection new.
	self withOppositeDelimiter.
	self withSelectionEcho.
	self withDecoration: AlbSelectionLimitDecoration.
	
	self matchParent.
	textReplacedHandler := BlEventHandler
		                       on: AlbTextEditorTextReplacedEvent
		                       do: [ :anEvent | 
		                       self viewModel text: anEvent text ].
	"we intentionally set text directly to the viewModel to prevent any possible #asRopedText convertion"
	self padding: self defaultPaddings.
	self editor: self defaulTextEditor.
	self viewModel: self defaulEditorModel.
	
	self
		when: AlbEditorStylerChanged
		do: [ :anEvent | self stylerChanged: anEvent styler ].
	self
		when: AlbEditorTextChanged
		do: [ :anEvent | self textChanged: anEvent text ].
	self
		when: AlbEditorModeChanged
		do: [ :anEvent | self modeChanged: anEvent mode ]
]

{ #category : #'api - editor' }
AlbEditor >> inputFilter: aTextEditorInputFilter [
	self editor inputFilter: aTextEditorInputFilter
]

{ #category : #'editor - operations' }
AlbEditor >> inserter [
	<return: #AlbTextEditorInserter>

	^ self editor inserter
]

{ #category : #'api - editor' }
AlbEditor >> isEditable [
	<return: #Boolean>

	^ self viewModel mode isEditable
]

{ #category : #'api - editor' }
AlbEditor >> isReadOnly [
	<return: #Boolean>

	^ self viewModel mode isReadOnly
]

{ #category : #accessing }
AlbEditor >> layoutPositionsRange: anInterval [
	super layoutPositionsRange: anInterval.
	"copy this interval to the text editor (data source) to be used by AlbTextEditorCommand"
	self editor layoutPositionsRange: anInterval

]

{ #category : #'model - events' }
AlbEditor >> modeChanged: aTextEditorMode [
	self editor editorMode: aTextEditorMode.
	self states addState: (AlbEditorModeState mode: aTextEditorMode class)
]

{ #category : #'ui - events managing' }
AlbEditor >> mouseDownEvent: anEvent [
	super mouseDownEvent: anEvent.
	self feltPensDo: [ :fp | fp mouseDownEvent: anEvent ]
	
]

{ #category : #'editor - operations' }
AlbEditor >> navigator [
	<return: #AlbTextEditorNavigator>

	^ self editor navigator
]

{ #category : #'hooks - layout' }
AlbEditor >> onLayoutDone [

	super onLayoutDone.
	self feltPensDo: [ :fp | fp onLayoutDoneIn: self ]
]

{ #category : #'hooks - scrolling' }
AlbEditor >> onScrolled: aPoint [
	super onScrolled: aPoint.
	self feltPensDo: [ :fp | fp onScrollDoneIn: self ]
]

{ #category : #'private - accessing' }
AlbEditor >> piecesAndTheirElementsDo: aBlock [

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
AlbEditor >> piecesAndTheirElementsWithinIndexInterval: anInterval do: aBlock [

	self piecesAndTheirElementsDo: [ :piece :pieceElement | 
		(piece textEnd < anInterval first or: [ piece textStart > (anInterval last)]) ifFalse: [ 
			aBlock value: piece value: pieceElement ] ]
]

{ #category : #accessing }
AlbEditor >> request: aRequest [

	aRequest canBePropagated
		ifTrue: [ self fireEvent: aRequest ]
		ifFalse: [ self dispatchEvent: aRequest ].

	^ aRequest response
]

{ #category : #'editor - accessing' }
AlbEditor >> segmentOnScreenInterval [
	
	| holder first last |
	self hasChildren ifFalse: [ ^ 0 to: -1 ].
	holder := self elementHolderOf: self children first.
	first := holder position.
	holder := self elementHolderOf: self children last.
	last := holder position.
	^ first to: last

]

{ #category : #'editor - accessing' }
AlbEditor >> segments [
	^ self editor segmentCollector segments
]

{ #category : #'editor - accessing' }
AlbEditor >> selectedText [
	^ self editor selectedText
]

{ #category : #'editor - operations' }
AlbEditor >> selecter [
	<return: #AlbTextEditorSelecter>

	^ self editor selecter
]

{ #category : #'editor - accessing' }
AlbEditor >> selection [
	<return: #BlSelection>

	^ self editor selection
]

{ #category : #accessing }
AlbEditor >> selectionColor [

	^ Color
		  r: 0.9530791788856305
		  g: 0.8084066471163245
		  b: 0.1906158357771261
		  alpha: 1.0
]

{ #category : #'editor - accessing' }
AlbEditor >> styler [
	^ self viewModel styler
]

{ #category : #'editor - accessing' }
AlbEditor >> styler: aStyler [
	self viewModel styler: aStyler
]

{ #category : #'model - events' }
AlbEditor >> stylerChanged: aStyler [

	self editor styler: aStyler
]

{ #category : #'editor - accessing' }
AlbEditor >> subTextOnScreen [
	
	| interval |
	interval := self subTextOnScreenInterval.
	^ self editorText from: (interval first max: 1) to: interval last

]

{ #category : #'editor - accessing' }
AlbEditor >> subTextOnScreenInterval [
	
	| holder first last |
	self editorText isEmpty ifTrue: [ ^ 0 to: -1 ].
	holder := self elementHolderOf: self children first.
	first := holder textInterval first.
	holder := self elementHolderOf: self children last.
	last := holder textInterval last.
	^ first to: last

]

{ #category : #'editor - accessing' }
AlbEditor >> text [
	"Return a text I work with. All modifications to a text must be done from UI thread"
	<return: #BlText>

	^ self viewModel text
]

{ #category : #'editor - accessing' }
AlbEditor >> text: aBlText [
	self viewModel text: aBlText asRopedText
]

{ #category : #'model - events' }
AlbEditor >> textChanged: aText [
	self editor text: aText
]

{ #category : #'private - accessing' }
AlbEditor >> textElementsDo: aBlock [

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
AlbEditor >> textPiecesAndTheirElementsDo: aBlock [

	self piecesAndTheirElementsDo: [ :piece :pieceElement | 
		piece isText ifTrue: [ aBlock value: piece value: pieceElement ] ]
]

{ #category : #'private - accessing' }
AlbEditor >> textPiecesAndTheirElementsWithinIndexInterval: anInterval do: aBlock [

	self textPiecesAndTheirElementsDo: [ :piece :pieceElement | 
		(piece textEnd < anInterval first or: [ piece textStart > (anInterval last)]) ifFalse: [ 
			aBlock value: piece value: pieceElement ] ]
]

{ #category : #'accessing - decoration' }
AlbEditor >> withFeltPen: aFeltPenClass [

	feltPens detect: [ :d | d isKindOf: aFeltPenClass ] ifNone: [ feltPens add: aFeltPenClass new ]
]

{ #category : #'accessing - decoration' }
AlbEditor >> withLineNumbers [

	self withDecoration: AlbLineNumberDecoration
]

{ #category : #'accessing - decoration' }
AlbEditor >> withOppositeDelimiter [
	self withFeltPen: AlbEditorOppositePen
]

{ #category : #'accessing - decoration' }
AlbEditor >> withSelectionEcho [
	self withFeltPen: AlbEditorSelectionEchoPen 
]

{ #category : #'accessing - decoration' }
AlbEditor >> withoutFeltPen: aFeltPenClass [

	feltPens := feltPens reject: [ :d | d isKindOf: aFeltPenClass ]
]

{ #category : #'accessing - decoration' }
AlbEditor >> withoutLineNumbers [

	self withoutDecoration: AlbLineNumberDecoration
]

{ #category : #'accessing - decoration' }
AlbEditor >> withoutOppositeDelimiter [
	self withoutFeltPen: AlbEditorOppositePen
]

{ #category : #'accessing - decoration' }
AlbEditor >> withoutSelectionEcho [
	self withoutFeltPen: AlbEditorSelectionEchoPen 
]
