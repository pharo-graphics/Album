Class {
	#name : #AlbTextEditorModeMemento,
	#superclass : #AlbTextEditorMemento,
	#instVars : [
		'mode'
	],
	#category : #'Album-Model-Memento'
}

{ #category : #initialization }
AlbTextEditorModeMemento >> initialize [
	super initialize.
	
	mode := AlbTextEditorMode new
]

{ #category : #evaluating }
AlbTextEditorModeMemento >> label [
	^ 'Mode'
]

{ #category : #accessing }
AlbTextEditorModeMemento >> order [
	^ 20
]

{ #category : #memento }
AlbTextEditorModeMemento >> restoreStateOf: aTextEditor [
	aTextEditor editorMode: mode copy
]

{ #category : #memento }
AlbTextEditorModeMemento >> saveStateOf: aTextEditor [
	mode := aTextEditor editorMode copy
]

{ #category : #evaluating }
AlbTextEditorModeMemento >> value [
	^ mode
]
