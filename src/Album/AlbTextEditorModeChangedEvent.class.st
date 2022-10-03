Class {
	#name : #AlbTextEditorModeChangedEvent,
	#superclass : #AlbTextEditorEvent,
	#instVars : [
		'mode'
	],
	#category : #'Album-Model-Events'
}

{ #category : #accessing }
AlbTextEditorModeChangedEvent >> mode [

	^ mode
]

{ #category : #accessing }
AlbTextEditorModeChangedEvent >> mode: aTextEditorMode [

	mode := aTextEditorMode
]
