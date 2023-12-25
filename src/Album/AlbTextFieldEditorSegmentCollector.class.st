Class {
	#name : #AlbTextFieldEditorSegmentCollector,
	#superclass : #AlbTextEditorSegmentCollector,
	#category : 'Album-Model-Segment-Text'
}

{ #category : #initialization }
AlbTextFieldEditorSegmentCollector >> defaultSplitter [

	^ AlbTextFieldEditorLineSplitter new
]
