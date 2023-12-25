Class {
	#name : #AlbTextEditorHistoryMemento,
	#superclass : #AlbTextEditorMemento,
	#instVars : [
		'history'
	],
	#category : 'Album-Model-Memento'
}

{ #category : #initialization }
AlbTextEditorHistoryMemento >> initialize [
	super initialize.
	
	history := AlbTextEditorHistory new
]

{ #category : #evaluating }
AlbTextEditorHistoryMemento >> label [
	^ 'History'
]

{ #category : #accessing }
AlbTextEditorHistoryMemento >> order [
	^ 30
]

{ #category : #memento }
AlbTextEditorHistoryMemento >> restoreStateOf: aTextEditor [
	aTextEditor history: history
]

{ #category : #memento }
AlbTextEditorHistoryMemento >> saveStateOf: aTextEditor [
	history := aTextEditor history
]

{ #category : #evaluating }
AlbTextEditorHistoryMemento >> value [
	^ history
]
