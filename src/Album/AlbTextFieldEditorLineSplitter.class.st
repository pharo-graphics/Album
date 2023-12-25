Class {
	#name : #AlbTextFieldEditorLineSplitter,
	#superclass : #AlbTextEditorLineSplitter,
	#category : 'Album-Model-Segment-Text-Line'
}

{ #category : #'instance creation' }
AlbTextFieldEditorLineSplitter >> newSegment [
	^ AlbTextFieldEditorLineSegment new
]
