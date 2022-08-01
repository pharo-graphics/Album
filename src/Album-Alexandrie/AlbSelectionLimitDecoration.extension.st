Extension { #name : #AlbSelectionLimitDecoration }

{ #category : #'*Album-Alexandrie' }
AlbSelectionLimitDecoration >> aeDraw: anItemElement on: aeCanvas in: anInfiniteElement [

	(self shouldDraw: anItemElement in: anInfiniteElement) ifFalse: [ ^ self ].
	aeCanvas restoreContextAfter: [ | w rect |
		w := anItemElement constraints infinite decorationInsets left.
		aeCanvas pathTranslate: w - self width @ anItemElement bounds inParent top.

		rect := self selectionLimitRectangleOf: anItemElement.
		aeCanvas setBackgroundWith: [ aeCanvas setSourceColor: anInfiniteElement selectionColor ] alpha: 0.5.
		aeCanvas setBorderOff.
		aeCanvas
			setPathKey: self
			hasJoins: true
			hasCaps: false
			block: [ :cairoContext | cairoContext rectangle: rect ].

		aeCanvas drawFigure ]
]
