"
I add a cursor one line above the top-most cursor (Ctrl+Alt+Up, or Cmd+Alt+Up on macOS).
"
Class {
	#name : #AlbEditorAddCursorAboveShortcut,
	#superclass : #AlbEditorShortcut,
	#category : #'Album-Shortcuts'
}

{ #category : #'api - combination' }
AlbEditorAddCursorAboveShortcut >> combinationForMacOS [

	^ BlKeyCombination builder meta alt arrowUp build
]

{ #category : #accessing }
AlbEditorAddCursorAboveShortcut >> description [

	^ 'Adds a cursor one line above the top-most cursor.'
]

{ #category : #initialization }
AlbEditorAddCursorAboveShortcut >> initialize [

	super initialize.
	combination := BlKeyCombination builder control alt arrowUp build
]

{ #category : #accessing }
AlbEditorAddCursorAboveShortcut >> name [

	^ 'Add cursor above'
]

{ #category : #evaluation }
AlbEditorAddCursorAboveShortcut >> performOnEditor: aTextEditor element: anEditorElement dueTo: aShortcutEvent [

	| anIndex |
	anIndex := aTextEditor navigator
		findTextIndexAboveCursor: aTextEditor cursors first
		ifAbsent: [ ^ self ].
	aTextEditor deselecter
		all;
		deselect.
	aTextEditor addCursorAt: anIndex
]
