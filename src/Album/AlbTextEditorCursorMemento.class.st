Class {
	#name : #AlbTextEditorCursorMemento,
	#superclass : #AlbTextEditorMemento,
	#instVars : [
		'cursorPosition'
	],
	#category : #'Album-Model-Memento'
}

{ #category : #accessing }
AlbTextEditorCursorMemento >> cursorPosition: aNumber [
	cursorPosition := aNumber
]

{ #category : #initialization }
AlbTextEditorCursorMemento >> initialize [
	super initialize.
	
	cursorPosition := 0
]

{ #category : #evaluating }
AlbTextEditorCursorMemento >> label [
	^ 'Cursor'
]

{ #category : #accessing }
AlbTextEditorCursorMemento >> order [
	^ 80
]

{ #category : #memento }
AlbTextEditorCursorMemento >> restoreStateOf: aTextEditor [
	cursorPosition ifNotNil: [
		aTextEditor navigator
			withoutResettingDesiredCoordinate;
			moveTo: cursorPosition;
			apply ]
]

{ #category : #memento }
AlbTextEditorCursorMemento >> saveStateOf: aTextEditor [
	cursorPosition := aTextEditor cursor position
]

{ #category : #evaluating }
AlbTextEditorCursorMemento >> value [
	^ cursorPosition
]
