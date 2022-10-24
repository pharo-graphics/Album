Class {
	#name : #AlbTextEditorLineSegmentTextPiece,
	#superclass : #AlbTextEditorAbstractSegmentPiece,
	#category : #'Album-Model-Segment-Text-Line'
}

{ #category : #comparing }
AlbTextEditorLineSegmentTextPiece >> = anotherObject [
	self == anotherObject
		ifTrue: [ ^ true ].
	(anotherObject class == self class)
		ifFalse: [ ^ false ].
	
	^ anotherObject text = self text
]

{ #category : #'instance creation' }
AlbTextEditorLineSegmentTextPiece >> createElement: anEditorElement [
	<return: #BlElement>
	| anElement |

	anElement := (anEditorElement wordStencil
		wordPadding: self wordPadding;
		wordMargin: self wordMargin;
		segmentPiece: self) asElement.
	
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
