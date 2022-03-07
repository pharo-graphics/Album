Class {
	#name : #AlbEditor,
	#superclass : #AlbEditorElement,
	#traits : 'TBrLayoutResizable',
	#classTraits : 'TBrLayoutResizable classTrait',
	#instVars : [
		'textReplacedHandler'
	],
	#category : #'Album-Editor-UI'
}

{ #category : #'api - editor' }
AlbEditor >> addEditorShortcut: aBrTextEditorInteraction [
	self editor addEditorShortcut: aBrTextEditorInteraction
]

{ #category : #'api - editor' }
AlbEditor >> beEditable [
	self beMode: BrTextEditorEditableMode new
]

{ #category : #'api - editor' }
AlbEditor >> beMode: aTextEditorMode [
	self viewModel mode: aTextEditorMode
]

{ #category : #'api - editor' }
AlbEditor >> beReadOnlyWithSelection [
	self beMode: BrTextEditorReadonlyWithSelectionMode new
]

{ #category : #'api - editor' }
AlbEditor >> beReadOnlyWithoutSelection [
	self beMode: BrTextEditorReadonlyWithoutSelectionMode new
]

{ #category : #'editor - accessing' }
AlbEditor >> cursors [
	<return: #BrTextEditorCursor>
	^ self editor cursors
]

{ #category : #'editor - operations' }
AlbEditor >> deleter [
	<return: #BrTextEditorDeleter>

	^ self editor deleter
]

{ #category : #'editor - operations' }
AlbEditor >> deselecter [
	<return: #BrTextEditorDeselecter>

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
		on: BrTextEditorTextReplacedEvent
		"we intentionally set text directly to the viewModel
		to prevent any possible #asRopedText convertion"
		do: [ :anEvent | self viewModel text: anEvent text ].

	self editor: AlbTextEditor new.
	self viewModel: AlbEditorModel new
]

{ #category : #'api - editor' }
AlbEditor >> inputFilter: aBrTextEditorInputFilter [
	self editor inputFilter: aBrTextEditorInputFilter
]

{ #category : #'editor - operations' }
AlbEditor >> inserter [
	<return: #BrTextEditorInserter>

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

{ #category : #'editor - operations' }
AlbEditor >> navigator [
	<return: #BrTextEditorNavigator>

	^ self editor navigator
]

{ #category : #'editor - operations' }
AlbEditor >> selecter [
	<return: #BrTextEditorSelecter>

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
