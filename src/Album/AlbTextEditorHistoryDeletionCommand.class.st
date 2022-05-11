Class {
	#name : #AlbTextEditorHistoryDeletionCommand,
	#superclass : #AlbTextEditorHistoryCommand,
	#instVars : [
		'texts',
		'undoIndices',
		'redoIndices'
	],
	#category : #'Album-History'
}

{ #category : #printing }
AlbTextEditorHistoryDeletionCommand >> printOn: aStream [
	aStream nextPutAll: 'Delete'.
	texts
		with: undoIndices
		do: [ :eachString :eachIndex |
			aStream
				space;
				print: eachString; space;
				nextPutAll: 'at'; space;
				print: eachIndex;
				nextPut: $, ].
]

{ #category : #accessing }
AlbTextEditorHistoryDeletionCommand >> redoIndices [
	^ redoIndices
]

{ #category : #accessing }
AlbTextEditorHistoryDeletionCommand >> redoIndices: anObject [
	redoIndices := anObject
]

{ #category : #'api - undo/redo' }
AlbTextEditorHistoryDeletionCommand >> redoOn: aTextEditor [
	| aDeleter |
	aTextEditor deselecter all deselect.
	
	aDeleter := aTextEditor deleter.
	texts
		with: redoIndices
		do: [ :eachText :eachIndex | aDeleter from: eachIndex to: eachIndex + eachText size ].
	
	aDeleter delete
]

{ #category : #accessing }
AlbTextEditorHistoryDeletionCommand >> texts [
	^ texts
]

{ #category : #accessing }
AlbTextEditorHistoryDeletionCommand >> texts: anObject [
	texts := anObject
]

{ #category : #accessing }
AlbTextEditorHistoryDeletionCommand >> undoIndices [
	^ undoIndices
]

{ #category : #accessing }
AlbTextEditorHistoryDeletionCommand >> undoIndices: anObject [
	undoIndices := anObject
]

{ #category : #'api - undo/redo' }
AlbTextEditorHistoryDeletionCommand >> undoOn: aTextEditor [
	| anInserter |
	aTextEditor deselecter all deselect.
	
	anInserter := aTextEditor inserter.
	texts
		with: undoIndices
		do: [ :eachText :eachIndex | anInserter text: eachText characters asString; at: eachIndex - 1 ].
	anInserter insert
]