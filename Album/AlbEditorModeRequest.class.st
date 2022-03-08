Class {
	#name : #AlbEditorModeRequest,
	#superclass : #AlbEditorRequest,
	#category : #'Album-Editor - Events'
}

{ #category : #initialization }
AlbEditorModeRequest >> responseClass [
	^ AlbEditorModeChanged
]
