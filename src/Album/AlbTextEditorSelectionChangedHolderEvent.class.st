"
I trigger a selection update in the text piece
"
Class {
	#name : #AlbTextEditorSelectionChangedHolderEvent,
	#superclass : #AlbTextEditorHolderEvent,
	#category : #'Album-Commands-Holder'
}

{ #category : #sending }
AlbTextEditorSelectionChangedHolderEvent >> sendTo: aSegmentHolder [
	aSegmentHolder onSelectionChanged
]
