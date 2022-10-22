Class {
	#name : #AlbEditorViewModel,
	#superclass : #OBlViewModel,
	#classTraits : 'TObservable classTrait',
	#instVars : [
		'#text => ObservableSlot',
		'#mode => ObservableSlot',
		'#shortcuts',
		'#editorEventHandler',
		'#wordStencil',
		'#elementEventHandlers'
	],
	#category : #'Album-Model'
}

{ #category : #accessing }
AlbEditorViewModel >> beEditable [

	self mode: AlbEditableMode new
]

{ #category : #accessing }
AlbEditorViewModel >> beReadonlyWithSelection [

	self mode: AlbReadonlyWithSelectionMode new
]

{ #category : #accessing }
AlbEditorViewModel >> beReadonlyWithoutSelection [

	self mode: AlbReadonlyWithoutSelectionMode new
]

{ #category : #initialization }
AlbEditorViewModel >> defaultEditorElementEventHandlers [

	^ self mode defaultEditorElementEventHandlers
]

{ #category : #initialization }
AlbEditorViewModel >> defaultMode [

	^ AlbEditableMode new
]

{ #category : #initialization }
AlbEditorViewModel >> defaultSelectionView [

	^ self mode defaultSelectionView
]

{ #category : #accessing }
AlbEditorViewModel >> defaultShortcuts [

	^ mode defaultShortcuts
]

{ #category : #initialization }
AlbEditorViewModel >> defaultText [

	^ '' asRopedText
]

{ #category : #initialization }
AlbEditorViewModel >> defaultWordStencil [

	^ mode defaultWordStencil
]

{ #category : #initialization }
AlbEditorViewModel >> editorElementDo: aBlock [

	self announce: (AlbActionRequiredFromEditorElement new
			 valuable: aBlock;
			 yourself)
]

{ #category : #accessing }
AlbEditorViewModel >> elementEventHandlersDo: aBlock [

	elementEventHandlers ifNotNil: [ elementEventHandlers do: aBlock ]
]

{ #category : #initialization }
AlbEditorViewModel >> initialize [

	self class initializeSlots: self.
	super initialize.

	mode := self defaultMode.
	text := self defaultText.
	wordStencil := self defaultWordStencil.

	" action when  mode change (Observable slot) "
	self whenModeChangedDo: [ :m | self modeChanged ].
		
	" action when  text change (Observable slot) "
	self whenTextChangedDo: [ :t | self textChanged ].
]

{ #category : #accessing }
AlbEditorViewModel >> mode [

	^ mode
]

{ #category : #accessing }
AlbEditorViewModel >> mode: anEditabilityMode [

	mode = anEditabilityMode ifTrue: [ ^ self ].
	mode := anEditabilityMode
]

{ #category : #initialization }
AlbEditorViewModel >> modeChanged [

	wordStencil := self defaultWordStencil.
	self editorElementDo: [ :element | 
			 element editor whenEditionModeChanged: self mode.
			 self setupEventHandlersForElement: element.
			 self setupShortcutsInTextEditor: element editor.
			 element selectionView: self defaultSelectionView ]
]

{ #category : #'api - hooks' }
AlbEditorViewModel >> onInstalledIn: anElement [

	"Is sent when I am added to an element "

	super onInstalledIn: anElement.

	anElement selectionView: self defaultSelectionView.
	self when: AlbActionRequiredFromEditorElement send: #whenActionRequired: to: anElement.
	" element related event handlers "
	self setupEventHandlersForElement: anElement.
	" editor related event handler: text insertion/deletion "
	editorEventHandler := BlEventHandler
		                      on: AlbTextModifiedEvent
		                      do: [ :anEvent | self whenTextModifiedByTextEditor: anEvent].
	anElement editor addEventHandler: editorEventHandler.
	" current mode compatible shortcuts "
	self setupShortcutsInTextEditor: anElement editor
]

{ #category : #'api - hooks' }
AlbEditorViewModel >> onUninstalledIn: anElement [

	"Is sent when I am removed from an element "

	super onUninstalledIn: anElement.
	self shortcutsDo: [ :eachShortcut | anElement editor removeEditorShortcut: eachShortcut ].
	self elementEventHandlersDo: [ :e | anElement removeEventHandler: e ].
	self unsubscribe: anElement.
	anElement editor removeEventHandler: editorEventHandler.
	shortcuts := nil.
	editorEventHandler := nil.
	elementEventHandlers := nil
]

{ #category : #'api-transaction' }
AlbEditorViewModel >> requestSave [

	self announce: (AlbSaveRequested new viewModel: self)
]

{ #category : #'api - hooks' }
AlbEditorViewModel >> setupEventHandlersForElement: anElement [
	
	self elementEventHandlersDo: [ :e | anElement removeEventHandler: e ].
	elementEventHandlers := self defaultEditorElementEventHandlers.
	self elementEventHandlersDo: [ :e | 
		anElement addEventHandler: (e
				 element: anElement;
				 yourself) ]	

]

{ #category : #'api - hooks' }
AlbEditorViewModel >> setupShortcutsInTextEditor: aTextEditor [

	self shortcutsDo: [ :eachShortcut | aTextEditor removeEditorShortcut: eachShortcut ].
	shortcuts := self defaultShortcuts.
	self shortcutsDo: [ :eachShortcut | aTextEditor addEditorShortcut: eachShortcut ]
	
]

{ #category : #accessing }
AlbEditorViewModel >> shortcuts [

	^ shortcuts
]

{ #category : #accessing }
AlbEditorViewModel >> shortcutsDo: aBlock [

	shortcuts ifNotNil: [ shortcuts do: aBlock ]
]

{ #category : #accessing }
AlbEditorViewModel >> text [

	^ text
]

{ #category : #accessing }
AlbEditorViewModel >> text: aText [

	| t |
	t := aText asRopedText.
	text == t ifTrue: [ ^ self ].
	text := t
]

{ #category : #initialization }
AlbEditorViewModel >> textChanged [

	self editorElementDo: [ :element | element editor whenTextChanged: self text ]
]

{ #category : #'slot - change hook' }
AlbEditorViewModel >> whenModeChangedDo: aBlock [

	"set a block to perform after that the mode has been chanbed, and its action performed"

	self property: #mode whenChangedDo: aBlock
]

{ #category : #'slot - change hook' }
AlbEditorViewModel >> whenTextChangedDo: aBlock [

	"set a block to perform after that the text has been chanbed, and its action performed"

	self property: #text whenChangedDo: aBlock
]

{ #category : #'api - hooks' }
AlbEditorViewModel >> whenTextModifiedByTextEditor: aTextModifiedEvent [

	self announce: (AlbTextModifiedByEditor new text: aTextModifiedEvent text)
]

{ #category : #accessing }
AlbEditorViewModel >> wordStencil [

	<return: #AlbTextWordPieceStencil>
	^ wordStencil
]

{ #category : #accessing }
AlbEditorViewModel >> wordStencil: aWordStencil [

	wordStencil := aWordStencil
]
