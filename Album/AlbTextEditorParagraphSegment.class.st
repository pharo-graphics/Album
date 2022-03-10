Class {
	#name : #AlbTextEditorParagraphSegment,
	#superclass : #BrTextEditorSegment,
	#instVars : [
		'pieces',
		'lineSpacing',
		'wordPadding',
		'paragraphMargin'
	],
	#category : #'Album-Editor-Model - Segment-Text-Paragraph'
}

{ #category : #'pieces - computation' }
AlbTextEditorParagraphSegment >> clearCache [
	"Clear all caches and make this segment fresh as if it would just be created and initalized"
	super clearCache.

	pieces := nil
]

{ #category : #'pieces - computation' }
AlbTextEditorParagraphSegment >> computedPieces [
	<return: #SequenceableCollection of: #AlbTextEditorLineSegmentPiece>
	| thePieces |

	thePieces := AlbTextEditorParagraphSegmentSplitter new
		split: self text
		from: self textStart
		to: self textEnd.
	thePieces do: [ :eachPiece | eachPiece segment: self ].

	^ thePieces
]

{ #category : #testing }
AlbTextEditorParagraphSegment >> hasPieces [
	<return: #Boolean>

	^ pieces isNotNil
]

{ #category : #initialization }
AlbTextEditorParagraphSegment >> initialize [
	super initialize.

	self resetProperties
]

{ #category : #testing }
AlbTextEditorParagraphSegment >> isLastTextPiece: aSegmentPiece [
	<return: #Boolean>
	
	self hasPieces
		ifFalse: [ ^ false ].

	self pieces reverseDo: [ :eachPiece |
		eachPiece isText ifTrue: [ ^ eachPiece == aSegmentPiece ] ].
	
	^ false
]

{ #category : #'attributes - paragraph' }
AlbTextEditorParagraphSegment >> lineSpacing [
	<return: #Number>

	^ lineSpacing
]

{ #category : #'attributes - paragraph' }
AlbTextEditorParagraphSegment >> lineSpacing: aNumber [
	lineSpacing := aNumber
]

{ #category : #'text - modifications' }
AlbTextEditorParagraphSegment >> moveTextBy: aNumber [
	super moveTextBy: aNumber.

	"no pieces created (they were not requested yet so no need to move them)"
	self hasPieces
		ifFalse: [ ^ self ].

	self pieces
		do: [ :aTextPiece | aTextPiece start: aTextPiece textStart + aNumber end: aTextPiece textEnd + aNumber ]
]

{ #category : #'text - modifications' }
AlbTextEditorParagraphSegment >> moveTextPiecesBy: aNumber at: aTextIndex [
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
AlbTextEditorParagraphSegment >> paragraphMargin [
	<return: #BlInsets>

	^ paragraphMargin
]

{ #category : #'attributes - paragraph' }
AlbTextEditorParagraphSegment >> paragraphMargin: aBlInsets [
	paragraphMargin := aBlInsets
]

{ #category : #accessing }
AlbTextEditorParagraphSegment >> pieces [
	<return: #Array of: #AlbTextEditorLineSegmentPiece>

	^ self hasPieces
		ifTrue: [ pieces ]
		ifFalse: [ pieces := self computedPieces ]
]

{ #category : #initialization }
AlbTextEditorParagraphSegment >> resetProperties [
	lineSpacing := 0.
	wordPadding := BlInsets empty.
	paragraphMargin := BlInsets empty.
]

{ #category : #accessing }
AlbTextEditorParagraphSegment >> segmentType [
	"Return a type of this segment responsible for creation
	of segment holder and also used as a key for caching purposes"
	<return: #AlbEditorSegmentType>
	
	^ AlbTextEditorParagraphSegmentType uniqueInstance
]

{ #category : #'text - modifications' }
AlbTextEditorParagraphSegment >> updateSegmentProperties [
	| theParagraphAttributes |
	
	self resetProperties.
	
	theParagraphAttributes := text iterator selectAttributes: #isParagraphAttribute.
	theParagraphAttributes do: [ :aParagraphAttribute |
		aParagraphAttribute applyOn: self ]
]

{ #category : #'attributes - paragraph' }
AlbTextEditorParagraphSegment >> wordPadding [
	<return: #BlInsets>

	^ wordPadding
]

{ #category : #'attributes - paragraph' }
AlbTextEditorParagraphSegment >> wordPadding: aBlInsets [
	wordPadding := aBlInsets
]
