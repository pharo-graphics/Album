Class {
	#name : #AlbEditorModeRequest,
	#superclass : #AlbEditorRequest,
	#category : #'Album-Brick-NU'
}

{ #category : #initialization }
AlbEditorModeRequest >> responseClass [
	^ AlbEditorModeChanged
]
