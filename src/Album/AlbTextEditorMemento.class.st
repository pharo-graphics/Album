Class {
	#name : 'AlbTextEditorMemento',
	#superclass : 'Object',
	#category : 'Album-Model-Memento',
	#package : 'Album',
	#tag : 'Model-Memento'
}

{ #category : 'testing' }
AlbTextEditorMemento >> isSelectionMemento [
	^ false
]

{ #category : 'testing' }
AlbTextEditorMemento >> isTextMemento [
	^ false
]

{ #category : 'evaluating' }
AlbTextEditorMemento >> label [
	^ self subclassResponsibility
]

{ #category : 'accessing' }
AlbTextEditorMemento >> order [
	^ self subclassResponsibility
]

{ #category : 'memento' }
AlbTextEditorMemento >> restoreStateOf: aTextEditor [
	self subclassResponsibility
]

{ #category : 'memento' }
AlbTextEditorMemento >> saveStateOf: aTextEditor [
	self subclassResponsibility
]

{ #category : 'evaluating' }
AlbTextEditorMemento >> value [
	^ self subclassResponsibility
]
