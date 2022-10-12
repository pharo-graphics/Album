Class {
	#name : #AlbEditorModel,
	#superclass : #OBlViewModel,
	#instVars : [
		'styler',
		'text',
		'fontName',
		'readonly',
		'allowSelection',
		'shortcuts'
	],
	#category : #'Album-Model'
}

{ #category : #accessing }
AlbEditorModel >> allowSelection: aBoolean [

	allowSelection = aBoolean ifTrue: [ ^ self ].
	allowSelection := aBoolean.
	self announce: AlbEditorEditabilityChanged new
]

{ #category : #'api - hooks' }
AlbEditorModel >> applyEditabilityChangeIn: anEditorElement [

	self recreateShortcutsIn: anEditorElement.
	anEditorElement editor wordStencil: self defaultWordStencil.
]

{ #category : #initialization }
AlbEditorModel >> createShortcuts [

	^ self isReadOnly
		  ifTrue: [ 
			  self isWithSelection
				  ifTrue: [ self shortcutsForReadonly ]
				  ifFalse: [ self shortcutsForReadonlyWithoutSelection ] ]
		  ifFalse: [ self shortcutsForEditable ]
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

{ #category : #initialization }
AlbEditorModel >> initialize [
	super initialize.
	
	readonly := false.
	allowSelection := true.
	text := '' asRopedText.
	fontName := self defaultFontName.
	styler := self defaultStyler
]

{ #category : #testing }
AlbEditorModel >> isEditable [
	^ readonly not
]

{ #category : #testing }
AlbEditorModel >> isReadOnly [
	^ readonly
]

{ #category : #testing }
AlbEditorModel >> isWithSelection [
	^ allowSelection 
]

{ #category : #'api - hooks' }
AlbEditorModel >> onInstalledIn: anElement [

	"Is sent when I am added to an element "

	super onInstalledIn: anElement.
	
	self when: AlbEditorTextChanged send: #whenTextChangedFromModel: to: anElement.
	self when: AlbEditorStylerChanged send: #whenStylerChangedFromModel: to: anElement.
	self when: AlbEditorEditabilityChanged  send: #whenEditabilityChangedFromModel: to: anElement.
	
	anElement editor wordStencil: self defaultWordStencil.

	self shortcuts do: [ :eachShortcut | anElement editor addEditorShortcut: eachShortcut ]
]

{ #category : #'api - hooks' }
AlbEditorModel >> onUninstalledIn: anElement [

	"Is sent when I am removed from an element "

	super onUninstalledIn: anElement.
	self unsubscribe: anElement editor.
	self shortcuts do: [ :eachShortcut | anElement editor removeEditorShortcut: eachShortcut ]
]

{ #category : #copying }
AlbEditorModel >> postCopy [
	"they will be initialized lazily later"
	shortcuts := shortcuts copy 
]

{ #category : #accessing }
AlbEditorModel >> readonly: aBoolean [

	readonly = aBoolean ifTrue: [ ^ self ].
	readonly := aBoolean.
	self announce: AlbEditorEditabilityChanged new
]

{ #category : #'api - hooks' }
AlbEditorModel >> recreateShortcutsIn: anEditorElement [

	self shortcuts do: [ :eachShortcut | anEditorElement editor removeEditorShortcut: eachShortcut ].
	shortcuts := nil.
	self shortcuts do: [ :eachShortcut | anEditorElement editor addEditorShortcut: eachShortcut ]
	
]

{ #category : #'infinite element changes' }
AlbEditorModel >> selectionChangedIn: anEditorElement [
	allowSelection ifFalse: [ ^ self ].
	anEditorElement selectionView selectionChangedIn: anEditorElement
]

{ #category : #accessing }
AlbEditorModel >> shortcuts [
	^ shortcuts ifNil: [ shortcuts := self createShortcuts ]
]

{ #category : #initialization }
AlbEditorModel >> shortcutsForEditable [

	^ { 
		  AlbEditorDeleteOneLetterAfterCursorShortcut new.
		  AlbEditorDeleteOneLetterBeforeCursorShortcut new.
		  AlbEditorShiftRightShortcut new.
		  AlbEditorCutShortcut new.
		  AlbEditorCopyShortcut new.
		  AlbEditorPasteShortcut new.
		  AlbEditorUndoShortcut new.
		  AlbEditorRedoShortcut new.
		  AlbEditorCarriageReturnShortcut new.
		  AlbEditorMoveCursorLeftShortcut new.
		  AlbEditorMoveCursorRightShortcut new.
		  AlbEditorMoveCursorUpShortcut new.
		  AlbEditorMoveCursorDownShortcut new.
		  AlbEditorMoveCursorToPreviousWordShortcut new.
		  AlbEditorMoveCursorToNextWordShortcut new.
		  AlbEditorMoveCursorToLineStartShortcut new.
		  AlbEditorMoveCursorToLineEndShortcut new.

		  AlbEditorSelectAllShortcut new.
		  AlbEditorRemanentSelectionShortcut new.
		  AlbEditorDeselectAllShortcut new.
		  AlbEditorSelectLetterAfterCursorShortcut new.
		  AlbEditorSelectLetterBeforeCursorShortcut new.
		  AlbEditorSelectWordBeforeCursorShortcut new.
		  AlbEditorSelectWordAfterCursorShortcut new.
		  AlbEditorSelectLineBeforeCursorShortcut new.
		  AlbEditorSelectLineAfterCursorShortcut new.
		  AlbEditorSelectLineBelowCursorShortcut new.
		  AlbEditorSelectLineAboveCursorShortcut new }
]

{ #category : #initialization }
AlbEditorModel >> shortcutsForReadonly [

	^ { 
		  AlbEditorCopyShortcut new.
		  AlbEditorSelectAllShortcut new.
		  AlbEditorRemanentSelectionShortcut new.
		  AlbEditorDeselectAllShortcut new }
]

{ #category : #initialization }
AlbEditorModel >> shortcutsForReadonlyWithoutSelection [

	^ {  }
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

{ #category : #accessing }
AlbEditorModel >> textStyled: aText [
	" nothing to do here because the text is already up-to-date "

]
