Class {
	#name : #AlbEditor,
	#superclass : #AlbEditorElement,
	#traits : 'TOBlLayoutResizable',
	#classTraits : 'TOBlLayoutResizable classTrait',
	#instVars : [
		'textReplacedHandler',
		'oppositeDelimiterZone'
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

{ #category : #sparta }
AlbEditor >> buildSelectionPathOnSpartaCanvas: aCanvas [
	| aCollection pathBuilder |
	aCollection := self selectionVertices2.
	pathBuilder := aCanvas path
		absolute;
		moveTo: aCollection first.
	aCollection allButFirstDo: [ :pt | pathBuilder lineTo: pt ].
	pathBuilder close.
	^ pathBuilder finish
]

{ #category : #'editor - accessing' }
AlbEditor >> cursors [
	<return: #AlbTextEditorCursor>
	^ self editor cursors
]

{ #category : #accessing }
AlbEditor >> defaultSelectionColor [ 
	^ Color orange
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

{ #category : #sparta }
AlbEditor >> drawMeAndChildrenOnSpartaCanvas: aCanvas [
	super drawMeAndChildrenOnSpartaCanvas: aCanvas.
	self drawSelectionOnSpartaCanvas: aCanvas.
	self drawOppositeDelimiterOnSpartaCanvas: aCanvas.


]

{ #category : #sparta }
AlbEditor >> drawOppositeDelimiterOnSpartaCanvas: aCanvas [
	self selection isEmpty ifFalse: [ ^self ].
	oppositeDelimiterZone
		drawFrom: self
		onSpartaCanvas: aCanvas
]

{ #category : #sparta }
AlbEditor >> drawSelectionOnSpartaCanvas: aCanvas [

	self selectionRectangles do: [ :bnds | 
		aCanvas fill
			paint: (Color orange alpha: 0.35);
			path: bnds;
			draw ]
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
		                       do: [ :anEvent | self viewModel text: anEvent text ].
	"we intentionally set text directly to the viewModel
		to prevent any possible #asRopedText convertion"
	oppositeDelimiterZone := AlbOppositeDelimiterZone new.
	
	self editor: AlbTextEditor new.
	self viewModel: AlbEditorModel new.
	self padding: (BlInsets all: 6).
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

{ #category : #'hooks - layout' }
AlbEditor >> onLayoutDone [
	super onLayoutDone.
	self updateOppositeDelimiterZone
	
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

{ #category : #sparta }
AlbEditor >> selectionRectangles [
	| segs lines prec |
	
	segs := Array streamContents: [ :stream | 
		self children sortedByElevation do: [ :anElement | 
			stream nextPutAll: anElement allSelectionBounds ] ].
	segs ifEmpty: [ ^ #( ) ].
	segs := segs asOrderedCollection.
	lines := OrderedCollection new.
	prec := segs removeFirst.
	[ segs isEmpty ] whileFalse: [ | curr |
		curr := segs removeFirst.
		curr origin x <= prec origin x
			ifTrue: [ lines add: prec. prec := curr ]
			ifFalse: [ prec := prec merge: curr ] ].
	lines add: prec.
	^ lines
]

{ #category : #sparta }
AlbEditor >> selectionVertices [

	| lines vertices currLine |
	lines := self allLineSelectionBounds.
	vertices := OrderedCollection new.
	lines ifEmpty: [ ^ vertices ].
	currLine := lines first.
	vertices add: currLine topLeft.
	vertices add: currLine topRight.
	lines size = 1 ifTrue: [ 
		vertices add: currLine bottomRight.
		vertices add: currLine bottomLeft.
		vertices add: currLine topLeft.
		^ vertices ].
	currLine := lines at: lines size - 1.
	vertices add: currLine bottomRight.
	currLine := lines last.
	vertices add: currLine topRight.
	vertices add: currLine bottomRight.
	vertices add: currLine bottomLeft.
	
		lines add: lines second topLeft.
		lines add: lines first bottomLeft.
	lines add: lines first topLeft.
	^ vertices
]

{ #category : #sparta }
AlbEditor >> selectionVertices2 [

	| lines vertices currLine |
	lines := self allLineSelectionBounds.
	vertices := OrderedCollection new.
	lines ifEmpty: [ ^ vertices ].
	currLine := lines first.
	vertices add: currLine topLeft.
	vertices add: currLine topRight.
	vertices add: currLine bottomRight.
	lines size = 1 ifTrue: [ 
		vertices add: currLine bottomRight.
		vertices add: currLine bottomLeft.
		vertices add: currLine topLeft.
		^ vertices ].
	lines size > 2 ifTrue: [ 
		currLine := lines at: lines size - 1.
		vertices add: currLine bottomRight].
	currLine := lines last.
	vertices add: currLine topRight.
	vertices add: currLine bottomRight.
	vertices add: currLine bottomLeft.
	lines size > 2 ifTrue: [ 
		currLine := lines at: 2.
		vertices add: currLine topLeft].
	currLine := lines first.
	lines add: lines first bottomLeft.
	lines add: lines first topLeft.
	^ vertices
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

{ #category : #'hooks - layout' }
AlbEditor >> updateOppositeDelimiterZone [

	oppositeDelimiterZone updateFrom: self
]
