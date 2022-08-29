Extension { #name : #AlbSelectionSideDecoration }

{ #category : #'*Album-Sparta' }
AlbSelectionSideDecoration >> draw: anItemElement overOnSpartaCanvas: aCanvas in: anInfiniteElement [

	aCanvas transform
		by: [ :aTransform | aTransform translateBy: self computedBounds left @ anItemElement bounds inParent top ]
		during: [ 
			self selectionLimitRectangleOf: anItemElement in: anInfiniteElement do: [ :rect | 
				aCanvas figure
					path: rect;
					borderOutside;
					background: (self selectionBackgroundColorOf: anItemElement in: anInfiniteElement);
					draw ] ]
]
