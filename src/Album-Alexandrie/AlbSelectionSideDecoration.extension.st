Extension { #name : #AlbSelectionSideDecoration }

{ #category : #'*Album-Alexandrie' }
AlbSelectionSideDecoration >> aeDraw: anItemElement overOn: aeCanvas in: anInfiniteElement [

	aeCanvas restoreContextAfter: [ 
		| path |
		aeCanvas pathTranslate: self computedBounds left @ anItemElement bounds inParent top.
		aeCanvas setBackgroundWith: [ 
			aeCanvas setSourceColor: (self selectionBackgroundColorOf: anItemElement in: anInfiniteElement) ].
		aeCanvas setBorderOff.
		self selectionLimitRectangleOf: anItemElement in: anInfiniteElement do: [ :rect | path := rect ].
		path ifNil: [ self cursorLimitRectangleOf: anItemElement in: anInfiniteElement do: [ :rect | path := rect ] ].
		path ifNotNil: [ 
			aeCanvas drawClosedPathWith: [ :cairoContext | cairoContext rectangle: path ].
			aeCanvas drawFigure ] ]
]
