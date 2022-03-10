Class {
	#name : #AlbEditorFocusPreviousShortcut,
	#superclass : #AlbEditorShortcut,
	#category : #'Album-Editor-Shortcuts'
}

{ #category : #accessing }
AlbEditorFocusPreviousShortcut >> description [
	^ 'Gives focus to the previous focusable element.'
]

{ #category : #initialization }
AlbEditorFocusPreviousShortcut >> initialize [
	super initialize.
	
	combination := BlKeyCombination arrowLeft
]

{ #category : #accessing }
AlbEditorFocusPreviousShortcut >> name [
	^ 'Focus previous'
]

{ #category : #evaluation }
AlbEditorFocusPreviousShortcut >> performOnEditor: aTextEditor element: aEditorElement dueTo: aShortcutEvent [
	aEditorElement
		previousSiblingSuchThat: [ :eachElement | eachElement isFocusable ]
		do: [ :anElement | anElement requestFocus ]
]
