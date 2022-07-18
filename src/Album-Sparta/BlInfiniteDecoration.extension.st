Extension { #name : #BlInfiniteDecoration }

{ #category : #'*Album-Sparta' }
BlInfiniteDecoration >> draw: anItemElement onSpartaCanvas: aSpartaCanvas in: anInfiniteElement [

	"Draw any appropriate decorations into the Sparta Canvas supplied to the Infinite Element for its child element anItemElement. Any content drawn by this method will be drawn before the item elements are drawn, and will thus appear underneath them"

	
]

{ #category : #'*Album-Sparta' }
BlInfiniteDecoration >> draw: anItemElement onSpartaCanvasOver: aSpartaCanvas in: anInfiniteElement [

	"Draw any appropriate decorations into the Sparta Canvas supplied to the Infinite Element for its child element anItemElement. Any content drawn by this method will be drawn after the item elements are drawn, and will thus appear over them"

	
]

{ #category : #'*Album-Sparta' }
BlInfiniteDecoration >> drawOnSpartaCanvas: aSpartaCanvas in: anInfiniteElement [

	"Draw any appropriate decorations into the Sparta Canvas supplied to the Infinite Element. Any content drawn by this method will be drawn before the item elements are drawn, and will thus appear underneath them"

	anInfiniteElement children sortedByElevation do: [ :child | 
		self draw: child onSpartaCanvas: aSpartaCanvas in: anInfiniteElement ].

]

{ #category : #'*Album-Sparta' }
BlInfiniteDecoration >> drawOnSpartaCanvasOver: aSpartaCanvas in: anInfiniteElement [

	"Draw any appropriate decorations into the Sparta Canvas supplied to the Infinite Element. Any content drawn by this method will be drawn after the item elements are drawn, and will thus appear over them"
	anInfiniteElement children sortedByElevation do: [ :child | 
		self draw: child onSpartaCanvasOver: aSpartaCanvas in: anInfiniteElement ].

]
