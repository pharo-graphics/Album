Class {
	#name : #AlbTextEditorParagraphSplitter,
	#superclass : #BrTextEditorLineSplitter,
	#category : #'Album-Editor-Model - Segment-Text-Paragraph'
}

{ #category : #'instance creation' }
AlbTextEditorParagraphSplitter >> newSegment [
	^ AlbTextEditorParagraphSegment new
]
