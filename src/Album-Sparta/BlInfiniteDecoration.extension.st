Extension { #name : #BlInfiniteDecoration }

{ #category : #'*Album-Sparta' }
BlInfiniteDecoration >> draw: anItemElement beneathOnSpartaCanvas: aSpartaCanvas in: anInfiniteElement [

	"Draw any appropriate decorations into the Sparta Canvas supplied to the Infinite Element for its child element anItemElement. Any content drawn by this method will be drawn before the item elements are drawn, and will thus appear underneath them"

	
]

{ #category : #'*Album-Sparta' }
BlInfiniteDecoration >> draw: anItemElement overOnSpartaCanvas: aSpartaCanvas in: anInfiniteElement [

	"Draw any appropriate decorations into the Sparta Canvas supplied to the Infinite Element for its child element anItemElement. Any content drawn by this method will be drawn after the item elements are drawn, and will thus appear over them"

	
]

{ #category : #'*Album-Sparta' }
BlInfiniteDecoration >> drawBeneathOnSpartaCanvas: aSpartaCanvas in: anInfiniteElement [

	"Draw any appropriate decorations into the Sparta Canvas supplied to the Infinite Element. Any content drawn by this method will be drawn before the item elements are drawn, and will thus appear underneath them"

	anInfiniteElement children sortedByElevation do: [ :child | 
		self draw: child beneathOnSpartaCanvas: aSpartaCanvas in: anInfiniteElement ].

]

{ #category : #'*Album-Sparta' }
BlInfiniteDecoration >> drawOverOnSpartaCanvas: aSpartaCanvas in: anInfiniteElement [

	"Draw any appropriate decorations into the Sparta Canvas supplied to the Infinite Element. Any content drawn by this method will be drawn after the item elements are drawn, and will thus appear over them"
	anInfiniteElement children sortedByElevation do: [ :child | 
		self draw: child overOnSpartaCanvas: aSpartaCanvas in: anInfiniteElement ].

]
