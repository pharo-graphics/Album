Class {
	#name : #AlbTextEditorMultipleCursor,
	#superclass : #AlbTextEditorCursor,
	#instVars : [
		'cursors'
	],
	#category : #'Album-Model-Cursor'
}

{ #category : #comparing }
AlbTextEditorMultipleCursor >> = anotherObject [
	self == anotherObject
		ifTrue: [ ^ true ].
	(anotherObject isKindOf: self class)
		ifFalse: [ ^ false ].

	^ anotherObject cursors = self cursors
]

{ #category : #adding }
AlbTextEditorMultipleCursor >> add: aSingleCursor [
	self cursors add: aSingleCursor
]

{ #category : #adding }
AlbTextEditorMultipleCursor >> addAll: aCollectionOfSingleCursor [
	self cursors addAll: aCollectionOfSingleCursor
]

{ #category : #accessing }
AlbTextEditorMultipleCursor >> cursors [
	<return: #Collection of: #AlbTextEditorCursor>

	^ cursors
]

{ #category : #enumerating }
AlbTextEditorMultipleCursor >> do: aBlock [
	"Evaluate a given block with all available cursors"

	^ self cursors do: aBlock
]

{ #category : #comparing }
AlbTextEditorMultipleCursor >> hash [
	^ self class hash bitXor: self cursors hash
]

{ #category : #initialization }
AlbTextEditorMultipleCursor >> initialize [
	super initialize.

	cursors := OrderedCollection new
]

{ #category : #copying }
AlbTextEditorMultipleCursor >> postCopy [
	cursors := cursors collect: [ :cursor | cursor copy ]
]

{ #category : #printing }
AlbTextEditorMultipleCursor >> printOn: aStream [

	self isEmpty
		ifTrue: [ aStream nextPutAll: 'Empty' ]
		ifFalse: [ aStream nextPutAll: ($, join: self cursors) ]
]

{ #category : #adding }
AlbTextEditorMultipleCursor >> remove: aSingleCursor [
	self cursors remove: aSingleCursor
]
