Class {
	#name : #AlbEditorModeRequest,
	#superclass : #AlbEditorRequest,
	#category : #'Album-Brick-NU-Events'
}

{ #category : #initialization }
AlbEditorModeRequest >> responseClass [
	^ AlbEditorModeChanged
]
