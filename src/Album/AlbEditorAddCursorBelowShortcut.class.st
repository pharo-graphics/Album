"
I add a cursor one line below the bottom-most cursor (Ctrl+Alt+Down, or Cmd+Alt+Down on macOS).
"
Class {
	#name : #AlbEditorAddCursorBelowShortcut,
	#superclass : #AlbEditorShortcut,
	#category : #'Album-Shortcuts'
}

{ #category : #'api - combination' }
AlbEditorAddCursorBelowShortcut >> combinationForMacOS [

	^ BlKeyCombination builder meta alt arrowDown build
]

{ #category : #accessing }
AlbEditorAddCursorBelowShortcut >> description [

	^ 'Adds a cursor one line below the bottom-most cursor.'
]

{ #category : #initialization }
AlbEditorAddCursorBelowShortcut >> initialize [

	super initialize.
	combination := BlKeyCombination builder control alt arrowDown build
]

{ #category : #accessing }
AlbEditorAddCursorBelowShortcut >> name [

	^ 'Add cursor below'
]

{ #category : #evaluation }
AlbEditorAddCursorBelowShortcut >> performOnEditor: aTextEditor element: anEditorElement dueTo: aShortcutEvent [

	| anIndex |
	anIndex := aTextEditor navigator
		findTextIndexBelowCursor: aTextEditor cursors last
		ifAbsent: [ ^ self ].
	aTextEditor deselecter
		all;
		deselect.
	aTextEditor addCursorAt: anIndex
]
