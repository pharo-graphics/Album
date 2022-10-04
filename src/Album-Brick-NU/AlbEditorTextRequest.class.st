Class {
	#name : #AlbEditorTextRequest,
	#superclass : #AlbEditorRequest,
	#category : #'Album-Brick-NU-Events'
}

{ #category : #initialization }
AlbEditorTextRequest >> responseClass [
	^ AlbEditorTextChangedEvent
]
