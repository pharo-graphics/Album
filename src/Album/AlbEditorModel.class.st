Class {
	#name : #AlbEditorModel,
	#superclass : #OBlViewModel,
	#traits : 'TBlTextStylerClient + TObservable',
	#classTraits : 'TBlTextStylerClient classTrait + TObservable classTrait',
	#instVars : [
		'#text => ObservableSlot',
		'#mode => ObservableSlot',
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

	fontName := aFontName
]

{ #category : #testing }
AlbEditorModel >> hasUnacceptedEdits [

	^ false
]

{ #category : #initialization }
AlbEditorModel >> initialize [

	super initialize.
	self class initializeSlots: self.

	" fontName must be initialize before text "
	fontName := self defaultFontName.
	mode := self defaultMode.
	text := self defaultText.
	self styler: self defaultStyler.
	wordStencil := self defaultWordStencil.
	
	" action when styling done "
	self when: AlbTextStyleDone send: #whenTextStyleDone: to: self.
	
	" action when  mode change "
	self whenModeChangedDo: [ :m | 
		self announce: (AlbActionRequired new valuable: [ :element | 
				 element editor whenEditionModeChanged: self mode.
				 self setupEventHandlersForElement: element.
				 wordStencil := self defaultWordStencil.
				 self setupShortcutsInTextEditor: element editor.
				 element selectionView: self defaultSelectionView ]) ].

	" action when  text change"
	self whenTextChangedDo: [ :t | 
		self announce: (AlbActionRequired new valuable: [ :element | 
				 element editor whenTextChanged: self text.
				 self stylerDo: [ self launchStyle: self text nextGeneration in: element ] ]) ]
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

{ #category : #'api - hooks' }
AlbEditorModel >> onInstalledIn: anElement [

	"Is sent when I am added to an element "

	super onInstalledIn: anElement.
	
	anElement selectionView: self defaultSelectionView.

	self when: AlbActionRequired send: #whenActionRequired: to: anElement.

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
	anElement editor removeEventHandler: editorEventHandler.
	shortcuts := nil.
	editorEventHandler := nil.
	elementEventHandlers := nil
]

{ #category : #copying }
AlbEditorModel >> postCopy [
	"they will be initialized lazily later"
	shortcuts := shortcuts copy 
]

{ #category : #'api - text style' }
AlbEditorModel >> requestTextStyle [

	" since text styler launcher need an element to launch styling, this announce is sent to ask the editorElement to evaluate the valuable with itself as argument "

	self stylerDo: [ 
		self announce:
			(AlbActionRequired new valuable: [ :element | self launchStyle: self text nextGeneration in: element ]) ]
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

{ #category : #'api - text style' }
AlbEditorModel >> stylerDo: aBlock [

	styler ifNotNil: aBlock
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

{ #category : #'api - hooks' }
AlbEditorModel >> textModifiedByTextEditor [

	self requestTextStyle
]

{ #category : #'api - hooks' }
AlbEditorModel >> whenModeChangedDo: aBlock [
	"set a block to perform after that the mode has been chanbed, and its action performed"

	self property: #mode whenChangedDo: aBlock
]

{ #category : #'api - text style' }
AlbEditorModel >> whenStylerStateChanged: anAnnouncement [

	"the internal configuration of the styler has changed"

	self requestTextStyle
]

{ #category : #'api - hooks' }
AlbEditorModel >> whenTextChangedDo: aBlock [
	"set a block to perform after that the text has been chanbed, and its action performed"

	self property: #text whenChangedDo: aBlock
]

{ #category : #'api - text style' }
AlbEditorModel >> whenTextStyleDone: aTextStyleDoneAnnouncement [

	self announce: (AlbActionRequired new valuable: [ :element | 
			 element editor processCursorAttributes.
			 element editor updater
				 all;
				 update ])
]

{ #category : #'api - text style' }
AlbEditorModel >> whenTextStyled: anAnnouncement [

	| styledText |
	styledText := anAnnouncement styledText.
	" text just styled by the styler, check the generation (to be thread-safe) to ensure that my text has not be changed elsewhere during the styling "
	(styledText isNextGenerationOf: self text) ifFalse: [ ^ false ].
	"change only my internal representation to keep text reference with its original announcer "
	self text takeInternalRepresentationOf: styledText.
	"tell the world that the text has been styled again"
	self announce: (AlbTextStyleDone new styledText: self text).
	^ true
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
