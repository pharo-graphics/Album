Class {
	#name : #AlbTextEditorParagraphSplitter,
	#superclass : #BrTextEditorLineSplitter,
	#category : #'Album-Model-Segment-Text-Paragraph'
}

{ #category : #'instance creation' }
AlbTextEditorParagraphSplitter >> newSegment [
	^ AlbTextEditorParagraphSegment new
]
