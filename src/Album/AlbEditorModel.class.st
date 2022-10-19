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
		'#elementEventHandlers',
		'#stylerHolder'
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
AlbEditorModel >> defaultStyler [

	^ nil
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

	fontName := aFontName.
	self stylerHolder fontName: aFontName 
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

	" action when  mode change "
	self whenModeChangedDo: [ :m | 
		self announce: (AlbActionRequiredFromEditorElement new valuable: [ :element | 
				 element editor whenEditionModeChanged: self mode.
				 self setupEventHandlersForElement: element.
				 wordStencil := self defaultWordStencil.
				 self setupShortcutsInTextEditor: element editor.
				 element selectionView: self defaultSelectionView.
				 stylerHolder styler: self defaultStyler.
				 stylerHolder unstyledText: self text nextGeneration ]) ].

	" action when  text change"
	self whenTextChangedDo: [ :t | 
		self announce: (AlbActionRequiredFromEditorElement new valuable: [ :element | 
				 element editor whenTextChanged: self text.
				 " ask the stylerClient to style through its observal slot"
				 stylerHolder unstyledText: self text nextGeneration ]) ]
]

{ #category : #testing }
AlbEditorModel >> isEditable [
	^ mode isEditable 
]

{ #category : #testing }
AlbEditorModel >> isReadOnly [
	^ mode isReadOnly 
]

{ #category : #'text style' }
AlbEditorModel >> launchTextStyle [

	" ask the stylerHolder through its observale slot "

	stylerHolder unstyledText: self text
]

{ #category : #accessing }
AlbEditorModel >> mode [

	^ mode
]

{ #category : #'api - hooks' }
AlbEditorModel >> onInstalledIn: anElement [

	"Is sent when I am added to an element "

	super onInstalledIn: anElement.

	stylerHolder := AlbStylerHolder new
		                referentElement: anElement;
		                styler: self defaultStyler;
		                yourself.
	
	stylerHolder whenStyledTextChangedDo: [ :styledText | 
		self text takeInternalRepresentationOf: styledText.
		self announce: (AlbActionRequiredFromEditorElement new valuable: [ :element | element textInternalRepresentationChanged ]) ].

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
	stylerHolder := nil.
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
AlbEditorModel >> stylerHolder [

	^ stylerHolder
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
	text := t.
	self launchTextStyle
]

{ #category : #'api - hooks' }
AlbEditorModel >> textModifiedByTextEditor [

	self launchTextStyle.
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

{ #category : #accessing }
AlbEditorModel >> wordStencil [

	<return: #AlbTextWordPieceStencil>
	^ wordStencil
]

{ #category : #accessing }
AlbEditorModel >> wordStencil: aWordStencil [

	wordStencil := aWordStencil
]
