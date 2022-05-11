"
I trigger a focus state update in the text piece
"
Class {
	#name : #AlbTextEditorFocusChangedHolderCommand,
	#superclass : #AlbTextEditorHolderCommand,
	#instVars : [
		'hasFocus'
	],
	#category : #'Album-Commands-Holder'
}

{ #category : #executing }
AlbTextEditorFocusChangedHolderCommand >> executeOn: aSegmentHolder [
	aSegmentHolder onFocusChanged: self hasFocus
]

{ #category : #accessing }
AlbTextEditorFocusChangedHolderCommand >> hasFocus [
	^ hasFocus
]

{ #category : #accessing }
AlbTextEditorFocusChangedHolderCommand >> hasFocus: aBoolean [
	hasFocus := aBoolean
]
