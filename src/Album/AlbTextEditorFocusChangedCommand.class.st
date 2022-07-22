Class {
	#name : #AlbTextEditorFocusChangedCommand,
	#superclass : #AlbTextEditorCommand,
	#instVars : [
		'hasFocus'
	],
	#category : #'Album-Commands'
}

{ #category : #executing }
AlbTextEditorFocusChangedCommand >> executeOn: aTextEditor [
	
	aTextEditor notifyItems: aTextEditor segmentCollector cachedInterval event: self newHolderEvent.

]

{ #category : #accessing }
AlbTextEditorFocusChangedCommand >> hasFocus [
	^ hasFocus
]

{ #category : #accessing }
AlbTextEditorFocusChangedCommand >> hasFocus: anObject [
	hasFocus := anObject
]

{ #category : #'instance creation' }
AlbTextEditorFocusChangedCommand >> newHolderEvent [
	^ AlbTextEditorFocusChangedHolderEvent new
		hasFocus: self hasFocus
]
