Class {
	#name : #AlbEditorStylerRequest,
	#superclass : #AlbEditorRequest,
	#category : #'Album-Events'
}

{ #category : #initialization }
AlbEditorStylerRequest >> responseClass [
	^ AlbEditorStylerChanged
]
