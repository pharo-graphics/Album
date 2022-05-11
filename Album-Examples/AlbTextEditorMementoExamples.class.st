Class {
	#name : #AlbTextEditorMementoExamples,
	#superclass : #Object,
	#category : #'Album-Examples-Model'
}

{ #category : #'examples - memento' }
AlbTextEditorMementoExamples >> editorRestoreState [
	<gtExample>
	| aMemento aTextEditor |
	
	aMemento := self editorSaveState.
	aTextEditor := self newTextEditor.
	
	aTextEditor restoreState: aMemento.
	
	^ aTextEditor
]

{ #category : #'examples - memento' }
AlbTextEditorMementoExamples >> editorSaveState [
	<gtExample>
	| aTextEditor aMemento |
	
	aTextEditor := self textEditorWithState.
	aMemento := aTextEditor saveState.
	
	^ aMemento
]

{ #category : #'instance creation' }
AlbTextEditorMementoExamples >> newTextEditor [
	<gtExample>
	| aTextEditor |

	aTextEditor := AlbTextEditor new.
	^ aTextEditor
]

{ #category : #'instance creation' }
AlbTextEditorMementoExamples >> textEditorWithState [
	<gtExample>
	| aTextEditor |

	aTextEditor := AlbTextEditor new
		text: 'Hello world' asRopedText glamorousCodeFontAndSize.
	
	aTextEditor navigator
		addAt: 1;
		addAt: 9;
		apply.	

	aTextEditor selecter
		from: 3 to: 8;
		withoutCursorUpdate;
		select.
	
	^ aTextEditor
]
