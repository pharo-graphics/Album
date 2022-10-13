Extension { #name : #AlbSelectionSideDecoration }

{ #category : #'*Album-Alexandrie' }
AlbSelectionSideDecoration >> aeDraw: anItemElement overOn: aeCanvas in: anInfiniteElement [

	anInfiniteElement allowSelection  ifFalse: [ ^ self ].

	aeCanvas restoreContextAfter: [ 
		self selectionLimitRectangleOf: anItemElement in: anInfiniteElement do: [ :rect | 
			aeCanvas pathTranslate: self computedBounds left @ anItemElement bounds inParent top.
			aeCanvas setBackgroundWith: [ 
				aeCanvas setSourceColor: (self selectionBackgroundColorOf: anItemElement in: anInfiniteElement) ].
			aeCanvas setBorderOff.
			aeCanvas drawClosedPathWith: [ :cairoContext | cairoContext rectangle: rect ].
			aeCanvas drawFigure ] ]
]
