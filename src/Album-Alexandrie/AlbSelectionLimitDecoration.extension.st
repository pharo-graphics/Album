Extension { #name : #AlbSelectionLimitDecoration }

{ #category : #'*Album-Alexandrie' }
AlbSelectionLimitDecoration >> aeDraw: anItemElement on: aeCanvas in: anInfiniteElement [

	| firstTextElement rect |
	BlTextParagraph selectionMatchParent ifTrue: [ ^self ].
	anItemElement hasChildren ifFalse: [ ^ self ].
	firstTextElement := anItemElement firstChild.
	(firstTextElement hasSelection or: [firstTextElement hasCursor]) ifFalse: [ ^ self ].
	"(firstTextElement hasSelection not and: [firstTextElement hasCursor and: [firstTextElement cursorElement bounds left > 0]]) ifTrue: [ ^self ]."
	(firstTextElement hasSelection and: [firstTextElement selection from > 0]) ifTrue: [ ^self ].
	aeCanvas restoreContextAfter: [ | w |
		w := anItemElement constraints infinite decorationInsets left.
		aeCanvas pathTranslate: w - self width @ anItemElement bounds inParent top.

		rect := Rectangle origin: 0 @ 0 corner: self width @ anItemElement height.
		aeCanvas setBackgroundWith: [ aeCanvas setSourceColor: anInfiniteElement selectionColor ] alpha: 1.0.
		aeCanvas setBorderOff.
		aeCanvas
			setPathKey: self
			hasJoins: true
			hasCaps: false
			block: [ :cairoContext | cairoContext rectangle: rect ].

		aeCanvas drawFigure ]
]
