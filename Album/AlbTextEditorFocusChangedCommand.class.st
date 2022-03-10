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
	
	aTextEditor
		enqueueHolderCommand: self newHolderCommand
		interval: aTextEditor segmentCollector cachedInterval
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
AlbTextEditorFocusChangedCommand >> newHolderCommand [
	^ AlbTextEditorFocusChangedHolderCommand new
		hasFocus: self hasFocus
]
