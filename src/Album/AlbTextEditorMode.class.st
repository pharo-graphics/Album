Class {
	#name : #AlbTextEditorMode,
	#superclass : #Object,
	#instVars : [
		'eventHandlers',
		'shortcuts',
		'readonly',
		'allowSelection'
	],
	#category : #'Album-Model'
}

{ #category : #'text - copying' }
AlbTextEditorMode class >> editable [

	^ self new readonly: false
]

{ #category : #'text - copying' }
AlbTextEditorMode class >> readonly [

	^ self new readonly: true
]

{ #category : #'text - copying' }
AlbTextEditorMode class >> readonlyWithSelection [

	^ self new readonly: true
]

{ #category : #'text - copying' }
AlbTextEditorMode class >> readonlyWithoutSelection [

	^ self new
		  readonly: true;
		  allowSelection: false;
		  yourself
]

{ #category : #accessing }
AlbTextEditorMode >> allowSelection: aBoolean [

	allowSelection := aBoolean
]

{ #category : #initialization }
AlbTextEditorMode >> createEventHandlers [

	^ self isReadOnly
		  ifTrue: [ 
			  self isWithSelection
				  ifTrue: [ self eventHandlersForReadonly ]
				  ifFalse: [ self eventHandlersForReadonlyWithoutSelection ] ]
		  ifFalse: [ self eventHandlersForEditable ]
]

{ #category : #initialization }
AlbTextEditorMode >> createShortcuts [

	^ self isReadOnly
		  ifTrue: [ 
			  self isWithSelection
				  ifTrue: [ self shortcutsForReadonly ]
				  ifFalse: [ self shortcutsForReadonlyWithoutSelection ] ]
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
AlbTextEditorMode >> eventHandlersForReadonlyWithoutSelection [

	^ {  }
]

{ #category : #initialization }
AlbTextEditorMode >> initialize [
	super initialize.
	readonly := false.
	allowSelection := true
]

{ #category : #'api - hooks' }
AlbTextEditorMode >> installOnEditor: aTextEditor [

	aTextEditor wordStencil: (AlbTextWordPieceStencil forTextEditorMode: self).
	self shortcuts do: [ :eachShortcut | aTextEditor addEditorShortcut: eachShortcut ]
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

{ #category : #testing }
AlbTextEditorMode >> isWithSelection [
	^ allowSelection 
]

{ #category : #copying }
AlbTextEditorMode >> postCopy [
	"they will be initialized lazily later"
	eventHandlers := nil.
	shortcuts := shortcuts copy
]

{ #category : #testing }
AlbTextEditorMode >> readonly: aBoolean [

	readonly := aBoolean
]

{ #category : #'infinite element changes' }
AlbTextEditorMode >> selectionChangedIn: anEditorElement [
	allowSelection ifFalse: [ ^ self ].
	anEditorElement selectionView selectionChangedIn: anEditorElement
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
AlbTextEditorMode >> shortcutsForReadonly [

	^ { 
		  AlbEditorCopyShortcut new.
		  AlbEditorSelectAllShortcut new.
		  AlbEditorRemanentSelectionShortcut new.
		  AlbEditorDeselectAllShortcut new }
]

{ #category : #initialization }
AlbTextEditorMode >> shortcutsForReadonlyWithoutSelection [

	^ {  }
]

{ #category : #accessing }
AlbTextEditorMode >> textFrom: aBlText [
	^ aBlText
]

{ #category : #'api - hooks' }
AlbTextEditorMode >> uninstallFromEditor: aTextEditor [

	self shortcuts do: [ :eachShortcut |
		aTextEditor removeEditorShortcut: eachShortcut ]
]

{ #category : #'api - hooks' }
AlbTextEditorMode >> uninstallFromEditorElement: anEditorElement [

	self eventHandlers do: [ :eachEventHandler |
		anEditorElement removeEventHandler: eachEventHandler.
		eachEventHandler element: nil ]
]
