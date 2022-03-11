Class {
	#name : #AlbTextEditorParagraphSplitter,
	#superclass : #AlbTextEditorLineSplitter,
	#category : #'Album-Model-Segment-Text-Paragraph'
}

{ #category : #'instance creation' }
AlbTextEditorParagraphSplitter >> newSegment [
	^ AlbTextEditorParagraphSegment new
]
