Class {
	#name : #AlbEditorModel,
	#superclass : #OBlViewModel,
	#instVars : [
		'styler',
		'text',
		'fontName',
		'readonly',
		'allowSelection',
		'eventHandlers',
		'shortcuts'
	],
	#category : #'Album-Model'
}

{ #category : #initialization }
AlbEditorModel >> createEventHandlers [

	^ self isReadOnly
		  ifTrue: [ 
			  self isWithSelection
				  ifTrue: [ self eventHandlersForReadonly ]
				  ifFalse: [ self eventHandlersForReadonlyWithoutSelection ] ]
		  ifFalse: [ self eventHandlersForEditable ]
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
AlbEditorModel >> defaultTextEditorMode [
	^ AlbTextEditorMode new
]

{ #category : #initialization }
AlbEditorModel >> defaultWordStencil [

	^ AlbTextWordPieceStencil forTextEditorModel: self
]

{ #category : #initialization }
AlbEditorModel >> eventHandlers [
	^ eventHandlers ifNil: [ eventHandlers := self createEventHandlers ] 
]

{ #category : #initialization }
AlbEditorModel >> eventHandlersForEditable [

	^ { 
		  "AlbTextEditorShortcutHandler new.
		  AlbTextEditorTextStyleHandler new.
		  AlbTextEditorTextReplaceHandler new.
		  AlbTextEditorChangeHandler new."
		  AlbTextEditorMouseDownHandler new.
		  AlbTextEditorDoubleClickHandler new.
		  AlbTextEditorSelectionHandler new.
		  AlbTextEditorInsertionHandler new.
		  AlbTextEditorCursorIconHandler new }
]

{ #category : #initialization }
AlbEditorModel >> eventHandlersForReadonly [

	^ { 
		  AlbTextEditorMouseDownHandler new.
		  AlbTextEditorDoubleClickHandler new.
		  AlbTextEditorSelectionHandler new.
		  AlbTextEditorCursorIconHandler new }
]

{ #category : #initialization }
AlbEditorModel >> eventHandlersForReadonlyWithoutSelection [

	^ {  }
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
	anElement editor wordStencil: self defaultWordStencil.
	self eventHandlers do: [ :eachEventHandler | 
		eachEventHandler element: anElement.
		anElement addEventHandler: eachEventHandler ].
	self shortcuts do: [ :eachShortcut | anElement editor addEditorShortcut: eachShortcut ]
]

{ #category : #'api - hooks' }
AlbEditorModel >> onUninstalledIn: anElement [

	"Is sent when I am removed from an element "

	super onUninstalledIn: anElement.
	self shortcuts do: [ :eachShortcut | anElement editor removeEditorShortcut: eachShortcut ].
	self eventHandlers do: [ :eachEventHandler | 
		anElement removeEventHandler: eachEventHandler.
		eachEventHandler element: nil ]
]

{ #category : #copying }
AlbEditorModel >> postCopy [
	"they will be initialized lazily later"
	eventHandlers := nil.
	shortcuts := shortcuts copy 
]

{ #category : #testing }
AlbEditorModel >> readonly: aBoolean [

	readonly := aBoolean
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
	self dispatchEvent: (AlbEditorStylerChangedEvent styler: self styler)
]

{ #category : #accessing }
AlbEditorModel >> text [
	^ text
]

{ #category : #accessing }
AlbEditorModel >> text: aText [
	text = aText ifTrue: [ ^ self ].
	text := aText.
	self dispatchEvent: (AlbEditorTextChangedEvent text: self text)
]

{ #category : #accessing }
AlbEditorModel >> textStyled: aText [
	text := aText.
	self dispatchEvent: (AlbEditorTextStyledEvent text: self text)
]
