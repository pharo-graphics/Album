Class {
	#name : #AlbTextEditorHistoryCursorMovementCommand,
	#superclass : #AlbTextEditorHistoryCommand,
	#instVars : [
		'fromIndices',
		'toIndices'
	],
	#category : #'Album-History'
}

{ #category : #accessing }
AlbTextEditorHistoryCursorMovementCommand >> fromIndices [
	^ fromIndices
]

{ #category : #accessing }
AlbTextEditorHistoryCursorMovementCommand >> fromIndices: anObject [
	fromIndices := anObject
]

{ #category : #'api - undo/redo' }
AlbTextEditorHistoryCursorMovementCommand >> redoOn: aTextEditor [

	self restoreCursorsAt: toIndices on: aTextEditor
]

{ #category : #private }
AlbTextEditorHistoryCursorMovementCommand >> restoreCursorsAt: aCollectionOfIndices on: aTextEditor [

	| aNavigator |
	aCollectionOfIndices ifEmpty: [ ^ self ].
	aNavigator := aTextEditor navigator.
	aNavigator moveTo: aCollectionOfIndices first.
	aCollectionOfIndices allButFirst do: [ :eachIndex | aNavigator addCursorAt: eachIndex ].
	aNavigator apply
]

{ #category : #accessing }
AlbTextEditorHistoryCursorMovementCommand >> toIndices [
	^ toIndices
]

{ #category : #accessing }
AlbTextEditorHistoryCursorMovementCommand >> toIndices: anObject [
	toIndices := anObject
]

{ #category : #'api - undo/redo' }
AlbTextEditorHistoryCursorMovementCommand >> undoOn: aTextEditor [

	self restoreCursorsAt: fromIndices on: aTextEditor
]
