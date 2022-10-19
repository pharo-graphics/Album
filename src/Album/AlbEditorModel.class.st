Class {
	#name : #AlbEditorModel,
	#superclass : #OBlViewModel,
	#traits : 'TObservable',
	#classTraits : 'TObservable classTrait',
	#instVars : [
		'#text => ObservableSlot',
		'#mode => ObservableSlot',
		'#hasUnacceptedEdits',
		'#fontName',
		'#shortcuts',
		'#editorEventHandler',
		'#wordStencil',
		'#elementEventHandlers'
	],
	#category : #'Album-Model'
}

{ #category : #testing }
AlbEditorModel >> allowSelection [ 
	^ mode allowSelection  
]

{ #category : #accessing }
AlbEditorModel >> beEditable [

	mode := AlbEditableMode new
]

{ #category : #accessing }
AlbEditorModel >> beReadonlyWithSelection [

	mode := AlbReadonlyWithSelectionMode new
]

{ #category : #accessing }
AlbEditorModel >> beReadonlyWithoutSelection [

	mode := AlbReadonlyWithoutSelectionMode new
]

{ #category : #initialization }
AlbEditorModel >> defaultEditorElementEventHandlers [

	^ self mode defaultEditorElementEventHandlers
]

{ #category : #initialization }
AlbEditorModel >> defaultFontName [
	^ nil
]

{ #category : #initialization }
AlbEditorModel >> defaultMode [

	^ AlbEditableMode new
]

{ #category : #initialization }
AlbEditorModel >> defaultSelectionView [

	^ self mode defaultSelectionView
]

{ #category : #accessing }
AlbEditorModel >> defaultShortcuts [
	^ mode defaultShortcuts
]

{ #category : #initialization }
AlbEditorModel >> defaultText [

	^ '' asRopedText
]

{ #category : #initialization }
AlbEditorModel >> defaultWordStencil [

	^ mode defaultWordStencil
]

{ #category : #accessing }
AlbEditorModel >> elementEventHandlersDo: aBlock [

	elementEventHandlers ifNotNil: [ elementEventHandlers do: aBlock ]
]

{ #category : #accessing }
AlbEditorModel >> fontName [

	^ fontName 
]

{ #category : #accessing }
AlbEditorModel >> fontName: aFontName [

	fontName := aFontName
]

{ #category : #accessing }
AlbEditorModel >> hasUnacceptedEdits [

	^ hasUnacceptedEdits ifNil: [ hasUnacceptedEdits := false ]
]

{ #category : #accessing }
AlbEditorModel >> hasUnacceptedEdits: aBoolean [

	hasUnacceptedEdits = aBoolean ifTrue: [ ^ self ].
	hasUnacceptedEdits := aBoolean.
	self announce: (AlbEditsStateChangedInModel new viewModel: self)
]

{ #category : #initialization }
AlbEditorModel >> initialize [

	self class initializeSlots: self.
	super initialize.

	" fontName must be initialize before text "
	fontName := self defaultFontName.
	mode := self defaultMode.
	text := self defaultText.
	wordStencil := self defaultWordStencil.

	" action when  mode change (Observable slot) "
	self whenModeChangedDo: [ :m | self modeChanged ].
		
	" action when  text change (Observable slot) "
	self whenTextChangedDo: [ :t | self textChanged ]
]

{ #category : #testing }
AlbEditorModel >> isEditable [
	^ mode isEditable 
]

{ #category : #testing }
AlbEditorModel >> isReadOnly [
	^ mode isReadOnly 
]

{ #category : #accessing }
AlbEditorModel >> mode [

	^ mode
]

{ #category : #initialization }
AlbEditorModel >> modeChanged [

	wordStencil := self defaultWordStencil.
	self withEditorElementDo: [ :element | 
			 element editor whenEditionModeChanged: self mode.
			 self setupEventHandlersForElement: element.
			 self setupShortcutsInTextEditor: element editor.
			 element selectionView: self defaultSelectionView ]
]

{ #category : #'api - hooks' }
AlbEditorModel >> onInstalledIn: anElement [

	"Is sent when I am added to an element "

	super onInstalledIn: anElement.

	anElement selectionView: self defaultSelectionView.

	self when: AlbActionRequiredFromEditorElement send: #whenActionRequired: to: anElement.

	" element related event handlers "
	self setupEventHandlersForElement: anElement.

	" editor related event handler: text insertion/deletion "
	editorEventHandler := BlEventHandler
		                      on: AlbTextModifiedEvent
		                      do: [ :anEvent | self textModifiedByTextEditor ].
	anElement editor addEventHandler: editorEventHandler.

	" current mode compatible shortcuts "
	self setupShortcutsInTextEditor: anElement editor
]

{ #category : #'api - hooks' }
AlbEditorModel >> onUninstalledIn: anElement [

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
AlbEditorModel >> requestSave [

	self announce: (AlbSaveRequested new viewModel: self).
	self saveResult: true
]

{ #category : #'api-transaction' }
AlbEditorModel >> saveResult: aBoolean [

	| announcement |
	self hasUnacceptedEdits: aBoolean not.
	announcement := aBoolean
		                ifTrue: [ AlbSaveAccepted new ]
		                ifFalse: [ AlbSaveDenied new ].
	self announce: (announcement viewModel: self).

]

{ #category : #'api - hooks' }
AlbEditorModel >> setupEventHandlersForElement: anElement [
	
	self elementEventHandlersDo: [ :e | anElement removeEventHandler: e ].
	elementEventHandlers := self defaultEditorElementEventHandlers.
	self elementEventHandlersDo: [ :e | 
		anElement addEventHandler: (e
				 element: anElement;
				 yourself) ]	

]

{ #category : #'api - hooks' }
AlbEditorModel >> setupShortcutsInTextEditor: aTextEditor [

	self shortcutsDo: [ :eachShortcut | aTextEditor removeEditorShortcut: eachShortcut ].
	shortcuts := self defaultShortcuts.
	self shortcutsDo: [ :eachShortcut | aTextEditor addEditorShortcut: eachShortcut ]
	
]

{ #category : #accessing }
AlbEditorModel >> shortcuts [

	^ shortcuts
]

{ #category : #accessing }
AlbEditorModel >> shortcutsDo: aBlock [

	shortcuts ifNotNil: [ shortcuts do: aBlock ]
]

{ #category : #accessing }
AlbEditorModel >> text [

	^ text
]

{ #category : #accessing }
AlbEditorModel >> text: aText [

	| t |
	t := aText.
	fontName ifNotNil: [ t fontName: self fontName ].
	text = t ifTrue: [ ^ self ].
	text := t
]

{ #category : #initialization }
AlbEditorModel >> textChanged [

	self withEditorElementDo: [ :element | element editor whenTextChanged: self text ]
]

{ #category : #'api - hooks' }
AlbEditorModel >> textModifiedByTextEditor [

	self hasUnacceptedEdits: true
]

{ #category : #'slot - change hook' }
AlbEditorModel >> whenModeChangedDo: aBlock [

	"set a block to perform after that the mode has been chanbed, and its action performed"

	self property: #mode whenChangedDo: aBlock
]

{ #category : #'slot - change hook' }
AlbEditorModel >> whenTextChangedDo: aBlock [

	"set a block to perform after that the text has been chanbed, and its action performed"

	self property: #text whenChangedDo: aBlock
]

{ #category : #initialization }
AlbEditorModel >> withEditorElementDo: aBlock [

	self announce: (AlbActionRequiredFromEditorElement new
			 valuable: aBlock;
			 yourself)
]

{ #category : #accessing }
AlbEditorModel >> wordStencil [

	<return: #AlbTextWordPieceStencil>
	^ wordStencil
]

{ #category : #accessing }
AlbEditorModel >> wordStencil: aWordStencil [

	wordStencil := aWordStencil
]
