Class {
	#name : #AlbTextEditorHistoryInsertionCommand,
	#superclass : #AlbTextEditorHistoryCommand,
	#instVars : [
		'strings',
		'undoIndices',
		'redoIndices'
	],
	#category : #'Album-History'
}

{ #category : #printing }
AlbTextEditorHistoryInsertionCommand >> printOn: aStream [
	
	aStream nextPutAll: 'Insert'.
	strings
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
AlbTextEditorHistoryInsertionCommand >> redoIndices [
	^ redoIndices
]

{ #category : #accessing }
AlbTextEditorHistoryInsertionCommand >> redoIndices: anObject [
	redoIndices := anObject
]

{ #category : #'api - undo/redo' }
AlbTextEditorHistoryInsertionCommand >> redoOn: aBrTextEditor [
	| anInserter |
	aBrTextEditor deselecter all deselect.
	
	anInserter := aBrTextEditor inserter.
	strings
		with: redoIndices
		do: [ :eachString :eachIndex | anInserter text: eachString; at: eachIndex ].
	anInserter insert
]

{ #category : #accessing }
AlbTextEditorHistoryInsertionCommand >> strings [
	^ strings
]

{ #category : #accessing }
AlbTextEditorHistoryInsertionCommand >> strings: anObject [
	strings := anObject
]

{ #category : #accessing }
AlbTextEditorHistoryInsertionCommand >> undoIndices [
	^ undoIndices
]

{ #category : #accessing }
AlbTextEditorHistoryInsertionCommand >> undoIndices: anObject [
	undoIndices := anObject
]

{ #category : #'api - undo/redo' }
AlbTextEditorHistoryInsertionCommand >> undoOn: aBrTextEditor [
	| aDeleter |
	aBrTextEditor deselecter all deselect.
	aDeleter := aBrTextEditor deleter.
	strings with: undoIndices do: [ :eachString :eachIndex | 
		aDeleter from: eachIndex to: eachIndex + eachString size ].
	aDeleter delete
]
