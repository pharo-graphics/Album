Class {
	#name : #AlbEditorShiftRightShortcut,
	#superclass : #AlbEditorShortcut,
	#category : #'Album-Shortcuts'
}

{ #category : #accessing }
AlbEditorShiftRightShortcut >> description [
	^ 'Shift text at the cursor or if there is selection, the selected lines, one indetation to the right.'
]

{ #category : #initialization }
AlbEditorShiftRightShortcut >> initialize [
	super initialize.
	
	combination := BlKeyCombination tab
]

{ #category : #accessing }
AlbEditorShiftRightShortcut >> name [
	^ 'Shift right'
]

{ #category : #evaluation }
AlbEditorShiftRightShortcut >> performOnEditor: aTextEditor element: aEditorElement dueTo: aShortcutEvent [
	aTextEditor selection isEmpty
		ifTrue: [
			aTextEditor inserter
				atCursor;
				indentation;
				insert ]
		ifFalse: [
			aTextEditor inserter
				indentation;
				beforeSelectedLines;
				withoutSelectionDelete;
				insert ]
]
