Class {
	#name : #AlbTextEditorTextChangedHolderEvent,
	#superclass : #AlbTextEditorHolderEvent,
	#category : #'Album-Commands-Holder'
}

{ #category : #sending }
AlbTextEditorTextChangedHolderEvent >> sendTo: aSegmentHolder [
	aSegmentHolder onTextChanged
]
