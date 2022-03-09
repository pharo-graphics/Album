Class {
	#name : #AlbEditorSegment,
	#superclass : #Object,
	#traits : 'TBlDebug',
	#classTraits : 'TBlDebug classTrait',
	#instVars : [
		'index'
	],
	#category : #'Album-Editor-Model - Segment'
}

{ #category : #'pieces - computation' }
AlbEditorSegment >> clearCache [
	"Clear all caches and make this segment fresh as if it would just be created and initalized"
]

{ #category : #accessing }
AlbEditorSegment >> index [
	"Return segment index within BrEditor.
	Note: index can not be nil"
	<return: #Number>
	
	self
		assert: [ index isNotNil ]
		description: [ 'Index can not be nil' ].

	^ index
]

{ #category : #accessing }
AlbEditorSegment >> index: aNumber [
	index := aNumber
]

{ #category : #testing }
AlbEditorSegment >> isFirstIn: aTextEditor [
	"Return true if I am absolutely the very first segment (not first cached) in a given text editor"

	^ self index = 1
]

{ #category : #testing }
AlbEditorSegment >> isLastIn: aTextEditor [
	"Return true if I am absolutely the very last segment (not last cached) in a given text editor"

	^ self index = aTextEditor segmentCollector segments size
]

{ #category : #accessing }
AlbEditorSegment >> segmentType [
	"Return a type of this segment responsible for creation
	of segment holder and also used as a key for caching purposes"
	<return: #BrEditorSegmentType>
	
	^ self subclassResponsibility
]
