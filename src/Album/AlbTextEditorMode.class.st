Class {
	#name : #AlbTextEditorMode,
	#superclass : #Object,
	#instVars : [
		'eventHandlers',
		'shortcuts',
		'readonly'
	],
	#category : #'Album-Model'
}

{ #category : #initialization }
AlbTextEditorMode >> createEventHandlers [

	^ self isReadOnly
		  ifTrue: [ self eventHandlersForReadonly ]
		  ifFalse: [ self eventHandlersForEditable ]
]

{ #category : #initialization }
AlbTextEditorMode >> createShortcuts [

	^ self isReadOnly
		  ifTrue: [ self shortcutsForReadonly ]
		  ifFalse: [ self shortcutsForEditable ]
]

{ #category : #initialization }
AlbTextEditorMode >> eventHandlers [
	^ eventHandlers ifNil: [ eventHandlers := self createEventHandlers ]
]

{ #category : #initialization }
AlbTextEditorMode >> eventHandlersForEditable [

	^ { 
		  AlbTextEditorMouseDownHandler new.
		  AlbTextEditorDoubleClickHandler new.
		  AlbTextEditorSelectionHandler new.
		  AlbTextEditorInsertionHandler new.
		  AlbTextEditorCursorIconHandler new }
]

{ #category : #initialization }
AlbTextEditorMode >> eventHandlersForReadonly [

	^ { 
		  AlbTextEditorMouseDownHandler new.
		  AlbTextEditorDoubleClickHandler new.
		  AlbTextEditorSelectionHandler new.
		  AlbTextEditorCursorIconHandler new }
]

{ #category : #initialization }
AlbTextEditorMode >> initialize [
	super initialize.
	readonly := false
]

{ #category : #'api - hooks' }
AlbTextEditorMode >> installOnEditor: aTextEditor [

	aTextEditor wordStencil: (AlbTextWordPieceStencil forTextEditorMode: self).
	self shortcuts do: [ :eachInteraction | aTextEditor addEditorShortcut: eachInteraction ]
]

{ #category : #'api - hooks' }
AlbTextEditorMode >> installOnEditorElement: anEditorElement [

	self eventHandlers do: [ :eachEventHandler |
		eachEventHandler element: anEditorElement.
		anEditorElement addEventHandler: eachEventHandler ]
]

{ #category : #testing }
AlbTextEditorMode >> isEditable [
	^ readonly not
]

{ #category : #testing }
AlbTextEditorMode >> isReadOnly [
	^ readonly
]

{ #category : #copying }
AlbTextEditorMode >> postCopy [
	"they will be initialized lazily later"
	eventHandlers := nil.
	shortcuts := shortcuts copy
]

{ #category : #accessing }
AlbTextEditorMode >> shortcuts [
	^ shortcuts ifNil: [ shortcuts := self createShortcuts ]
]

{ #category : #initialization }
AlbTextEditorMode >> shortcutsForEditable [

	^ { 
		  AlbEditorDeleteOneLetterAfterCursorShortcut new.
		  AlbEditorDeleteOneLetterBeforeCursorShortcut new.
		  AlbEditorShiftRightShortcut new.
		  AlbEditorCutShortcut new.
		  AlbEditorCopyShortcut new.
		  AlbEditorPasteShortcut new.
		  AlbEditorUndoShortcut new.
		  AlbEditorRedoShortcut new.

		  self returnKeyAndAction.

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
AlbTextEditorMode >> shortcutsForReadonly [

	^ { 
		  AlbEditorCopyShortcut new.
		  AlbEditorSelectAllShortcut new.
		  AlbEditorRemanentSelectionShortcut new.
		  AlbEditorDeselectAllShortcut new }
]

{ #category : #'api - hooks' }
AlbTextEditorMode >> uninstallFromEditor: aTextEditor [

	self shortcuts do: [ :eachInteraction |
		aTextEditor removeEditorShortcut: eachInteraction ]
]

{ #category : #'api - hooks' }
AlbTextEditorMode >> uninstallFromEditorElement: anEditorElement [

	self eventHandlers do: [ :eachEventHandler |
		anEditorElement removeEventHandler: eachEventHandler.
		eachEventHandler element: nil ]
]

{ #category : #initialization }
AlbTextEditorMode >> withShortcuts: aCollectionOfShortcuts [
	shortcuts := self shortcuts, aCollectionOfShortcuts
]
