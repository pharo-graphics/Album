"
I trigger a cursor update in the text piece
"
Class {
	#name : #AlbTextEditorCursorChangedHolderEvent,
	#superclass : #AlbTextEditorHolderEvent,
	#category : #'Album-Brick-NU-Commands-Holder'
}

{ #category : #testing }
AlbTextEditorCursorChangedHolderEvent class >> isDeprecated [ 
	^ true
]

{ #category : #sending }
AlbTextEditorCursorChangedHolderEvent >> sendTo: aSegmentHolder [
	aSegmentHolder onCursorChanged
]
