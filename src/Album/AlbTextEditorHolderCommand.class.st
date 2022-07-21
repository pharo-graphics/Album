"
I am a payload to trigger partial text update without re-creation of text pieces
"
Class {
	#name : #AlbTextEditorHolderCommand,
	#superclass : #BlEvent,
	#instVars : [
		'context'
	],
	#category : #'Album-Commands-Holder'
}

{ #category : #accessing }
AlbTextEditorHolderCommand >> context [
	^ context
]

{ #category : #accessing }
AlbTextEditorHolderCommand >> context: anObject [
	context := anObject
]

{ #category : #executing }
AlbTextEditorHolderCommand >> executeOn: aSegmentHolder [
	self subclassResponsibility
]

{ #category : #sending }
AlbTextEditorHolderCommand >> sendTo: aSegmentHolder [
	self executeOn: aSegmentHolder
]
