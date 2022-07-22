Class {
	#name : #AlbTextEditorScreenToCursorHolderEvent,
	#superclass : #AlbTextEditorHolderEvent,
	#instVars : [
		'transformation'
	],
	#category : #'Album-Commands-Holder'
}

{ #category : #accessing }
AlbTextEditorScreenToCursorHolderEvent >> transformation [
	^ transformation
]

{ #category : #accessing }
AlbTextEditorScreenToCursorHolderEvent >> transformation: anObject [
	transformation := anObject
]
