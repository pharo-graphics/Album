Class {
	#name : #AlbEditorTextRequest,
	#superclass : #AlbEditorRequest,
	#category : #'Album-Brick-NU'
}

{ #category : #initialization }
AlbEditorTextRequest >> responseClass [
	^ AlbEditorTextChanged
]
