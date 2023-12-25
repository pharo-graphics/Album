Class {
	#name : #AlbTextEditorHistoryCursorMovementCommand,
	#superclass : #AlbTextEditorHistoryCommand,
	#instVars : [
		'fromIndices',
		'toIndices'
	],
	#category : 'Album-History'
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
	| aNavigator |
	
	aNavigator := aTextEditor navigator.
	fromIndices do: [ :eachIndex | aNavigator removeAt: eachIndex ].
	toIndices do: [ :eachIndex | aNavigator moveTo: eachIndex ].
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
	| aNavigator |
	
	aNavigator := aTextEditor navigator.
	toIndices do: [ :eachIndex | aNavigator removeAt: eachIndex ].
	fromIndices do: [ :eachIndex | aNavigator moveTo: eachIndex ].
	aNavigator apply
]
