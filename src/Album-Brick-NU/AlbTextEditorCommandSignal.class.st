Class {
	#name : #AlbTextEditorCommandSignal,
	#superclass : #AlbTextEditorSignal,
	#instVars : [
		'command'
	],
	#category : #'Album-Brick-NU-signals'
}

{ #category : #accessing }
AlbTextEditorCommandSignal >> command [
	<return: #AlbTextEditorCommand>

	^ command
]

{ #category : #accessing }
AlbTextEditorCommandSignal >> command: aTextEditorCommand [
	command := aTextEditorCommand
]

{ #category : #printing }
AlbTextEditorCommandSignal >> printOneLineContentsOn: aStream [
	"hook to be overriden by subclasses"
	
	aStream print: self command
]
