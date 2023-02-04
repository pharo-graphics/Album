Class {
	#name : #AlbEditableMode,
	#superclass : #AlbEditabilityMode,
	#category : #'Album-UI'
}

{ #category : #initialization }
AlbEditableMode >> defaultEditorElementEventHandlers [

	^ { 
		  AlbTextEditorMouseHandler new.
		  AlbTextEditorDoubleClickHandler new.
		  AlbTextEditorInsertionHandler new.
		  AlbTextEditorCursorIconHandler new.
		  AlbTextEditorFocusHandler new }
]

{ #category : #initialization }
AlbEditableMode >> defaultFrontLayerEventHandlers [

	^ { 
		  AlbTextEditorSelectionHandler new }
]

{ #category : #'shortcut management' }
AlbEditableMode >> defaultShortcuts [

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
AlbEditableMode >> defaultWordStencil [ 

	^ AlbTextWordPieceStencil editable
]
