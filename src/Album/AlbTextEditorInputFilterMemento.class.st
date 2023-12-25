Class {
	#name : #AlbTextEditorInputFilterMemento,
	#superclass : #AlbTextEditorMemento,
	#instVars : [
		'inputFilter'
	],
	#category : 'Album-Model-Memento'
}

{ #category : #initialization }
AlbTextEditorInputFilterMemento >> initialize [
	super initialize.
	
	inputFilter := AlbTextEditorNoInputFilter new
]

{ #category : #evaluating }
AlbTextEditorInputFilterMemento >> label [
	^ 'Input filter'
]

{ #category : #accessing }
AlbTextEditorInputFilterMemento >> order [
	^ 50
]

{ #category : #memento }
AlbTextEditorInputFilterMemento >> restoreStateOf: aTextEditor [
	aTextEditor inputFilter: inputFilter
]

{ #category : #memento }
AlbTextEditorInputFilterMemento >> saveStateOf: aTextEditor [
	inputFilter := aTextEditor inputFilter
]

{ #category : #evaluating }
AlbTextEditorInputFilterMemento >> value [
	^ inputFilter
]
