Class {
	#name : #AlbEditorModeChanged,
	#superclass : #AlbEditorChangedEvent,
	#instVars : [
		'mode'
	],
	#category : #'Album-Editor-Events'
}

{ #category : #initialization }
AlbEditorModeChanged >> initialize [
	super initialize.
	
	mode := AlbTextEditorNullMode new
]

{ #category : #accessing }
AlbEditorModeChanged >> mode [
	^ mode
]

{ #category : #accessing }
AlbEditorModeChanged >> mode: anObject [
	mode := anObject
]
