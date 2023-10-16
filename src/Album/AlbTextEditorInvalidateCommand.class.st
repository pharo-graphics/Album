Class {
	#name : 'AlbTextEditorInvalidateCommand',
	#superclass : 'AlbTextEditorCommand',
	#instVars : [
		'fromIndex',
		'toIndex'
	],
	#category : 'Album-Commands',
	#package : 'Album',
	#tag : 'Commands'
}

{ #category : 'executing' }
AlbTextEditorInvalidateCommand >> executeOn: aTextEditor [

	| changedFrom changedTo |
	changedFrom := self fromIndex. "now it is text index"
	changedTo := self toIndex. "now it is text index"

	"convert from text => to segment index"
	aTextEditor segmentCollector
		cachedSegmentAt: changedFrom
		ifFound: [ :aSegment | changedFrom := aSegment index ]
		ifNotFound: [ changedFrom := 1 ].

	"convert from text => to segment index"
	aTextEditor segmentCollector
		cachedSegmentAt: changedTo
		ifFound: [ :aSegment | changedTo := aSegment index ]
		ifNotFound: [ changedTo := aTextEditor segmentCollector segments size ].
	aTextEditor notifyItems: (changedFrom to: changedTo) event: self newHolderEvent
]

{ #category : 'accessing' }
AlbTextEditorInvalidateCommand >> fromIndex [
	^ fromIndex
]

{ #category : 'accessing' }
AlbTextEditorInvalidateCommand >> fromIndex: aFromTextIndex [
	fromIndex := aFromTextIndex
]

{ #category : 'instance creation' }
AlbTextEditorInvalidateCommand >> newHolderEvent [
	^ AlbTextEditorTextChangedHolderEvent new
]

{ #category : 'accessing' }
AlbTextEditorInvalidateCommand >> toIndex [
	^ toIndex
]

{ #category : 'accessing' }
AlbTextEditorInvalidateCommand >> toIndex: aToTextIndex [
	toIndex := aToTextIndex
]
