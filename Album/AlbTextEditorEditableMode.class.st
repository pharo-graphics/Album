Class {
	#name : #AlbTextEditorEditableMode,
	#superclass : #AlbTextEditorBasicMode,
	#category : #'Album-Editor-Model'
}

{ #category : #initialization }
AlbTextEditorEditableMode >> createEventHandlers [
	^ super createEventHandlers, {
		AlbTextEditorMouseDownHandler uniqueInstance.
		AlbTextEditorDoubleClickHandler uniqueInstance.
		AlbTextEditorSelectionHandler new.
		AlbTextEditorInsertionHandler uniqueInstance.
		AlbTextEditorCursorIconHandler uniqueInstance.
	}
]

{ #category : #initialization }
AlbTextEditorEditableMode >> initialize [
	super initialize.

	shortcuts := shortcuts, {
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
		AlbEditorDeselectAllShortcut new.
		AlbEditorSelectLetterAfterCursorShortcut new.
		AlbEditorSelectLetterBeforeCursorShortcut new.
		AlbEditorSelectWordBeforeCursorShortcut new.
		AlbEditorSelectWordAfterCursorShortcut new.
		AlbEditorSelectLineBeforeCursorShortcut new.
		AlbEditorSelectLineAfterCursorShortcut new.
		AlbEditorSelectLineBelowCursorShortcut new.
		AlbEditorSelectLineAboveCursorShortcut new.
	}
]

{ #category : #'api - hooks' }
AlbTextEditorEditableMode >> installOnEditor: aTextEditor [
	super installOnEditor: aTextEditor.

	aTextEditor segmentBuilder beEditable
]

{ #category : #testing }
AlbTextEditorEditableMode >> isEditable [
	^ true
]

{ #category : #defaults }
AlbTextEditorEditableMode >> returnKeyAndAction [
	^ AlbEditorLineEndingShortcut new
]
