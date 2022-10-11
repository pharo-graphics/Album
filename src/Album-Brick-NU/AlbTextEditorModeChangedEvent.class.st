Class {
	#name : #AlbTextEditorModeChangedEvent,
	#superclass : #AlbTextEditorEvent,
	#instVars : [
		'mode'
	],
	#category : #'Album-Brick-NU-Album-Model-Events'
}

{ #category : #accessing }
AlbTextEditorModeChangedEvent >> mode [

	^ mode
]

{ #category : #accessing }
AlbTextEditorModeChangedEvent >> mode: aTextEditorMode [

	mode := aTextEditorMode
]
