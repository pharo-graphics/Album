Class {
	#name : #AlbTextEmbellishmentAttribute,
	#superclass : #AlbTextAdornmentAttribute,
	#instVars : [
		'embellishment',
		'padding',
		'margin'
	],
	#category : #'Album-Editor-Attributes'
}

{ #category : #accessing }
AlbTextEmbellishmentAttribute >> doAffect: aTTextEditorTextualPiece in: anEditorElement [
	"Return an element that should affect (either append or replace) a provided text piece"
	<return: #SequenceableCollection of: #BlElement>
	| aReplacementTextElement |

	aReplacementTextElement := (anEditorElement editor segmentBuilder wordStencilBuilder
		wordPadding: padding + aTTextEditorTextualPiece wordPadding;
		wordMargin: margin + aTTextEditorTextualPiece wordMargin;
		shouldUsePool: false;
		segmentPiece: aTTextEditorTextualPiece) asElement.

	embellishment cull: aReplacementTextElement cull: aTTextEditorTextualPiece.
	
	^ {
		aReplacementTextElement.
		BlElement new size: 0@0
	}
]

{ #category : #'api - attribute' }
AlbTextEmbellishmentAttribute >> embellishment [
	^ embellishment
]

{ #category : #'api - attribute' }
AlbTextEmbellishmentAttribute >> embellishment: anObject [
	embellishment := anObject
]

{ #category : #initialization }
AlbTextEmbellishmentAttribute >> initialize [
	super initialize.
	
	embellishment := [ :aTextPieceElement :aTTextEditorTextualPiece | ].
	padding := BlInsets empty.
	margin := BlInsets empty
]

{ #category : #accessing }
AlbTextEmbellishmentAttribute >> margin [
	^ margin
]

{ #category : #accessing }
AlbTextEmbellishmentAttribute >> margin: anObject [
	margin := anObject
]

{ #category : #'api - attribute' }
AlbTextEmbellishmentAttribute >> padding [
	<return: #BlInsets>

	^ padding
]

{ #category : #'api - attribute' }
AlbTextEmbellishmentAttribute >> padding: anObject [
	padding := anObject
]

{ #category : #'api - attribute' }
AlbTextEmbellishmentAttribute >> roundedBackground: aPaint [
	self embellishment: [ :anElement |
		anElement background: aPaint.
		anElement geometry: (BlRoundedRectangleGeometry cornerRadius: 4) ].
	self padding: (BlInsets all: 3).
	self margin: (BlInsets top: 3 bottom: 3)
]
