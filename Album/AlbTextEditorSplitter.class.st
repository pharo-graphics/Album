Class {
	#name : #AlbTextEditorSplitter,
	#superclass : #Object,
	#category : #'Album-Editor-Model - Segment-Text'
}

{ #category : #'api - splitting' }
AlbTextEditorSplitter >> split: aBlText in: aBrEditorSegmentStream [
	self
		split: (aBlText from: 1 to: aBlText size)
		in: aBrEditorSegmentStream
		offset: 0
]

{ #category : #'api - splitting' }
AlbTextEditorSplitter >> split: aBrText in: aBrEditorSegmentStream offset: anOffset [
	self subclassResponsibility
]
