Class {
	#name : #AlbTextEditorStyledTextMemento,
	#superclass : #AlbTextEditorMemento,
	#instVars : [
		'text',
		'styler'
	],
	#category : #'Album-Brick-NU-Album-Model-Memento'
}

{ #category : #initialization }
AlbTextEditorStyledTextMemento >> initialize [
	super initialize.
	
	text := '' asRopedText
]

{ #category : #testing }
AlbTextEditorStyledTextMemento >> isTextMemento [
	^ true
]

{ #category : #evaluating }
AlbTextEditorStyledTextMemento >> label [
	^ 'Styled Text'
]

{ #category : #accessing }
AlbTextEditorStyledTextMemento >> order [
	^ 60
]

{ #category : #memento }
AlbTextEditorStyledTextMemento >> restoreStateOf: aTextEditor [
	aTextEditor
		disableStylerDuring: [
			aTextEditor styler: self styler.
			aTextEditor restoreText: text copy ]
]

{ #category : #memento }
AlbTextEditorStyledTextMemento >> saveStateOf: aTextEditor [
	text := aTextEditor text copy.
	styler := aTextEditor styler
]

{ #category : #accessing }
AlbTextEditorStyledTextMemento >> styler [
	^ styler
]

{ #category : #accessing }
AlbTextEditorStyledTextMemento >> styler: anObject [
	styler := anObject
]

{ #category : #accessing }
AlbTextEditorStyledTextMemento >> text [
	^ text
]

{ #category : #accessing }
AlbTextEditorStyledTextMemento >> text: anObject [
	text := anObject
]

{ #category : #evaluating }
AlbTextEditorStyledTextMemento >> value [
	^ text copyWithoutExternalReferences
]
