Extension { #name : #AlbSelectionLimitDecoration }

{ #category : #'*Album-Sparta' }
AlbSelectionLimitDecoration >> draw: anItemElement onSpartaCanvasOver: aCanvas in: anInfiniteElement [

	self selectionLimitRectangleOf: anItemElement in: anInfiniteElement do: [ :rect | 
		aCanvas transform
			by: [ :aTransform | aTransform translateBy: self computedBounds left @ anItemElement bounds inParent top ]
			during: [ 
				aCanvas figure
					path: rect;
					borderOutside;
					background: (anInfiniteElement selectionColor alpha: 0.5);
					draw ] ]
]
