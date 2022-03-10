"
I trigger a cursor update in the text piece
"
Class {
	#name : #AlbTextEditorCursorChangedHolderCommand,
	#superclass : #AlbTextEditorHolderCommand,
	#category : #'Album-Commands-Holder'
}

{ #category : #executing }
AlbTextEditorCursorChangedHolderCommand >> executeOn: aSegmentHolder [
	self telemetry
		timeSync: [ 'Segment holder onCursorChanged' ]
		during: [ aSegmentHolder onCursorChanged ]
]
