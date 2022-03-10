Class {
	#name : #AlbTextEditorTextChangedHolderCommand,
	#superclass : #AlbTextEditorHolderCommand,
	#category : #'Album-Editor-Commands-Holder'
}

{ #category : #executing }
AlbTextEditorTextChangedHolderCommand >> executeOn: aSegmentHolder [
	aSegmentHolder onTextChanged
]
