Class {
	#name : #AlbEditorTextRequest,
	#superclass : #AlbEditorRequest,
	#category : #'Album-Events'
}

{ #category : #initialization }
AlbEditorTextRequest >> responseClass [
	^ AlbEditorTextChanged
]
