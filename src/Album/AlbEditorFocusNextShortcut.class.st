Class {
	#name : #AlbEditorFocusNextShortcut,
	#superclass : #AlbEditorShortcut,
	#category : #'Album-Shortcuts'
}

{ #category : #accessing }
AlbEditorFocusNextShortcut >> description [
	^ 'Gives focus to the next focusable element.'
]

{ #category : #initialization }
AlbEditorFocusNextShortcut >> initialize [
	super initialize.
	
	combination := BlKeyCombination arrowRight
]

{ #category : #accessing }
AlbEditorFocusNextShortcut >> name [
	^ 'Focus next'
]

{ #category : #evaluation }
AlbEditorFocusNextShortcut >> performOnEditor: aTextEditor element: aEditorElement dueTo: aShortcutEvent [

	aEditorElement
		nextSiblingSuchThat: [ :eachElement | eachElement isFocusable ]
		do: [ :anElement | anElement requestFocus ]
]
