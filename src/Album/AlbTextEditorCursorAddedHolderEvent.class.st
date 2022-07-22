Class {
	#name : #AlbTextEditorCursorAddedHolderEvent,
	#superclass : #AlbTextEditorHolderEvent,
	#category : #'Album-Commands-Holder'
}

{ #category : #sending }
AlbTextEditorCursorAddedHolderEvent >> sendTo: aSegmentHolder [
	aSegmentHolder onCursorAdded
]
