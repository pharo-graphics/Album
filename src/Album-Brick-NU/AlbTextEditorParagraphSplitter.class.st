Class {
	#name : #AlbTextEditorParagraphSplitter,
	#superclass : #AlbTextEditorLineSplitter,
	#category : #'Album-Brick-NU-Segment Paragraph'
}

{ #category : #'instance creation' }
AlbTextEditorParagraphSplitter >> newSegment [
	^ AlbTextEditorParagraphSegment new
]
