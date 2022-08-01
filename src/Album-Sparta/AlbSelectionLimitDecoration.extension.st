Extension { #name : #AlbSelectionLimitDecoration }

{ #category : #'*Album-Sparta' }
AlbSelectionLimitDecoration >> draw: anItemElement onSpartaCanvas: aCanvas in: anInfiniteElement [

	self selectionLimitRectangleOf: anItemElement in: anInfiniteElement do: [ :rect | 
		| left |
		left := anItemElement constraints infinite decorationInsets left.
		aCanvas transform
			by: [ :aTransform | aTransform translateBy: left - self width @ anItemElement bounds inParent top ]
			during: [ 
				aCanvas figure
					path: rect;
					borderOutside;
					background: (anInfiniteElement selectionColor alpha: 0.5);
					draw ] ]
]
