Class {
	#name : #AlbTextEditorParagraphSegmentType,
	#superclass : #AlbEditorSegmentType,
	#category : #'Album-Brick-NU-Segment Paragraph'
}

{ #category : #accessing }
AlbTextEditorParagraphSegmentType >> holder [
	"Instantiate and return a new text segment holder based on my type"
	<return: #AlbEditorSegmentHolder>

	^ AlbTextEditorParagraphSegmentHolder new
]
