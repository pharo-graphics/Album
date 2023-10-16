Class {
	#name : 'AlbTextEditorSplitter',
	#superclass : 'Object',
	#category : 'Album-Model-Segment-Text',
	#package : 'Album',
	#tag : 'Model-Segment-Text'
}

{ #category : 'api - splitting' }
AlbTextEditorSplitter >> split: aBlText in: aEditorSegmentStream [
	self
		split: (aBlText from: 1 to: aBlText size)
		in: aEditorSegmentStream
		offset: 0
]

{ #category : 'api - splitting' }
AlbTextEditorSplitter >> split: aText in: aEditorSegmentStream offset: anOffset [
	self subclassResponsibility
]
