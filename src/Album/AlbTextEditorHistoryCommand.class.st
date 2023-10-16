Class {
	#name : 'AlbTextEditorHistoryCommand',
	#superclass : 'Object',
	#category : 'Album-History',
	#package : 'Album',
	#tag : 'History'
}

{ #category : 'testing' }
AlbTextEditorHistoryCommand >> isGroup [
	^ false
]

{ #category : 'api - undo/redo' }
AlbTextEditorHistoryCommand >> redoOn: aTextEditor [
	self subclassResponsibility
]

{ #category : 'api - undo/redo' }
AlbTextEditorHistoryCommand >> undoOn: aTextEditor [
	self subclassResponsibility
]
