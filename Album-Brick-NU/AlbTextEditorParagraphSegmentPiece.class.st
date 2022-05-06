Class {
	#name : #AlbTextEditorParagraphSegmentPiece,
	#superclass : #Object,
	#traits : 'TAlbTextEditorTextualPiece',
	#classTraits : 'TAlbTextEditorTextualPiece classTrait',
	#instVars : [
		'segment'
	],
	#category : #'Album-Brick-NU-Segment Paragraph'
}

{ #category : #'instance creation' }
AlbTextEditorParagraphSegmentPiece >> createElement: anEditorElement [
	<return: #BlElement>

	^ self subclassResponsibility
]

{ #category : #testing }
AlbTextEditorParagraphSegmentPiece >> isText [
	^ false
]

{ #category : #updating }
AlbTextEditorParagraphSegmentPiece >> onRecycled: aPieceElement in: anEditorElement [
]

{ #category : #printing }
AlbTextEditorParagraphSegmentPiece >> printOn: aStream [
	self text printOn: aStream
]

{ #category : #accessing }
AlbTextEditorParagraphSegmentPiece >> segment [
	^ segment
]

{ #category : #accessing }
AlbTextEditorParagraphSegmentPiece >> segment: anObject [
	segment := anObject
]

{ #category : #updating }
AlbTextEditorParagraphSegmentPiece >> updateFocus: hasFocus of: aTextPieceElement in: anEditorElement [
	| aRequest |

	aRequest := hasFocus
		ifTrue: [ AlbTextEditorFocusRequest new ]
		ifFalse: [ AlbTextEditorBlurRequest new ].

	aTextPieceElement dispatchEvent: (aRequest editorElement: anEditorElement)
]

{ #category : #updating }
AlbTextEditorParagraphSegmentPiece >> updateText: aTextElement of: aLineSegment in: anEditorElement [
	aTextElement dispatchEvent: (AlbTextEditorTextChangedRequest new
		editorElement: anEditorElement;
		segmentPiece: self;
		text: self text;
		textStart: self textStart;
		textEnd: self textEnd)
]

{ #category : #'api - geometry' }
AlbTextEditorParagraphSegmentPiece >> wordMargin [
	<return: #BlInsets>
	| aHalfOfLineSpacing |
	
	aHalfOfLineSpacing := (self segment lineSpacing / 2.0) floor.

	^ BlInsets
		top: aHalfOfLineSpacing
		bottom: (self segment lineSpacing - aHalfOfLineSpacing)
]

{ #category : #'api - geometry' }
AlbTextEditorParagraphSegmentPiece >> wordPadding [
	<return: #BlInsets>
		
	^ self segment wordPadding
]
