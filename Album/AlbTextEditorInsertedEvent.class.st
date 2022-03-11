Class {
	#name : #AlbTextEditorInsertedEvent,
	#superclass : #AlbTextEditorEvent,
	#instVars : [
		'text',
		'index'
	],
	#category : #'Album-Model-Events'
}

{ #category : #'instance creation' }
AlbTextEditorInsertedEvent class >> text: aBlText at: anIndex [
	<return: #AlbTextEditorInsertedEvent>

	^ self new
		text: aBlText;
		index: anIndex
]

{ #category : #accessing }
AlbTextEditorInsertedEvent >> index [
	^ index
]

{ #category : #accessing }
AlbTextEditorInsertedEvent >> index: aNumber [
	index := aNumber
]

{ #category : #accessing }
AlbTextEditorInsertedEvent >> text [
	^ text
]

{ #category : #accessing }
AlbTextEditorInsertedEvent >> text: aBrText [
	text := aBrText
]
