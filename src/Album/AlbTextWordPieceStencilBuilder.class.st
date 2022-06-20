Class {
	#name : #AlbTextWordPieceStencilBuilder,
	#superclass : #OBlStencilBuilder,
	#instVars : [
		'wordPadding',
		'wordMargin',
		'segmentPiece'
	],
	#category : #'Album-UI-Stencils'
}

{ #category : #'api - instantiation' }
AlbTextWordPieceStencilBuilder >> buildDefault [

	| aTextElement |
	aTextElement := self createWordElement
		                segmentPiece: self segmentPiece;
		                padding: self wordPadding;
		                margin: self wordMargin.

	self reset.

	^ aTextElement
]

{ #category : #'api - instantiation' }
AlbTextWordPieceStencilBuilder >> createWordElement [
	<return: #AlbTextElementWithCursors>

	^ self subclassResponsibility
]

{ #category : #initialization }
AlbTextWordPieceStencilBuilder >> initialize [
	super initialize.
	
	self reset
]

{ #category : #'api - instantiation' }
AlbTextWordPieceStencilBuilder >> paramsOn: aStencilExecutor [
	aStencilExecutor push: self segmentPiece
]

{ #category : #'private - pool' }
AlbTextWordPieceStencilBuilder >> recycle: aPieceElement [
	aPieceElement removeFromParent.
	aPieceElement removeCursors.
	aPieceElement selectNone.

	"otherwise attributes may not be garbage collected
	see https://github.com/feenkcom/gtoolkit/issues/537"
	aPieceElement removeSegmentPiece.
]

{ #category : #initialization }
AlbTextWordPieceStencilBuilder >> reset [
	wordPadding := BlInsets empty.
	wordMargin := BlInsets empty.
	segmentPiece := nil
]

{ #category : #accessing }
AlbTextWordPieceStencilBuilder >> segmentPiece [
	<return: #TAlbTextEditorTextualPiece>

	^ segmentPiece
]

{ #category : #accessing }
AlbTextWordPieceStencilBuilder >> segmentPiece: aTAlbTextEditorTextualPiece [
	segmentPiece := aTAlbTextEditorTextualPiece
]

{ #category : #accessing }
AlbTextWordPieceStencilBuilder >> wordMargin [
	<return: #BlInsets>

	^ wordMargin
]

{ #category : #accessing }
AlbTextWordPieceStencilBuilder >> wordMargin: aBlInsets [
	wordMargin := aBlInsets
]

{ #category : #accessing }
AlbTextWordPieceStencilBuilder >> wordPadding [
	<return: #BlInsets>

	^ wordPadding
]

{ #category : #accessing }
AlbTextWordPieceStencilBuilder >> wordPadding: aBlInsets [
	wordPadding := aBlInsets
]
