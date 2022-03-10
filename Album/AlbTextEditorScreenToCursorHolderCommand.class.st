Class {
	#name : #AlbTextEditorScreenToCursorHolderCommand,
	#superclass : #AlbTextEditorHolderCommand,
	#instVars : [
		'transformation'
	],
	#category : #'Album-Editor-Commands-Holder'
}

{ #category : #executing }
AlbTextEditorScreenToCursorHolderCommand >> executeOn: aSegmentHolder [
	aSegmentHolder screenToCursor: self transformation
]

{ #category : #accessing }
AlbTextEditorScreenToCursorHolderCommand >> transformation [
	^ transformation
]

{ #category : #accessing }
AlbTextEditorScreenToCursorHolderCommand >> transformation: anObject [
	transformation := anObject
]
