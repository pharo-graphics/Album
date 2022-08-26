Extension { #name : #AlbSelectionSideDecoration }

{ #category : #'*Album-Sparta' }
AlbSelectionSideDecoration >> draw: anItemElement overOnSpartaCanvas: aCanvas in: anInfiniteElement [

	aCanvas transform
		by: [ :aTransform | aTransform translateBy: self computedBounds left @ anItemElement bounds inParent top ]
		during: [ 
			| path |
			self selectionLimitRectangleOf: anItemElement in: anInfiniteElement do: [ :rect | path := rect ].
			path ifNil: [ 
				self cursorLimitRectangleOf: anItemElement in: anInfiniteElement do: [ :rect | path := rect ] ].
			path ifNil: [ ^ self ].
			aCanvas figure
				path: path;
				borderOutside;
				background: (self selectionBackgroundColorOf: anItemElement in: anInfiniteElement);
				draw ]
]
