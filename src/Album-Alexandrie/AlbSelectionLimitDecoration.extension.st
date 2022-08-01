Extension { #name : #AlbSelectionLimitDecoration }

{ #category : #'*Album-Alexandrie' }
AlbSelectionLimitDecoration >> aeDraw: anItemElement on: aeCanvas in: anInfiniteElement [

	self selectionLimitRectangleOf: anItemElement in: anInfiniteElement do: [ :rect | 
		aeCanvas restoreContextAfter: [ 
			| w |
			w := anItemElement constraints infinite decorationInsets left.
			aeCanvas pathTranslate: w - self width @ anItemElement bounds inParent top.
			aeCanvas setBackgroundWith: [ aeCanvas setSourceColor: anInfiniteElement selectionColor ] alpha: 0.5.
			aeCanvas setBorderOff.
			aeCanvas
				setPathKey: self
				hasJoins: true
				hasCaps: false
				block: [ :cairoContext | cairoContext rectangle: rect ].

			aeCanvas drawFigure ] ]
]
