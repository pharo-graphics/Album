Class {
	#name : #AlbTextEditorStylerMemento,
	#superclass : #AlbTextEditorMemento,
	#instVars : [
		'styler'
	],
	#category : #'Album-Model-Memento'
}

{ #category : #initialization }
AlbTextEditorStylerMemento >> initialize [
	super initialize.
	
	styler := BlTextNullStyler new
]

{ #category : #evaluating }
AlbTextEditorStylerMemento >> label [
	^ 'Styler'
]

{ #category : #accessing }
AlbTextEditorStylerMemento >> order [
	^ 40
]

{ #category : #memento }
AlbTextEditorStylerMemento >> restoreStateOf: aTextEditor [
	aTextEditor styler: styler
]

{ #category : #memento }
AlbTextEditorStylerMemento >> saveStateOf: aTextEditor [
	styler := aTextEditor styler
]

{ #category : #accessing }
AlbTextEditorStylerMemento >> styler: anObject [
	styler := anObject
]

{ #category : #evaluating }
AlbTextEditorStylerMemento >> value [
	^ styler
]
