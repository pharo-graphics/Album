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

{ #category : #accessing }
AlbEditor >> drawDecorator [
	^ drawDecorator 
]

{ #category : #sparta }
AlbEditor >> drawMeAndChildrenOnSpartaCanvas: aCanvas [
	super drawMeAndChildrenOnSpartaCanvas: aCanvas.
	zones do: [ :z | z drawOnSpartaCanvasOver: aCanvas in: self].
	self childrenDo: [ :child | 
		self itemDecorationsDo: [ :d | 
			d
				draw: child
				onSpartaCanvasOver: aCanvas
				in: self ] ]


]

{ #category : #sparta }
AlbEditor >> drawOnSpartaCanvas: aCanvas [

	self shouldDrawBackgroundOrBorder ifTrue: [ 
		aCanvas figure
			path: (self geometry
					 pathOnSpartaCanvas: aCanvas
					 of: self);
			background: self background;
			backgroundAlpha: self background opacity;
			border: self border paint;
			borderAlpha: self border opacity;
			width: self border width;
			in: [ :aPainter | self border style applyOn: aPainter ];
			in: [ :aPainter | 
				self outskirts = BlOutskirts outside ifTrue: [ aPainter borderOutside ].
				self outskirts = BlOutskirts centered ifTrue: [ aPainter borderCentered ].
				self outskirts = BlOutskirts inside ifTrue: [ aPainter borderInside ] ];
			draw ].
	self childrenDo: [ :child | 
		self itemDecorationsDo: [ :d | 
			d
				draw: child
				onSpartaCanvas: aCanvas
				in: self ] ].
	zones do: [ :z | 
		z
			drawOnSpartaCanvas: aCanvas
			in: self ]
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
drawDecorator := false.
	textReplacedHandler := BlEventHandler
		                       on: AlbTextEditorTextReplacedEvent
		                       do: [ :anEvent | self viewModel text: anEvent text ].
	"we intentionally set text directly to the viewModel
		to prevent any possible #asRopedText convertion"
	zones := OrderedCollection new.
	zones add: AlbOppositeDelimiterZone new.
	zones add: AlbCursorSelectionZone new.
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
	drawDecorator := true
	
	
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

{ #category : #'accessing - decoration' }
AlbEditor >> withLineNumbers [

	self itemDecorations
		detect: [ :d | d isKindOf: AlbLineNumberDecoration ]
		ifNone: [ 
			self itemDecorations add: AlbLineNumberDecoration new.
			self invalidateItemDecorations ]
]

{ #category : #'accessing - decoration' }
AlbEditor >> withoutLineNumbers [

	itemDecorations := self itemDecorations reject: [ :d | 
		                   (d isKindOf: AlbLineNumberDecoration)
			                   ifTrue: [ 
				                   self invalidateItemDecorations.
				                   true ]
			                   ifFalse: [ false ] ]
]
