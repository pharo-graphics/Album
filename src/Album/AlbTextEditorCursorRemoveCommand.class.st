Class {
	#name : #AlbTextEditorCursorRemoveCommand,
	#superclass : #AlbTextEditorCommand,
	#instVars : [
		'cursor'
	],
	#category : #'Album-Commands'
}

{ #category : #accessing }
AlbTextEditorCursorRemoveCommand >> cursor [
	<return: #AlbTextEditorSingleCursor>

	^ cursor
]

{ #category : #accessing }
AlbTextEditorCursorRemoveCommand >> cursor: anObject [
	cursor := anObject
]

{ #category : #executing }
AlbTextEditorCursorRemoveCommand >> executeOn: aTextEditor [

	"Attribute handling: some attribute are eventHandlers."

	self flag: 'We have to think about attributes later become this code is too crappy'.
	"self processAttributesOn: aTextEditor."

	"Now move the cursor within the cached text segments"
	aTextEditor segmentCollector
		cachedSegmentAt: cursor position
		ifFound: [ :aSegment | 
			aTextEditor notifyItems: (aSegment index to: aSegment index) event: self newHolderEvent ]
		ifNotFound: [  ]
]

{ #category : #'instance creation' }
AlbTextEditorCursorRemoveCommand >> newHolderEvent [
	^ AlbTextEditorCursorRemovedHolderEvent new context: self context
]
