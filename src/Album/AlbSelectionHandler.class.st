Class {
	#name : #AlbSelectionHandler,
	#superclass : #BlCustomEventHandler,
	#instVars : [
		'editorElement',
		'selectionElement'
	],
	#category : #'Album-UI-Handlers'
}

{ #category : #accessing }
AlbSelectionHandler >> editorElement [

	^ editorElement
]

{ #category : #accessing }
AlbSelectionHandler >> editorElement: anEditorElement [

	editorElement := anEditorElement
]

{ #category : #accessing }
AlbSelectionHandler >> selectionElement [

	^ selectionElement
]

{ #category : #accessing }
AlbSelectionHandler >> selectionElement: aSelectionElement [

	selectionElement := aSelectionElement
]
