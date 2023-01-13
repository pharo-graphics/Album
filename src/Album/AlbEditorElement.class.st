"
I'm an infinite element for text viewing and editing. I support scrolling, selection and other classical text editing features.
Text editing operations are driven by my data source (called textEditor). I also own a view model (viewModel) that serve as an interface for clients applicative model (such as a browser as an example).


"
Class {
	#name : #AlbEditorElement,
	#superclass : #BlElement,
	#traits : 'TOBlLayoutResizable',
	#classTraits : 'TOBlLayoutResizable classTrait',
	#instVars : [
		'infinite',
		'delegator'
	],
	#category : #'Album-UI'
}

{ #category : #'accessing - editor' }
AlbEditorElement >> addEditorShortcut: aTextEditorInteraction [

	self infinite addEditorShortcut: aTextEditorInteraction
]

{ #category : #converting }
AlbEditorElement >> asScrollableElement [
	^ self
]

{ #category : #'private - view accessing' }
AlbEditorElement >> atTextIndex: aTextIndex do: aBlock [

	" aBlock takes 2 arguments : the local text element and the local text index within the local text element"

	self infinite atTextIndex: aTextIndex do: aBlock
]

{ #category : #'view - configuration' }
AlbEditorElement >> beEditable [

	self infinite beEditable
]

{ #category : #'view - configuration' }
AlbEditorElement >> beReadonlyWithSelection [

	self infinite beReadonlyWithSelection
]

{ #category : #'view - configuration' }
AlbEditorElement >> beReadonlyWithoutSelection [

	self infinite beReadonlyWithoutSelection
]

{ #category : #'private - accessing editor' }
AlbEditorElement >> cacheSize: aNumber [

	self infinite cacheSize: aNumber
]

{ #category : #'accessing - cursor' }
AlbEditorElement >> cursor [

	^ self infinite cursor
]

{ #category : #'private - accessing editor' }
AlbEditorElement >> cursors [
	<return: #AlbTextEditorCursor>
	
	^ self infinite cursors
]

{ #category : #initialization }
AlbEditorElement >> defaultBackground [

	^ BlBackground paint: Color white
]

{ #category : #initialization }
AlbEditorElement >> defaultLayout [

	^ BlFrameLayout new
]

{ #category : #initialization }
AlbEditorElement >> defaultMargin [

	^ BlInsets all: 1
]

{ #category : #initialization }
AlbEditorElement >> defaultPadding [

	^ BlInsets
		  top: 2
		  left: 3
		  bottom: 2
		  right: 3
]

{ #category : #'editor - operator' }
AlbEditorElement >> deleter [
	<return: #AlbTextEditorDeleter>

	^ self infinite deleter
]

{ #category : #'editor - operator' }
AlbEditorElement >> deselecter [
	<return: #AlbTextEditorDeselecter>

	^ self infinite deselecter
]

{ #category : #'private - accessing editor' }
AlbEditorElement >> editor [
	<return: #AlbTextEditor>

	^ self infinite editor
]

{ #category : #'private - accessing editor' }
AlbEditorElement >> editor: aTextEditor [

	self infinite editor: aTextEditor.

]

{ #category : #'focus testing' }
AlbEditorElement >> hasFocus [

	^ self infinite hasFocus
]

{ #category : #'accessing - selection' }
AlbEditorElement >> hasSelection [

	^ self infinite hasSelection
]

{ #category : #accessing }
AlbEditorElement >> infinite [

	^ infinite
]

{ #category : #initialization }
AlbEditorElement >> initialize [
	
	super initialize.
	self layout: self defaultLayout.
	self background: self defaultBackground.
	self margin: self defaultMargin.
	self padding: self defaultPadding.
	infinite := AlbInfiniteElement new.
	self addChild: infinite.
	self matchParent.
	"delegator := BlEventDelegator delegate: BlEvent to: infinite. 
	self addEventHandler: delegator"

]

{ #category : #'accessing - editor' }
AlbEditorElement >> inputFilter: aTextEditorInputFilter [

	self infinite inputFilter: aTextEditorInputFilter
]

{ #category : #'editor - operator' }
AlbEditorElement >> inserter [
	<return: #AlbTextEditorInserter>

	^ self infinite inserter
]

{ #category : #'accessing - mode' }
AlbEditorElement >> mode [

	<return: #BlText>

	^ self infinite mode
]

{ #category : #'accessing - mode' }
AlbEditorElement >> mode: anEditabilityMode [

	self infinite mode: anEditabilityMode
]

{ #category : #'editor - operator' }
AlbEditorElement >> navigator [
	<return: #AlbTextEditorNavigator>

	^ self infinite navigator
]

{ #category : #'focus accessing' }
AlbEditorElement >> onGotFocus [

	self infinite onGotFocus
]

{ #category : #'focus accessing' }
AlbEditorElement >> onLostFocus [

	self infinite onLostFocus.

]

{ #category : #'private - view accessing' }
AlbEditorElement >> piecesAndTheirElementsDo: aBlock [

	self infinite piecesAndTheirElementsDo: aBlock
]

{ #category : #'private - view accessing' }
AlbEditorElement >> piecesAndTheirElementsWithinIndexInterval: anInterval do: aBlock [

	self infinite piecesAndTheirElementsWithinIndexInterval: anInterval do: aBlock
]

{ #category : #'accessing - editor' }
AlbEditorElement >> removeEditorShortcut: aTextEditorInteraction [

	self infinite removeEditorShortcut: aTextEditorInteraction
]

{ #category : #scrolling }
AlbEditorElement >> scrollToLast [
	"Scroll instantly to the last segment"
	
	self infinite scrollToLast
]

{ #category : #'private - accessing editor' }
AlbEditorElement >> segments [
	^ self infinite segments
]

{ #category : #'accessing - selection' }
AlbEditorElement >> selectedText [

	^ self infinite selectedText
]

{ #category : #'editor - operator' }
AlbEditorElement >> selecter [
	<return: #AlbTextEditorSelecter>

	^ self infinite selecter
]

{ #category : #'accessing - selection' }
AlbEditorElement >> selection [
	<return: #BlSelection>

	^ self infinite selection
]

{ #category : #'accessing - selection' }
AlbEditorElement >> selectionColor [

	^ self infinite selectionColor
]

{ #category : #'private - view accessing' }
AlbEditorElement >> setRemanents [

	self infinite setRemanents
]

{ #category : #'accessing - text' }
AlbEditorElement >> subTextOnScreen [
	
	^ self infinite subTextOnScreen 
]

{ #category : #'accessing - text' }
AlbEditorElement >> subTextOnScreenInterval [
	
	^ self infinite subTextOnScreenInterval 
]

{ #category : #'accessing - text' }
AlbEditorElement >> text [
	"Return a text I work with. All modifications to a text must be done from UI thread"
	<return: #BlText>

	^ self infinite text
]

{ #category : #'accessing - text' }
AlbEditorElement >> text: aText [

	self infinite text: aText
]

{ #category : #'private - view accessing' }
AlbEditorElement >> textElementsDo: aBlock [

	self infinite textElementsDo: aBlock
]

{ #category : #'private - view accessing' }
AlbEditorElement >> textElementsSelect: aSelectBlock [

	^ self infinite textElementsSelect: aSelectBlock
]

{ #category : #'private - accessing text' }
AlbEditorElement >> textInternalRepresentationChanged [

	self infinite textInternalRepresentationChanged
]

{ #category : #'private - view accessing' }
AlbEditorElement >> textPiecesAndTheirElementsDo: aBlock [

	self infinite textPiecesAndTheirElementsDo: aBlock
]

{ #category : #'private - view accessing' }
AlbEditorElement >> textPiecesAndTheirElementsWithinIndexInterval: anInterval do: aBlock [

	self infinite textPiecesAndTheirElementsWithinIndexInterval: anInterval do: aBlock
]

{ #category : #'accessing - text' }
AlbEditorElement >> textSnapshot [
	"Return a snaphost (copy) of the current text.
	I am safe to use from a non-UI thread because the returned text is independent from the
	current one and can be safely modified"
	<return: #BlText>

	^ self infinite textSnapshot
]

{ #category : #'model - events' }
AlbEditorElement >> whenActionRequired: anActionRequiredAnnouncement [

	anActionRequiredAnnouncement value: self
]

{ #category : #'view - configuration' }
AlbEditorElement >> whenModeChangedDo: aBlock [

	"set a block to perform after that the mode has been chanbed, and its action performed"

	self infinite whenModeChangedDo: aBlock
]

{ #category : #'view - configuration' }
AlbEditorElement >> whenTextEditedDo: aBlock [

	self infinite whenTextEditedDo: aBlock
]

{ #category : #'view - configuration' }
AlbEditorElement >> whenTextReplacedDo: aBlock [

	self infinite whenTextReplacedDo: aBlock
]

{ #category : #'view - configuration' }
AlbEditorElement >> withRowNumbers [

	self infinite withRowNumbers
]

{ #category : #accessing }
AlbEditorElement >> withoutCacheLimit [

	self infinite withoutCacheLimit
]

{ #category : #'view - configuration' }
AlbEditorElement >> withoutRowNumbers [

	self infinite withoutRowNumbers
]

{ #category : #'private - view accessing' }
AlbEditorElement >> wordStencil: aWordStencil [

	self infinite wordStencil: aWordStencil
]
