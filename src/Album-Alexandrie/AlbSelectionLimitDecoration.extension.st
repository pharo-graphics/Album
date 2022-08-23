Extension { #name : #AlbSelectionLimitDecoration }

{ #category : #'*Album-Alexandrie' }
AlbSelectionLimitDecoration >> aeDraw: anItemElement onOver: aeCanvas in: anInfiniteElement [

	self selectionLimitRectangleOf: anItemElement in: anInfiniteElement do: [ :rect | 
		aeCanvas restoreContextAfter: [ 
			aeCanvas pathTranslate: self computedBounds left @ anItemElement bounds inParent top.
			aeCanvas
				setBackgroundWith: [ aeCanvas setSourceColor: anInfiniteElement selectionColor ]
				alpha: 0.5.
			aeCanvas setBorderOff.
			aeCanvas drawClosedPathWith: [ :cairoContext | cairoContext rectangle: rect ].

			aeCanvas drawFigure ] ]
]
