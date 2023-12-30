Class {
	#name : #AlbInfiniteEditorModeChangedEvent,
	#superclass : #BlEvent,
	#category : #'Album-UI'
}

{ #category : #sending }
AlbInfiniteEditorModeChangedEvent >> sendTo: anObject [

	anObject infiniteEditorModeChangedEvent: self
]
