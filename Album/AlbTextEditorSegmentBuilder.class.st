Class {
	#name : #AlbTextEditorSegmentBuilder,
	#superclass : #Object,
	#traits : 'TBlDebug',
	#classTraits : 'TBlDebug classTrait',
	#instVars : [
		'lineSplitter'
	],
	#category : #'Album-Editor-Model - Segment-Text'
}

{ #category : #'text - modifications' }
AlbTextEditorSegmentBuilder >> addedAttribute: anAttribute from: aFromIndex to: aToIndex in: aBrTextEditor [
	"Is sent after an attribute was added in provided text editor"

	self subclassResponsibility
]

{ #category : #accessing }
AlbTextEditorSegmentBuilder >> beEditable [
	self subclassResponsibility
]

{ #category : #accessing }
AlbTextEditorSegmentBuilder >> beReadOnly [
	self subclassResponsibility
]

{ #category : #initialization }
AlbTextEditorSegmentBuilder >> defaultSplitter [
	<return: #AlbTextEditorSplitter>

	^ self subclassResponsibility
]

{ #category : #'text - modifications' }
AlbTextEditorSegmentBuilder >> deletedFrom: aFromIndex to: aToIndex in: aBrTextEditor [
	"Is sent after a piece of text is deleted within from and to index interval in provided text editor"

	self subclassResponsibility
]

{ #category : #initialization }
AlbTextEditorSegmentBuilder >> initialize [
	super initialize.

	lineSplitter := self defaultSplitter
]

{ #category : #'text - modifications' }
AlbTextEditorSegmentBuilder >> insertedString: aString at: aTextIndex in: aBrTextEditor [
	"Is sent after a String was inserted at a given index in provided text editor"

	self subclassResponsibility
]

{ #category : #'text - modifications' }
AlbTextEditorSegmentBuilder >> removedAttributesFrom: aFromIndex to: aToIndex in: aBrTextEditor [
	"Is sent after an attributes were removed in provided text editor"

	self subclassResponsibility
]

{ #category : #splitting }
AlbTextEditorSegmentBuilder >> split: aBrText in: aStream [
	self splitter split: aBrText in: aStream
]

{ #category : #splitting }
AlbTextEditorSegmentBuilder >> split: aBrText in: aBrEditorSegmentStream offset: anOffset [
	self splitter split: aBrText in: aBrEditorSegmentStream offset: anOffset
]

{ #category : #accessing }
AlbTextEditorSegmentBuilder >> splitter [
	<return: #BrTextEditorSplitter>

	^ lineSplitter
]

{ #category : #accessing }
AlbTextEditorSegmentBuilder >> splitter: aBrTextEditorSplitter [
	self
		assert: [ aBrTextEditorSplitter isNotNil ]
		description: [ 'Splitter must not be nil' ].

	lineSplitter := aBrTextEditorSplitter
]
