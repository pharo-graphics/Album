"
I select an interval of text from ===fromIndex=== to ===toIndex===.
I do not remove existing selections, I just add new one on top merging overlapping intervals
"
Class {
	#name : #AlbTextEditorSelectCommand,
	#superclass : #AlbTextEditorCommand,
	#instVars : [
		'fromIndex',
		'toIndex'
	],
	#category : #'Album-Commands'
}

{ #category : #executing }
AlbTextEditorSelectCommand >> executeOn: aTextEditor [

	self fromIndex = self toIndex
		ifTrue: [ ^ self ].

	aTextEditor selection select: self fromIndex to: self toIndex.
	aTextEditor updateSelection: self fromIndex to: self toIndex.
	aTextEditor notifySelectionChanged: aTextEditor selection
]

{ #category : #accessing }
AlbTextEditorSelectCommand >> fromIndex [
	^ fromIndex
]

{ #category : #accessing }
AlbTextEditorSelectCommand >> fromIndex: anObject [
	fromIndex := anObject
]

{ #category : #accessing }
AlbTextEditorSelectCommand >> toIndex [
	^ toIndex
]

{ #category : #accessing }
AlbTextEditorSelectCommand >> toIndex: anObject [
	toIndex := anObject
]
