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
		'#wordStencil'
	],
	#category : #'Album-Model'
}

{ #category : #testing }
AlbEditorModel >> allowSelection [ 
	^ mode allowSelection  
]

{ #category : #accessing }
AlbEditorModel >> beEditable [

	mode isEditable ifTrue: [ ^ self ].
	mode := AlbEditableMode new
]

{ #category : #accessing }
AlbEditorModel >> beReadonlyWithSelection [

	(mode isReadOnly and: [ mode allowSelection ]) ifTrue: [ ^ self ].
	mode := AlbReadonlyWithSelectionMode new
]

{ #category : #accessing }
AlbEditorModel >> beReadonlyWithoutSelection [

	mode allowSelection ifFalse: [ ^ self ].
	mode := AlbReadonlyWithoutSelectionMode new
]

{ #category : #initialization }
AlbEditorModel >> createShortcuts [

	^ mode shortcuts 
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

{ #category : #initialization }
AlbEditorModel >> editorElementEventHandlers [

	^ self mode editorElementEventHandlers
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

	" Observable slot "
	self whenTextChangedDo: [ :t | anElement whenTextChangedFromModel ].
	" Observable slot "
	self whenModeChangedDo: [ :m | anElement whenEditionModeChangedFromModel ].
	
	" Text styler "
	self when: AlbTextStyleDone send: #whenTextStyleDoneFromModel: to: anElement.
	self when: AlbTextStyleRequested send: #whenTextStyleRequestedFromModel: to: anElement.

	" editor related : text insertion/deletion "
	editorEventHandler := BlEventHandler
			 on: AlbTextModifiedEvent
			 do: [ :anEvent | self textModifiedByTextEditor ].			
	anElement editor addEventHandler: editorEventHandler.
	
	" current mode compatible shortcuts "	
	self shortcuts do: [ :eachShortcut | anElement editor addEditorShortcut: eachShortcut ]
]

{ #category : #'api - hooks' }
AlbEditorModel >> onUninstalledIn: anElement [

	"Is sent when I am removed from an element "

	super onUninstalledIn: anElement.
	self shortcuts do: [ :eachShortcut | anElement editor removeEditorShortcut: eachShortcut ].
	anElement editor removeEventHandler: editorEventHandler.
	editorEventHandler := nil
]

{ #category : #copying }
AlbEditorModel >> postCopy [
	"they will be initialized lazily later"
	shortcuts := shortcuts copy 
]

{ #category : #'api - hooks' }
AlbEditorModel >> privateEditionModeChangedFromElement: anEditorElement [

	wordStencil := self defaultWordStencil.	
	self recreateShortcutsInTextEditor: anEditorElement editor.
	anEditorElement selectionView: self defaultSelectionView 

]

{ #category : #'api - text style' }
AlbEditorModel >> privateLaunchTextStyleFromElement: anElement [

	" see resquestTextStyle comments "

	styler ifNil: [ ^ self ].
	self launchStyle: self text nextGeneration in: anElement
]

{ #category : #'api - text style' }
AlbEditorModel >> privateTextChangedFromElement:  anElement [

	self privateLaunchTextStyleFromElement: anElement

]

{ #category : #'api - hooks' }
AlbEditorModel >> recreateShortcutsInTextEditor: aTextEditor [

	self shortcuts do: [ :eachShortcut | aTextEditor removeEditorShortcut: eachShortcut ].
	shortcuts := nil.
	self shortcuts do: [ :eachShortcut | aTextEditor addEditorShortcut: eachShortcut ]
	
]

{ #category : #'api - text style' }
AlbEditorModel >> requestTextStyle [

	" since text styler launcher need an element to launch styling, this announce is sent to ask the editorElement to launch styling by sending back #privateLaunchTextStyleFromElement: to self "

	styler ifNil: [ ^ self ].
	self announce: AlbTextStyleRequested new
]

{ #category : #accessing }
AlbEditorModel >> shortcuts [
	^ shortcuts ifNil: [ shortcuts := self createShortcuts ]
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
