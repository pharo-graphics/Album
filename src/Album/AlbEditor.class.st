Class {
	#name : #AlbEditor,
	#superclass : #AlbEditorElement,
	#traits : 'TOBlLayoutResizable',
	#classTraits : 'TOBlLayoutResizable classTrait',
	#instVars : [
		'textReplacedHandler',
		'zones',
		'drawDecorator'
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
			(holder
				 pieceForElement: element
				 ifAbsent: [  ]) ifNotNil: [ :foundPiece | 
				(foundPiece isText and: [ element segmentPiece textInterval includes: aTextIndex ]) ifTrue: [ 
					"here, foundPiece can be ~~ element segmentPiece, it seems that the good one (uptodate) if found via children and not from the holder"
					aBlock
						value: element
						value: (element segmentPiece globalTextIndexToLocal: aTextIndex) ] ] ] ]
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
AlbEditor >> defaultPaddings [

	^ BlInsets
		  top: 10
		  left: 0
		  bottom: 10
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

{ #category : #accessing }
AlbEditor >> editor: aTextEditor [
	self editor removeEventHandler: textReplacedHandler.

	super editor: aTextEditor.

	aTextEditor addEventHandler: textReplacedHandler
]

{ #category : #initialization }
AlbEditor >> initialize [

	super initialize.

	self matchParent.

	textReplacedHandler := BlEventHandler
		                       on: AlbTextEditorTextReplacedEvent
		                       do: [ :anEvent | 
		                       self viewModel text: anEvent text ].
	"we intentionally set text directly to the viewModel to prevent any possible #asRopedText convertion"

	self padding: self defaultPaddings.

	"self withDecoration: AlbOppositeDelimiterZone."
	"self withDecoration: AlbCursorSelectionZone."

	self editor: AlbTextEditor new.
	self viewModel: AlbEditorModel new.
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

{ #category : #'model - events' }
AlbEditor >> modeChanged: aTextEditorMode [
	self editor editorMode: aTextEditorMode.
	self states addState: (AlbEditorModeState mode: aTextEditorMode class)
]

{ #category : #'editor - operations' }
AlbEditor >> navigator [
	<return: #AlbTextEditorNavigator>

	^ self editor navigator
]

{ #category : #'editor - accessing' }
AlbEditor >> otherSelectionRectangles [

	| subtext collector founds |
	subtext := self editor segmentCollector subText.
	collector := BlIntervalCollector new text: subtext asString.
	founds := collector searchAll: self editor selectedText.
	^ Array streamContents: [ :stream | 
		          founds do: [ :interval | 
			          (self
				           selectionBoundsFrom: interval first - 1
				           to: interval last) ] ]
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

{ #category : #'private - accessing' }
AlbEditor >> selectionBounds [

	" aBlock takes 2 arguments : the local text element and the local text index within the local text element"

	^ Array streamContents: [ :stream | 
		  self selection do: [ :currsel | 
			  stream nextPutAll: (self selectionBoundsFrom: currsel from to: currsel to) ] ]
]

{ #category : #'private - accessing' }
AlbEditor >> selectionBoundsFrom: startIdx to: endIdx [

	" aBlock takes 2 arguments : the local text element and the local text index within the local text element"

	^ Array streamContents: [ :stream | 
		  self
			  piecesAndTheirElementsWithinIndexInterval: (startIdx to: endIdx)
			  do: [ :piece :pieceElement | 
				  piece isText ifTrue: [ 
					  | selBounds first last |
					  ((piece textStart to: piece textEnd) includesAll: (startIdx to: endIdx))
						  ifTrue: [ 
							  first := startIdx.
							  last := endIdx ]
						  ifFalse: [ 
							  startIdx > piece textStart
								  ifTrue: [ 
									  first := startIdx.
									  last := piece textEnd ]
								  ifFalse: [ 
									  first := piece textStart.
									  last := endIdx < piece textEnd
										          ifTrue: [ endIdx ]
										          ifFalse: [ piece textEnd ] ] ].
"Transcript show: 'editor ', ((piece globalTextIndexToLocal: first) -> (piece globalTextIndexToLocal: last) ) asString; cr."
					  selBounds := pieceElement
						               selectionBoundsFrom: (piece globalTextIndexToLocal: first)
						               to: (piece globalTextIndexToLocal: last).
					  selBounds := selBounds collect: [ :bnds | 
						               self localBoundsToMine: bnds fromChild: pieceElement ].
					  stream nextPutAll: selBounds ] ] ]
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
			(holder pieceForElement: textElement ifAbsent: [  ]) ifNotNil: [ 
				:foundPiece | 
				foundPiece isText ifTrue: [ aBlock value: textElement ] ] ] ]
]

{ #category : #'private - accessing' }
AlbEditor >> textOnScreen [
	
	| interval |
	interval := self textOnScreenInterval.
	^ self text from: interval first to: interval last

]

{ #category : #'private - accessing' }
AlbEditor >> textOnScreenInterval [
	
	| holder first last |
	self text isEmpty ifTrue: [ ^ 0 to: -1 ].
	holder := self elementHolderOf: self children first.
	first := holder textInterval first.
	holder := self elementHolderOf: self children last.
	last := holder textInterval last.
	^ first to: last

]

{ #category : #'private - accessing' }
AlbEditor >> textPiecesAndTheirElementsDo: aBlock [

	self piecesAndTheirElementsDo: [ :piece :pieceElement | 
		piece isText ifTrue: [ aBlock value: piece value: pieceElement ] ]
]

{ #category : #'accessing - decoration' }
AlbEditor >> withLineNumbers [

	self withDecoration: AlbLineNumberDecoration
]

{ #category : #'accessing - decoration' }
AlbEditor >> withoutLineNumbers [

	self withoutDecoration: AlbLineNumberDecoration
]
