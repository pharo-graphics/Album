Class {
	#name : #AlbTextEditorHolderCommandSignal,
	#superclass : #AlbTextEditorSignal,
	#instVars : [
		'command',
		'interval'
	],
	#category : #'Album-Brick-NU-signals'
}

{ #category : #accessing }
AlbTextEditorHolderCommandSignal >> command [
	^ command
]

{ #category : #accessing }
AlbTextEditorHolderCommandSignal >> command: anObject [
	command := anObject
]

{ #category : #accessing }
AlbTextEditorHolderCommandSignal >> interval [
	^ interval
]

{ #category : #accessing }
AlbTextEditorHolderCommandSignal >> interval: anObject [
	interval := anObject
]

{ #category : #printing }
AlbTextEditorHolderCommandSignal >> printOneLineContentsOn: aStream [
	"hook to be overriden by subclasses"
	
	aStream
		print: self command;
		nextPutAll: ' within ';
		print: self interval
]
