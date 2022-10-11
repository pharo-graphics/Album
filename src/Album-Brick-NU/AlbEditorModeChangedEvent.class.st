Class {
	#name : #AlbEditorModeChangedEvent,
	#superclass : #AlbEditorChangedEvent,
	#instVars : [
		'mode'
	],
	#category : #'Album-Brick-NU-Album-Model-Events'
}

{ #category : #accessing }
AlbEditorModeChangedEvent >> mode [
	^ mode
]

{ #category : #accessing }
AlbEditorModeChangedEvent >> mode: anObject [
	mode := anObject
]

{ #category : #sending }
AlbEditorModeChangedEvent >> sendTo: anEventHandler [

	anEventHandler modeChangedEvent: self
]
