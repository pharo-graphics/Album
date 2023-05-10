Class {
	#name : #AlbTextEditorLineSegment,
	#superclass : #AlbTextEditorSegment,
	#instVars : [
		'pieces',
		'lineSpacing',
		'wordPadding',
		'paragraphMargin'
	],
	#category : #'Album-Model-Segment-Text-Line'
}

{ #category : #'pieces - computation' }
AlbTextEditorLineSegment >> clearCache [
	"Clear all caches and make this segment fresh as if it would just be created and initalized"
	super clearCache.

	pieces := nil
]

{ #category : #'pieces - computation' }
AlbTextEditorLineSegment >> computedPieces [
	<return: #SequenceableCollection of: #AlbTextEditorAbstractSegmentPiece>
	^ AlbTextEditorSegmentSplitter new splitSegment: self.

]

{ #category : #testing }
AlbTextEditorLineSegment >> hasPieces [
	<return: #Boolean>

	^ pieces isNotNil
]

{ #category : #initialization }
AlbTextEditorLineSegment >> initialize [
	super initialize.

	self resetProperties
]

{ #category : #testing }
AlbTextEditorLineSegment >> isLastTextPiece: aSegmentPiece [
	<return: #Boolean>
	
	self hasPieces
		ifFalse: [ ^ false ].

	self pieces reverseDo: [ :eachPiece |
		eachPiece isText ifTrue: [ ^ eachPiece == aSegmentPiece ] ].
	
	^ false
]

{ #category : #'attributes - paragraph' }
AlbTextEditorLineSegment >> lineSpacing [
	<return: #Number>

	^ lineSpacing
]

{ #category : #'attributes - paragraph' }
AlbTextEditorLineSegment >> lineSpacing: aNumber [
	lineSpacing := aNumber
]

{ #category : #'text - modifications' }
AlbTextEditorLineSegment >> moveTextBy: aNumber [
	super moveTextBy: aNumber.

	"no pieces created (they were not requested yet so no need to move them)"
	self hasPieces
		ifFalse: [ ^ self ].

	self pieces
		do: [ :aTextPiece | aTextPiece start: aTextPiece textStart + aNumber end: aTextPiece textEnd + aNumber ]
]

{ #category : #'text - modifications' }
AlbTextEditorLineSegment >> moveTextPiecesBy: aNumber at: aTextIndex [
	"aTextIndex is a Text index, not a cursor one!"
	| aCursorIndex |
	super moveTextPiecesBy: aNumber at: aTextIndex.
	
	aCursorIndex := (aTextIndex - 1) max: 0.

	"no pieces created (they were not requested yet so no need to move them)"
	self hasPieces
		ifFalse: [ ^ self ].

	self pieces
		do: [ :aTextPiece |
			
			aNumber > 0
				ifTrue: [
					aTextPiece textEnd > aCursorIndex
						ifTrue: [
							aTextPiece textStart > aCursorIndex
								ifTrue: [ aTextPiece
									start: aTextPiece textStart + aNumber
									end: aTextPiece textEnd + aNumber ]
								ifFalse: [ aTextPiece
									start: aTextPiece textStart
									end: aTextPiece textEnd + aNumber ] ] ]
				ifFalse: [
					aTextPiece textEnd > aCursorIndex
						ifTrue: [
							"deletion happened before this text piece"
							aTextPiece textStart > aCursorIndex
								ifTrue: [
									| aLastDeletedIndex |
									aLastDeletedIndex := aCursorIndex + aNumber abs.
									aTextPiece
										start: aCursorIndex
										end: ((aTextPiece textEnd - aLastDeletedIndex) max: aCursorIndex) ]
								"deletion happened inside of this text piece"
								ifFalse: [
									aTextPiece
										start: aTextPiece textStart
										"end is start + how many left after deletion"
										end: aCursorIndex + ((aTextPiece textEnd - aCursorIndex - aNumber abs) max: 0) ] ] ] ]
]

{ #category : #'attributes - paragraph' }
AlbTextEditorLineSegment >> paragraphMargin [
	<return: #BlInsets>

	^ paragraphMargin
]

{ #category : #'attributes - paragraph' }
AlbTextEditorLineSegment >> paragraphMargin: aBlInsets [
	paragraphMargin := aBlInsets
]

{ #category : #accessing }
AlbTextEditorLineSegment >> pieces [
	<return: #Array of: #AlbTextEditorAbstractSegmentPiece>

	^ self hasPieces
		ifTrue: [ pieces ]
		ifFalse: [ pieces := self computedPieces ]
]

{ #category : #initialization }
AlbTextEditorLineSegment >> resetProperties [
	lineSpacing := 0.
	wordPadding := BlInsets empty.
	paragraphMargin := BlInsets empty.
]

{ #category : #'text - modifications' }
AlbTextEditorLineSegment >> updateSegmentProperties [
	| theParagraphAttributes |
	
	self resetProperties.
	
	theParagraphAttributes := text iterator selectAttributes: #isParagraphAttribute.
	theParagraphAttributes do: [ :aParagraphAttribute |
		aParagraphAttribute applyOn: self ]
]

{ #category : #'attributes - paragraph' }
AlbTextEditorLineSegment >> wordPadding [
	<return: #BlInsets>

	^ wordPadding
]

{ #category : #'attributes - paragraph' }
AlbTextEditorLineSegment >> wordPadding: aBlInsets [
	wordPadding := aBlInsets
]
