"
I deselect an interval of text from ===fromIndex=== to ===toIndex===
"
Class {
	#name : #AlbTextEditorDeselectCommand,
	#superclass : #AlbTextEditorCommand,
	#instVars : [
		'fromIndex',
		'toIndex'
	],
	#category : #'Album-Commands'
}

{ #category : #executing }
AlbTextEditorDeselectCommand >> executeOn: aTextEditor [

	aTextEditor selection isEmpty
		ifTrue: [ ^ self ].

	aTextEditor selection deselect: self fromIndex to: self toIndex.
	aTextEditor updateSelection: self fromIndex to: self toIndex.
	aTextEditor notifySelectionChanged: aTextEditor selection
]

{ #category : #accessing }
AlbTextEditorDeselectCommand >> fromIndex [
	^ fromIndex
]

{ #category : #accessing }
AlbTextEditorDeselectCommand >> fromIndex: anObject [
	fromIndex := anObject
]

{ #category : #accessing }
AlbTextEditorDeselectCommand >> toIndex [
	^ toIndex
]

{ #category : #accessing }
AlbTextEditorDeselectCommand >> toIndex: anObject [
	toIndex := anObject
]
