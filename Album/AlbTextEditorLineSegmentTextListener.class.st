Class {
	#name : #AlbTextEditorLineSegmentTextListener,
	#superclass : #AlbTextWordPieceUniqueHandler,
	#category : #'Album-UI-Word'
}

{ #category : #cleanup }
AlbTextEditorLineSegmentTextListener class >> cleanUp [
	super cleanUp.
	
	uniqueInstance := nil
]

{ #category : #accessing }
AlbTextEditorLineSegmentTextListener class >> uniqueInstance [
	^ uniqueInstance ifNil: [ uniqueInstance := self new ]
]

{ #category : #accessing }
AlbTextEditorLineSegmentTextListener >> eventClass [
	^ BlMouseEvent
]

{ #category : #'as yet unclassified' }
AlbTextEditorLineSegmentTextListener >> handleEvent: aBlMouseEvent [
	| aTextElement anEditorElement aLocalPosition aTextIndex anIterator theAttributes |

	aTextElement := aBlMouseEvent currentTarget.
	"If text element has no paragraph we can not find text index for mouse event"
	aTextElement rawParagraph
		ifNil: [ ^ self ].

	"To not create an instance of me for each tiny text element"
	anEditorElement := aTextElement
		allParentsDetect: [ :anElement | (anElement isKindOf: BrEditorElement) or: [anElement isKindOf: AlbEditorElement] ]
		ifFound: #yourself
		ifNone: [ ^ self ].
	
	aLocalPosition := aTextElement globalPointToLocal: aBlMouseEvent position.

	aTextIndex := aTextElement indexAtScreenPosition: aLocalPosition.

	anIterator := aTextElement text
		iterator: (aTextIndex + 1)
		to: ((aTextIndex + 1) min: aTextElement text size).

	theAttributes := anIterator selectAttributes: [ :anAttribute | anAttribute isEventHandler ].

	theAttributes do: [ :anAttribute |
		(anAttribute wantsEvent: aBlMouseEvent in: anEditorElement editor)
			ifTrue: [ anAttribute handleEvent: aBlMouseEvent in: anEditorElement editor on: aTextElement segmentPiece ] ]
]
