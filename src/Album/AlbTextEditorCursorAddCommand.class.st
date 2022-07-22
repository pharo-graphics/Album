Class {
	#name : #AlbTextEditorCursorAddCommand,
	#superclass : #AlbTextEditorCommand,
	#instVars : [
		'cursor'
	],
	#category : #'Album-Commands'
}

{ #category : #accessing }
AlbTextEditorCursorAddCommand >> cursor [
	<return: #AlbTextEditorSingleCursor>

	^ cursor
]

{ #category : #accessing }
AlbTextEditorCursorAddCommand >> cursor: anObject [
	cursor := anObject
]

{ #category : #executing }
AlbTextEditorCursorAddCommand >> executeOn: aTextEditor [

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
AlbTextEditorCursorAddCommand >> newHolderEvent [
	^ AlbTextEditorCursorAddedHolderEvent new context: self context
]
