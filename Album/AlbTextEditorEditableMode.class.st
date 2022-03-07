Class {
	#name : #AlbTextEditorEditableMode,
	#superclass : #AlbTextEditorBasicMode,
	#category : #'Album-Editor-Model'
}

{ #category : #initialization }
AlbTextEditorEditableMode >> createEventHandlers [
	^ super createEventHandlers, {
		BrTextEditorMouseDownHandler uniqueInstance.
		BrTextEditorDoubleClickHandler uniqueInstance.
		BrTextEditorSelectionHandler new.
		BrTextEditorInsertionHandler uniqueInstance.
		BrTextEditorCursorIconHandler uniqueInstance.
	}
]

{ #category : #initialization }
AlbTextEditorEditableMode >> initialize [
	super initialize.

	shortcuts := shortcuts, {
		BrEditorDeleteOneLetterAfterCursorShortcut new.
		BrEditorDeleteOneLetterBeforeCursorShortcut new.
		BrEditorShiftRightShortcut new.
		BrEditorCutShortcut new.
		BrEditorCopyShortcut new.
		BrEditorPasteShortcut new.
		BrEditorUndoShortcut new.
		BrEditorRedoShortcut new.
	
		self returnKeyAndAction.
		
		BrEditorMoveCursorLeftShortcut new.
		BrEditorMoveCursorRightShortcut new.
		BrEditorMoveCursorUpShortcut new.
		BrEditorMoveCursorDownShortcut new.
		BrEditorMoveCursorToPreviousWordShortcut new.
		BrEditorMoveCursorToNextWordShortcut new.
		BrEditorMoveCursorToLineStartShortcut new.
		BrEditorMoveCursorToLineEndShortcut new.
		
		BrEditorSelectAllShortcut new.
		BrEditorDeselectAllShortcut new.
		BrEditorSelectLetterAfterCursorShortcut new.
		BrEditorSelectLetterBeforeCursorShortcut new.
		BrEditorSelectWordBeforeCursorShortcut new.
		BrEditorSelectWordAfterCursorShortcut new.
		BrEditorSelectLineBeforeCursorShortcut new.
		BrEditorSelectLineAfterCursorShortcut new.
		BrEditorSelectLineBelowCursorShortcut new.
		BrEditorSelectLineAboveCursorShortcut new.
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
	^ BrEditorLineEndingShortcut new
]
