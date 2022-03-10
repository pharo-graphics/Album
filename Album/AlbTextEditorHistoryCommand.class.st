Class {
	#name : #AlbTextEditorHistoryCommand,
	#superclass : #Object,
	#category : #'Album-Editor-History'
}

{ #category : #testing }
AlbTextEditorHistoryCommand >> isGroup [
	^ false
]

{ #category : #'api - undo/redo' }
AlbTextEditorHistoryCommand >> redoOn: aBrTextEditor [
	self subclassResponsibility
]

{ #category : #'api - undo/redo' }
AlbTextEditorHistoryCommand >> undoOn: aBrTextEditor [
	self subclassResponsibility
]
