Extension { #name : #AlbRowNumberDecoration }

{ #category : #'*Album-Alexandrie' }
AlbRowNumberDecoration >> aeDraw: anItemElement overOn: aeCanvas in: anInfiniteElement [

	super aeDraw: anItemElement overOn: aeCanvas in: anInfiniteElement.
	anInfiniteElement mode ifWithPrimarySelectionDo: [
		aeCanvas restoreContextAfter: [
			self
				selectionLimitRectangleOf: anItemElement
				in: anInfiniteElement
				do: [ :rect |
					aeCanvas pathTranslate: 0 @ anItemElement bounds inParent top.
					aeCanvas pathFactory: [ :cairoContext |
						cairoContext rectangle: rect ].
					aeCanvas setBackgroundWith: [
						aeCanvas setSourceColor:
							(self
								 selectionBackgroundOf: anItemElement
								 in: anInfiniteElement) ].
					aeCanvas setBorderOff.
					aeCanvas drawFigure ] ] ]
]
