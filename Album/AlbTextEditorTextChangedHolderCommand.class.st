Class {
	#name : #AlbTextEditorTextChangedHolderCommand,
	#superclass : #AlbTextEditorHolderCommand,
	#category : #'Album-Commands-Holder'
}

{ #category : #executing }
AlbTextEditorTextChangedHolderCommand >> executeOn: aSegmentHolder [
	aSegmentHolder onTextChanged
]
