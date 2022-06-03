Class {
	#name : #AlbEditorStylerRequest,
	#superclass : #AlbEditorRequest,
	#category : #'Album-Brick-NU'
}

{ #category : #initialization }
AlbEditorStylerRequest >> responseClass [
	^ AlbEditorStylerChanged
]
