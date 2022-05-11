Class {
	#name : #AlbTextEditorHistoryCommand,
	#superclass : #Object,
	#category : #'Album-History'
}

{ #category : #testing }
AlbTextEditorHistoryCommand >> isGroup [
	^ false
]

{ #category : #'api - undo/redo' }
AlbTextEditorHistoryCommand >> redoOn: aTextEditor [
	self subclassResponsibility
]

{ #category : #'api - undo/redo' }
AlbTextEditorHistoryCommand >> undoOn: aTextEditor [
	self subclassResponsibility
]
