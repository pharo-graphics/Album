Class {
	#name : #AlbEditorModeRequest,
	#superclass : #AlbEditorRequest,
	#category : #'Album-Events'
}

{ #category : #initialization }
AlbEditorModeRequest >> responseClass [
	^ AlbEditorModeChanged
]
