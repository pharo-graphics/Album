Class {
	#name : #AlbTextEditorShortcutsMemento,
	#superclass : #AlbTextEditorMemento,
	#instVars : [
		'shortcuts'
	],
	#category : #'Album-Model-Memento'
}

{ #category : #initialization }
AlbTextEditorShortcutsMemento >> initialize [
	super initialize.
	
	shortcuts := AlbTextEditorShortcuts new
]

{ #category : #evaluating }
AlbTextEditorShortcutsMemento >> label [
	^ 'Shortcuts'
]

{ #category : #accessing }
AlbTextEditorShortcutsMemento >> order [
	^ 10
]

{ #category : #memento }
AlbTextEditorShortcutsMemento >> restoreStateOf: aTextEditor [
	aTextEditor setEditorShortcuts: shortcuts copy
]

{ #category : #memento }
AlbTextEditorShortcutsMemento >> saveStateOf: aTextEditor [
	shortcuts := aTextEditor editorShortcuts copy
]

{ #category : #evaluating }
AlbTextEditorShortcutsMemento >> value [
	^ shortcuts
]
