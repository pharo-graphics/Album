Extension { #name : #AlbSelectionLimitDecoration }

{ #category : #'*Album-Sparta' }
AlbSelectionLimitDecoration >> draw: anItemElement onSpartaCanvas: aCanvas in: anInfiniteElement [

	| w |
	(self shouldDraw: anItemElement in: anInfiniteElement) ifFalse: [ ^ self ].
	w := anItemElement constraints infinite decorationInsets left.
	aCanvas transform
		by: [ :aTransform | aTransform translateBy: w - self width @ anItemElement bounds inParent top ]
		during: [ 
			| rect |
			rect := self selectionLimitRectangleOf: anItemElement .
			aCanvas figure
				path: rect;
				borderOutside;
				background: (anInfiniteElement selectionColor alpha: 0.5);
				draw ]
]
