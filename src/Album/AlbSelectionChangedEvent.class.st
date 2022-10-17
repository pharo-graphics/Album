Class {
	#name : #AlbSelectionChangedEvent,
	#superclass : #BlEvent,
	#instVars : [
		'selection'
	],
	#category : #'Album-Model-Events'
}

{ #category : #accessing }
AlbSelectionChangedEvent >> selection [
	^ selection
]

{ #category : #accessing }
AlbSelectionChangedEvent >> selection: anObject [
	selection := anObject
]
