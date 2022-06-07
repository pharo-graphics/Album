Class {
	#name : #AlbEditorStylerRequest,
	#superclass : #AlbEditorRequest,
	#category : #'Album-Brick-NU-Events'
}

{ #category : #initialization }
AlbEditorStylerRequest >> responseClass [
	^ AlbEditorStylerChanged
]
