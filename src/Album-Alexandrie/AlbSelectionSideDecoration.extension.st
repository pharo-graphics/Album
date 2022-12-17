Extension { #name : #AlbSelectionSideDecoration }

{ #category : #'*Album-Alexandrie' }
AlbSelectionSideDecoration >> aeDraw: anItemElement overOn: aeCanvas in: anInfiniteElement [

	aeCanvas restoreContextAfter: [ 
		self selectionLimitRectangleOf: anItemElement in: anInfiniteElement do: [ :rect | 
			aeCanvas pathTranslate: 0 @ anItemElement bounds inParent top.
			aeCanvas pathFactory: [ :cairoContext | cairoContext rectangle: rect ].
			aeCanvas setBackgroundWith: [ 
				aeCanvas setSourceColor: (self selectionBackgroundColorOf: anItemElement in: anInfiniteElement) ].
			aeCanvas setBorderOff.
			aeCanvas drawFigure ] ]
]
