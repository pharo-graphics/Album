Class {
	#name : #AlbTextEditorSelectionMemento,
	#superclass : #AlbTextEditorMemento,
	#instVars : [
		'selection'
	],
	#category : 'Album-Model-Memento'
}

{ #category : #initialization }
AlbTextEditorSelectionMemento >> initialize [
	super initialize.
	
	selection := BlCompositeSelection new
]

{ #category : #testing }
AlbTextEditorSelectionMemento >> isSelectionMemento [
	^ true
]

{ #category : #evaluating }
AlbTextEditorSelectionMemento >> label [
	^ 'Selection'
]

{ #category : #accessing }
AlbTextEditorSelectionMemento >> order [
	^ 70
]

{ #category : #memento }
AlbTextEditorSelectionMemento >> restoreStateOf: aTextEditor [
	aTextEditor deselecter all deselect.

	aTextEditor selecter
		withoutCursorUpdate;
		all: selection;
		select
]

{ #category : #memento }
AlbTextEditorSelectionMemento >> saveStateOf: aTextEditor [
	selection := aTextEditor selection copy.
]

{ #category : #accessing }
AlbTextEditorSelectionMemento >> selection [
	^ selection
]

{ #category : #accessing }
AlbTextEditorSelectionMemento >> selection: anObject [
	selection := anObject
]

{ #category : #evaluating }
AlbTextEditorSelectionMemento >> value [
	^ selection
]
