Class {
	#name : #AlbTextEditorHistoryCursorMovementCommand,
	#superclass : #AlbTextEditorHistoryCommand,
	#instVars : [
		'fromIndices',
		'toIndices'
	],
	#category : #'Album-Editor-History'
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
AlbTextEditorHistoryCursorMovementCommand >> redoOn: aBrTextEditor [
	| aNavigator |
	
	aNavigator := aBrTextEditor navigator.
	fromIndices do: [ :eachIndex | aNavigator removeAt: eachIndex ].
	toIndices do: [ :eachIndex | aNavigator addAt: eachIndex ].
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
AlbTextEditorHistoryCursorMovementCommand >> undoOn: aBrTextEditor [
	| aNavigator |
	
	aNavigator := aBrTextEditor navigator.
	toIndices do: [ :eachIndex | aNavigator removeAt: eachIndex ].
	fromIndices do: [ :eachIndex | aNavigator addAt: eachIndex ].
	aNavigator apply
]
