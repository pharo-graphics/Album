Class {
	#name : #AlbEditorStylerRequest,
	#superclass : #AlbEditorRequest,
	#category : #'Album-Editor - Events'
}

{ #category : #initialization }
AlbEditorStylerRequest >> responseClass [
	^ AlbEditorStylerChanged
]
