Class {
	#name : #AlbTextEditorLineSegmentTextListener,
	#superclass : #AlbTextWordPieceUniqueHandler,
	#category : #'Album-UI-Word'
}

{ #category : #accessing }
AlbTextEditorLineSegmentTextListener >> eventClass [
	^ BlMouseEvent
]

{ #category : #'api - event managing' }
AlbTextEditorLineSegmentTextListener >> handleEvent: aBlMouseEvent [

	| aTextElement anEditorElement aLocalPosition aTextIndex anIterator theAttributes textEditor |
	aTextElement := aBlMouseEvent currentTarget.
	"If text element has no paragraph we can not find text index for mouse event"
	aTextElement paragraph ifNil: [ ^ self ].
	"To not create an instance of me for each tiny text element"
	anEditorElement := aTextElement
		                   allParentsDetect: [ :anElement | anElement isKindOf: AlbEditorElement ]
		                   ifFound: #yourself
		                   ifNone: [ ^ self ].
	textEditor := anEditorElement editor.
	aLocalPosition := aTextElement globalPointToLocal: aBlMouseEvent position.
	aTextIndex := aTextElement indexAtScreenPosition: aLocalPosition.
	anIterator := aTextElement text
		              iterator: aTextIndex + 1
		              to: (aTextIndex + 1 min: aTextElement text size).

	theAttributes := anIterator selectAttributes: [ :anAttribute | anAttribute isEventHandler ].
	"attributeMouseEvent := AlbTextCursorAttributeMouseEvent new
		                       textEditor: anEditorElement editor;
		                       textualPiece: aTextElement segmentPiece;
		                       wrappedEvent: aBlMouseEvent."
	theAttributes do: [ :anAttribute | 
		textEditor fireEvent: aBlMouseEvent ]
]
