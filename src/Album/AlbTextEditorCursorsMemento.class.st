Class {
	#name : 'AlbTextEditorCursorsMemento',
	#superclass : 'AlbTextEditorMemento',
	#instVars : [
		'cursors'
	],
	#category : 'Album-Model-Memento',
	#package : 'Album',
	#tag : 'Model-Memento'
}

{ #category : 'accessing' }
AlbTextEditorCursorsMemento >> cursors: anObject [
	cursors := anObject
]

{ #category : 'initialization' }
AlbTextEditorCursorsMemento >> initialize [
	super initialize.
	
	cursors := AlbTextEditorMultipleCursor new
]

{ #category : 'evaluating' }
AlbTextEditorCursorsMemento >> label [
	^ 'Cursors'
]

{ #category : 'accessing' }
AlbTextEditorCursorsMemento >> order [
	^ 80
]

{ #category : 'memento' }
AlbTextEditorCursorsMemento >> restoreStateOf: aTextEditor [
	aTextEditor navigator
		withoutResettingDesiredCoordinate;
		removeAll;
		addAll: cursors;
		apply
]

{ #category : 'memento' }
AlbTextEditorCursorsMemento >> saveStateOf: aTextEditor [
	cursors := aTextEditor cursors copy
]

{ #category : 'evaluating' }
AlbTextEditorCursorsMemento >> value [
	^ cursors
]
