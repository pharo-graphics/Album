Class {
	#name : #AlbTextEditorScreenToCursorCommand,
	#superclass : #AlbTextEditorCommand,
	#instVars : [
		'transformation'
	],
	#category : #'Album-Commands'
}

{ #category : #executing }
AlbTextEditorScreenToCursorCommand >> executeOn: aTextEditor [
	self transformation evaluateOn: self for: aTextEditor
]

{ #category : #executing }
AlbTextEditorScreenToCursorCommand >> explicitScreenToCursor: aTransformation for: aTextEditor [

	"we convert a pure screen position, should send to all segment holders"
	aTextEditor
		enqueueHolderCommand: self newHolderCommand
		interval: aTextEditor segmentCollector cachedInterval
]

{ #category : #'instance creation' }
AlbTextEditorScreenToCursorCommand >> newHolderCommand [
	^ AlbTextEditorScreenToCursorHolderCommand new
		transformation: self transformation
]

{ #category : #executing }
AlbTextEditorScreenToCursorCommand >> relativeScreenToCursor: aTransformation for: aTextEditor [

	"we convert a relative screen position, should send only to the segment at the cursor position"
	aTextEditor segmentCollector
		cachedSegmentAt: self transformation cursor position
		ifFound: [ :aSegment |
			aTextEditor
				enqueueHolderCommand: self newHolderCommand
				interval: (aSegment index to: aSegment index) ]
		ifNotFound: [  ].
]

{ #category : #accessing }
AlbTextEditorScreenToCursorCommand >> transformation [
	^ transformation
]

{ #category : #accessing }
AlbTextEditorScreenToCursorCommand >> transformation: anObject [
	transformation := anObject
]
