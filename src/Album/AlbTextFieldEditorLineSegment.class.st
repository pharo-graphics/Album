Class {
	#name : #AlbTextFieldEditorLineSegment,
	#superclass : #AlbTextEditorLineSegment,
	#category : #'Album-Model-Segment-Text-Line'
}

{ #category : #'pieces - computation' }
AlbTextFieldEditorLineSegment >> newSplitter [

	^ AlbTextEditorLineSegmentSplitter new
		  beCharacterBased;
		  yourself
]
