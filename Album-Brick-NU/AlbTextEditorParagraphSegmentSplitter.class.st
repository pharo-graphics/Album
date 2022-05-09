Class {
	#name : #AlbTextEditorParagraphSegmentSplitter,
	#superclass : #AlbTextEditorLineSegmentSplitter,
	#category : #'Album-Brick-NU-Segment Paragraph'
}

{ #category : #accessing }
AlbTextEditorParagraphSegmentSplitter >> adornmentPieceClass [
	^ AlbTextEditorParagraphSegmentAdornmentPiece
]

{ #category : #'private - pieces computation' }
AlbTextEditorParagraphSegmentSplitter >> itemValueType: anObject [
	"Return a type of an item within a segment.
	Note: return value should be never used explicitely, it is only needed
	for direct comparison, therefore can be any immutable object"
	<return: #Symbol>
	
	^ #char
]

{ #category : #accessing }
AlbTextEditorParagraphSegmentSplitter >> textPieceClass [
	^ AlbTextEditorParagraphSegmentTextPiece
]