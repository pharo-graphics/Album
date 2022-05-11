Class {
	#name : #AlbTextEditorLineSegmentTextPiece,
	#superclass : #AlbTextEditorLineSegmentPiece,
	#category : #'Album-Model-Segment-Text-Line'
}

{ #category : #comparing }
AlbTextEditorLineSegmentTextPiece >> = anotherObject [
	self == anotherObject
		ifTrue: [ ^ true ].
	(anotherObject isKindOf: self class)
		ifFalse: [ ^ false ].
	
	^ anotherObject text = self text
]

{ #category : #'instance creation' }
AlbTextEditorLineSegmentTextPiece >> createElement: anEditorElement [
	<return: #BlElement>
	| anElement |

	anElement := (anEditorElement editor segmentBuilder wordStencilBuilder
		wordPadding: self wordPadding;
		wordMargin: self wordMargin;
		segmentPiece: self) asElement.
		
	anElement userData removeKey: #brickEditorAdornment ifAbsent: [  ].
	
	^ anElement
]

{ #category : #comparing }
AlbTextEditorLineSegmentTextPiece >> hash [
	^ self class hash bitXor: self text hash
]

{ #category : #testing }
AlbTextEditorLineSegmentTextPiece >> isText [
	^ true
]

{ #category : #'instance creation' }
AlbTextEditorLineSegmentTextPiece >> onRecycled: aPieceElement in: anEditorElement [
	anEditorElement editor segmentBuilder wordStencilBuilder recycle: aPieceElement
]
