Class {
	#name : 'AlbTextFieldEditorSegmentCollector',
	#superclass : 'AlbTextEditorSegmentCollector',
	#category : 'Album-Model-Segment-Text',
	#package : 'Album',
	#tag : 'Model-Segment-Text'
}

{ #category : 'initialization' }
AlbTextFieldEditorSegmentCollector >> defaultSplitter [

	^ AlbTextFieldEditorLineSplitter new
]
