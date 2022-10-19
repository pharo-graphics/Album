Class {
	#name : #AlbEditableMode,
	#superclass : #AlbEditabilityMode,
	#category : #'Album-Model'
}

{ #category : #testing }
AlbEditableMode >> allowSelection [

	^ true
]

{ #category : #initialization }
AlbEditableMode >> defaultEditorElementEventHandlers [

	^ { 
		  AlbTextEditorMouseHandler new.
		  AlbTextEditorDoubleClickHandler new.
		  AlbTextEditorSelectionHandler new.
		  AlbTextEditorInsertionHandler new.
		  AlbTextEditorCursorIconHandler new.
		  AlbTextEditorFocusHandler new }
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
		
		  AlbEditorSaveShortcut new.

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
AlbEditableMode >> defaultWordStencil [ 

	^ AlbTextWordPieceStencil editable
]

{ #category : #testing }
AlbEditableMode >> isEditable [

	^ true
]