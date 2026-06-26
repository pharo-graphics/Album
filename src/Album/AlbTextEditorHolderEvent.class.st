"
I am a payload to trigger partial text update without re-creation of text pieces
"
Class {
	#name : #AlbTextEditorHolderEvent,
	#superclass : #BlEvent,
	#instVars : [
		'context'
	],
	#category : #'Album-Commands-Holder'
}

{ #category : #accessing }
AlbTextEditorHolderEvent >> context [
	^ context
]

{ #category : #accessing }
AlbTextEditorHolderEvent >> context: anObject [
	context := anObject
]

{ #category : #sending }
AlbTextEditorHolderEvent >> sendTo: aSegmentHolder [
	self executeOn: aSegmentHolder
]
