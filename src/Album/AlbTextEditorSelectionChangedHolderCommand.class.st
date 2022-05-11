"
I trigger a selection update in the text piece
"
Class {
	#name : #AlbTextEditorSelectionChangedHolderCommand,
	#superclass : #AlbTextEditorHolderCommand,
	#category : #'Album-Commands-Holder'
}

{ #category : #executing }
AlbTextEditorSelectionChangedHolderCommand >> executeOn: aSegmentHolder [
	aSegmentHolder onSelectionChanged
]