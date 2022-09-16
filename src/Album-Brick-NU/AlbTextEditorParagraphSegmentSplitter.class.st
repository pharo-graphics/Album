Class {
	#name : #AlbTextEditorParagraphSegmentSplitter,
	#superclass : #AlbTextEditorLineSegmentSplitter,
	#category : #'Album-Brick-NU-Segment Paragraph'
}

{ #category : #'private - pieces computation' }
AlbTextEditorParagraphSegmentSplitter >> itemValueType: anObject [
	"Return a type of an item within a segment.
	Note: return value should be never used explicitely, it is only needed
	for direct comparison, therefore can be any immutable object"
	<return: #Symbol>
	
	^ #char
]

{ #category : #'private - pieces computation' }
AlbTextEditorParagraphSegmentSplitter >> splitSegment: aTextEditorSegment [ 
	| thePieces |

	thePieces := self
		split: aTextEditorSegment text
		from: aTextEditorSegment textStart
		to: aTextEditorSegment textEnd.
	thePieces do: [ :eachPiece | eachPiece segment: aTextEditorSegment ].
	^ thePieces
]

{ #category : #accessing }
AlbTextEditorParagraphSegmentSplitter >> textPieceClass [
	^ AlbTextEditorParagraphSegmentTextPiece
]
