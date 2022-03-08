Class {
	#name : #AlbEditorTextRequest,
	#superclass : #AlbEditorRequest,
	#category : #'Album-Editor - Events'
}

{ #category : #initialization }
AlbEditorTextRequest >> responseClass [
	^ AlbEditorTextChanged
]
