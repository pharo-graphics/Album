"
I do the hard job of visually updating selection by requesting segment holders to partially update themselves
"
Class {
	#name : #AlbTextEditorSelectionUpdateCommand,
	#superclass : #AlbTextEditorCommand,
	#instVars : [
		'fromIndex',
		'toIndex'
	],
	#category : #'Album-Commands'
}

{ #category : #executing }
AlbTextEditorSelectionUpdateCommand >> executeOn: aTextEditor [
	| changedFrom changedTo |
	
	changedFrom := self fromIndex.

	changedTo := self toIndex.

	aTextEditor segmentCollector
		cachedSegmentAt: changedFrom
		ifFound: [ :aSegment | changedFrom := aSegment index ]
		ifNotFound: [ 1 ].

	aTextEditor segmentCollector
		cachedSegmentAt: changedTo
		ifFound: [ :aSegment | changedTo := aSegment index ]
		ifNotFound: [ changedTo := aTextEditor segmentCollector segments size ].	
	
	aTextEditor
		enqueueHolderCommand: self newHolderCommand
		interval: (changedFrom to: changedTo)
]

{ #category : #accessing }
AlbTextEditorSelectionUpdateCommand >> fromIndex [
	^ fromIndex
]

{ #category : #accessing }
AlbTextEditorSelectionUpdateCommand >> fromIndex: anObject [
	fromIndex := anObject
]

{ #category : #'instance creation' }
AlbTextEditorSelectionUpdateCommand >> newHolderCommand [
	^ AlbTextEditorSelectionChangedHolderCommand new
]

{ #category : #accessing }
AlbTextEditorSelectionUpdateCommand >> toIndex [
	^ toIndex
]

{ #category : #accessing }
AlbTextEditorSelectionUpdateCommand >> toIndex: anObject [
	toIndex := anObject
]
