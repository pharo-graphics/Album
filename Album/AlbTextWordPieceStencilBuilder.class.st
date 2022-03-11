Class {
	#name : #AlbTextWordPieceStencilBuilder,
	#superclass : #BrStencilBuilder,
	#instVars : [
		'wordPadding',
		'wordMargin',
		'segmentPiece',
		'shouldUsePool'
	],
	#category : #'Album-UI-Stencils'
}

{ #category : #'private - pool' }
AlbTextWordPieceStencilBuilder >> acquire [
	<return: #AlbTextElementWithCursors or: nil>
	
	shouldUsePool
		ifFalse: [ ^ nil ].
	
	^ self pool acquire
]

{ #category : #'api - instantiation' }
AlbTextWordPieceStencilBuilder >> buildDefault [
	| aTextElement |
	
	aTextElement := (self acquire ifNil: [ self createWordElement ])
		segmentPiece: self segmentPiece;
		padding: self wordPadding;
		margin: self wordMargin.
		
	aTextElement userData at: #editorPool put: self pool.

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
AlbTextWordPieceStencilBuilder >> pool [
	^ self subclassResponsibility
]

{ #category : #'private - pool' }
AlbTextWordPieceStencilBuilder >> recycle: aPieceElement [
	aPieceElement removeFromParent.
	aPieceElement removeCursors.
	aPieceElement selectNone.

	"otherwise attributes may not be garbage collected
	see https://github.com/feenkcom/gtoolkit/issues/537"
	aPieceElement removeSegmentPiece.

	aPieceElement userData
		at: #editorPool
		ifPresent: [ :aPool | aPool == self pool ifTrue: [ self pool release: aPieceElement  ] ]
]

{ #category : #initialization }
AlbTextWordPieceStencilBuilder >> reset [
	wordPadding := BlInsets empty.
	wordMargin := BlInsets empty.
	segmentPiece := nil.
	shouldUsePool := true
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
AlbTextWordPieceStencilBuilder >> shouldUsePool [
	^ shouldUsePool
]

{ #category : #accessing }
AlbTextWordPieceStencilBuilder >> shouldUsePool: aBoolean [
	shouldUsePool := aBoolean
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
