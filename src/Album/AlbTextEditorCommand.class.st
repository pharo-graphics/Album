Class {
	#name : #AlbTextEditorCommand,
	#superclass : #Object,
	#traits : 'TBlDebug',
	#classTraits : 'TBlDebug classTrait',
	#instVars : [
		'context'
	],
	#category : 'Album-Commands'
}

{ #category : #accessing }
AlbTextEditorCommand >> context [
	^ context
]

{ #category : #accessing }
AlbTextEditorCommand >> context: anObject [
	context := anObject
]

{ #category : #executing }
AlbTextEditorCommand >> executeOn: aTextEditor [
	self subclassResponsibility
]

{ #category : #'instance creation' }
AlbTextEditorCommand >> newHolderCommand [ 
	self deprecated: 'use #newHolderEvent since I return an event'.

]
