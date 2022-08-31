Class {
	#name : #AlbTextEditorParagraphSegmentTextPiece,
	#superclass : #AlbTextEditorParagraphSegmentPiece,
	#category : #'Album-Brick-NU-Model Segment Paragraph'
}

{ #category : #comparing }
AlbTextEditorParagraphSegmentTextPiece >> = anotherObject [
	self == anotherObject
		ifTrue: [ ^ true ].
	(anotherObject isKindOf: self class)
		ifFalse: [ ^ false ].
	
	^ anotherObject text = self text
]

{ #category : #'instance creation' }
AlbTextEditorParagraphSegmentTextPiece >> createElement: anEditorElement [
	<return: #BlElement>
	| anElement |

	anElement := (anEditorElement editor wordStencilBuilder
		wordPadding: self wordPadding;
		wordMargin: self wordMargin;
		segmentPiece: self) asElement.
		
	anElement userData removeKey: #editorAdornment ifAbsent: [  ].
	^ anElement
]

{ #category : #comparing }
AlbTextEditorParagraphSegmentTextPiece >> hash [
	^ self class hash bitXor: self text hash
]

{ #category : #testing }
AlbTextEditorParagraphSegmentTextPiece >> isText [
	^ true
]

{ #category : #updating }
AlbTextEditorParagraphSegmentTextPiece >> onRecycled: aPieceElement in: anEditorElement [

	anEditorElement editor wordStencilBuilder recycle: aPieceElement
]
