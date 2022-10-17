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

{ #category : #'api - hooks' }
AlbEditorModel >> applyEditabilityChangeIn: anEditorElement [

	self recreateShortcutsIn: anEditorElement.
	wordStencil := self defaultWordStencil.
]

{ #category : #accessing }
AlbEditorModel >> beEditable [

	mode isEditable ifTrue: [ ^ self ].
	mode := AlbEditorEditableMode new.
	self announce: AlbEditorEditabilityChanged new
]

{ #category : #accessing }
AlbEditorModel >> beReadonlyWithSelection [

	(mode isReadOnly and: [ mode allowSelection ]) ifTrue: [ ^ self ].
	mode := AlbEditorReadonlyWithSelectionMode new.
	self announce: AlbEditorEditabilityChanged new
]

{ #category : #accessing }
AlbEditorModel >> beReadonlyWithoutSelection [

	mode allowSelection ifFalse: [ ^ self ].
	mode := AlbEditorReadonlyWithoutSelectionMode new.
	self announce: AlbEditorEditabilityChanged new
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
	
	mode := AlbEditorEditableMode new.
	text := '' asRopedText.
	fontName := self defaultFontName.
	styler := self defaultStyler.
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
	
	self when: AlbEditorTextChanged send: #whenTextChangedFromModel: to: anElement.
	self when: AlbEditorStylerChanged send: #whenStylerChangedFromModel: to: anElement.
	self when: AlbEditorEditabilityChanged  send: #whenEditabilityChangedFromModel: to: anElement.

	editorEventHandler := BlEventHandler
			 on: AlbTextEditorModifiedEvent
			 do: [ :anEvent | self textEdited ].
			
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
AlbEditorModel >> recreateShortcutsIn: anEditorElement [

	self shortcuts do: [ :eachShortcut | anEditorElement editor removeEditorShortcut: eachShortcut ].
	shortcuts := nil.
	self shortcuts do: [ :eachShortcut | anEditorElement editor addEditorShortcut: eachShortcut ]
	
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

	styler := aStyler.
	self announce: (AlbEditorStylerChanged new styler: self styler)
]

{ #category : #accessing }
AlbEditorModel >> text [
	^ text
]

{ #category : #accessing }
AlbEditorModel >> text: aText [
	text = aText ifTrue: [ ^ self ].
	text := aText.
	self announce: (AlbEditorTextChanged new text: self text)
]

{ #category : #'api - hooks' }
AlbEditorModel >> textEdited [
]

{ #category : #accessing }
AlbEditorModel >> textStyled [
	" nothing to do here because the text is already up-to-date "

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
