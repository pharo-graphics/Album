Class {
	#name : #AlbEditorModel,
	#superclass : #OBlViewModel,
	#instVars : [
		'styler',
		'text',
		'fontName',
		'shortcuts',
		'mode',
		'editorEventHandler',
		'wordStencil'
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
	mode := AlbEditableMode new.
	self announce: AlbEditionModeChanged new
]

{ #category : #accessing }
AlbEditorModel >> beReadonlyWithSelection [

	(mode isReadOnly and: [ mode allowSelection ]) ifTrue: [ ^ self ].
	mode := AlbReadonlyWithSelectionMode new.
	self announce: AlbEditionModeChanged new
]

{ #category : #accessing }
AlbEditorModel >> beReadonlyWithoutSelection [

	mode allowSelection ifFalse: [ ^ self ].
	mode := AlbReadonlyWithoutSelectionMode new.
	self announce: AlbEditionModeChanged new
]

{ #category : #initialization }
AlbEditorModel >> createShortcuts [

	^ mode shortcuts 
]

{ #category : #initialization }
AlbEditorModel >> defaultFontName [
	^ AeFontManager defaultFontFamilyName
]

{ #category : #initialization }
AlbEditorModel >> defaultStyler [

	^ nil
]

{ #category : #initialization }
AlbEditorModel >> defaultWordStencil [

	^ AlbTextWordPieceStencil forTextEditorModel: self
]

{ #category : #testing }
AlbEditorModel >> hasUnacceptedEdits [

	^ false
]

{ #category : #initialization }
AlbEditorModel >> initialize [
	super initialize.
	
	mode := AlbEditableMode new.
	text := '' asRopedText.
	fontName := self defaultFontName.
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

{ #category : #'api - hooks' }
AlbEditorModel >> onInstalledIn: anElement [

	"Is sent when I am added to an element "

	super onInstalledIn: anElement.
	
	self when: AlbTextChanged send: #whenTextChangedFromModel: to: anElement.
	self when: AlbTextStyleDone send: #whenTextStyleDoneFromModel: to: anElement.
	self when: AlbTextStyleRequested send: #whenTextStyleRequestedFromModel: to: anElement.
	self when: AlbEditionModeChanged  send: #whenEditionModeChangedFromModel: to: anElement.

	editorEventHandler := BlEventHandler
			 on: AlbTextModifiedEvent
			 do: [ :anEvent | self textModifiedByTextEditor ].
			
	anElement editor addEventHandler: editorEventHandler.
		
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

	self recreateShortcutsIn: anEditorElement.
	wordStencil := self defaultWordStencil.
]

{ #category : #'api - text style' }
AlbEditorModel >> privateLaunchTextStyleFromElement: anElement [

	" see resquestTextStyle comments "

	styler ifNil: [ ^ self ].
	self styler launchStyle: self text nextGeneration in: anElement
]

{ #category : #'api - hooks' }
AlbEditorModel >> recreateShortcutsIn: anEditorElement [

	self shortcuts do: [ :eachShortcut | anEditorElement editor removeEditorShortcut: eachShortcut ].
	shortcuts := nil.
	self shortcuts do: [ :eachShortcut | anEditorElement editor addEditorShortcut: eachShortcut ]
	
]

{ #category : #'api - text style' }
AlbEditorModel >> requestTextStyle [

	" since text styler launcher need an element to launch styling, this announce is sent to ask the editorElement to launch styling by sending back #privateLaunchTextStyleFromElement: to self "

	styler ifNil: [ ^ self ].
	self announce: AlbTextStyleRequested new
]

{ #category : #'infinite element changes' }
AlbEditorModel >> selectionChangedIn: anEditorElement [

	self allowSelection ifFalse: [ ^ self ].
	anEditorElement selectionView selectionChangedIn: anEditorElement
]

{ #category : #accessing }
AlbEditorModel >> shortcuts [
	^ shortcuts ifNil: [ shortcuts := self createShortcuts ]
]

{ #category : #accessing }
AlbEditorModel >> styler [

	^ styler
]

{ #category : #accessing }
AlbEditorModel >> styler: aStyler [

	styler = aStyler ifTrue: [ ^ self ].
	styler ifNotNil: [ styler unsubscribe: self ].
	styler := aStyler.
	styler ifNotNil: [ 
		styler when: BlStylerTextStyled send: #whenTextStyled: to: self.
		styler when: BlStylerStateChanged send: #whenStylerStateChanged: to: self ].
	self announce: (AlbStylerChanged new styler: self styler).
	self requestTextStyle
]

{ #category : #accessing }
AlbEditorModel >> text [
	^ text
]

{ #category : #accessing }
AlbEditorModel >> text: aText [
	text = aText ifTrue: [ ^ self ].
	text := aText.
	self announce: (AlbTextChanged new text: self text)
]

{ #category : #'api - hooks' }
AlbEditorModel >> textModifiedByTextEditor [

	self requestTextStyle
]

{ #category : #'api - text style' }
AlbEditorModel >> whenStylerStateChanged: anAnnouncement [

	"the internal configuration of the styler has changed"

	self requestTextStyle
]

{ #category : #'api - text style' }
AlbEditorModel >> whenTextStyled: anAnnouncement [

	| styledText |
	styledText := anAnnouncement styledText.
	" text just styled by the styler"
	(styledText isNextGenerationOf: self text) ifFalse: [ ^ false ].
	"change only the rope to keep text reference untouched"
	self text rope: styledText text rope.
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
