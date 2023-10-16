Class {
	#name : 'AlbTextEditorTextMemento',
	#superclass : 'AlbTextEditorMemento',
	#instVars : [
		'text'
	],
	#category : 'Album-Model-Memento',
	#package : 'Album',
	#tag : 'Model-Memento'
}

{ #category : 'initialization' }
AlbTextEditorTextMemento >> initialize [
	super initialize.
	
	text := '' asRopedText
]

{ #category : 'testing' }
AlbTextEditorTextMemento >> isTextMemento [
	^ true
]

{ #category : 'evaluating' }
AlbTextEditorTextMemento >> label [
	^ 'Text'
]

{ #category : 'accessing' }
AlbTextEditorTextMemento >> order [
	^ 60
]

{ #category : 'memento' }
AlbTextEditorTextMemento >> restoreStateOf: aTextEditor [
	aTextEditor restoreText: text copy
]

{ #category : 'memento' }
AlbTextEditorTextMemento >> saveStateOf: aTextEditor [
	text := aTextEditor text copy
]

{ #category : 'accessing' }
AlbTextEditorTextMemento >> text [
	^ text
]

{ #category : 'accessing' }
AlbTextEditorTextMemento >> text: anObject [
	text := anObject
]

{ #category : 'evaluating' }
AlbTextEditorTextMemento >> value [
	^ text copyWithoutExternalReferences
]
