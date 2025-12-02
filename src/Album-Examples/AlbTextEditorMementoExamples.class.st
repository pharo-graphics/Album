Class {
	#name : #AlbTextEditorMementoExamples,
	#superclass : #TestCase,
	#category : #'Album-Examples-Model'
}

{ #category : #'examples - memento' }
AlbTextEditorMementoExamples >> editorSaveState [
	
	| aTextEditor aMemento |
	
	aTextEditor := self testEditorWithState.
	aMemento := aTextEditor saveState.
	
	^ aMemento
]

{ #category : #'examples - memento' }
AlbTextEditorMementoExamples >> testEditorRestoreState [
	
	| aMemento aTextEditor |
	aMemento := self editorSaveState.
	aTextEditor :=  AlbTextEditor new.
	aTextEditor restoreState: aMemento.
	^ aTextEditor
]

{ #category : #'instance creation' }
AlbTextEditorMementoExamples >> testEditorWithState [

	| aTextEditor |
	aTextEditor := AlbTextEditor new privateText: 'Hello world' asRopedText.

	aTextEditor navigator
		moveTo: 1;
		moveTo: 9;
		apply.

	aTextEditor selecter
		from: 3 to: 8;
		withoutCursorUpdate;
		select.

	^ aTextEditor
]
