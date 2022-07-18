Extension { #name : #BlInfiniteDecoration }

{ #category : #'*Album-Alexandrie' }
BlInfiniteDecoration >> aeDraw: anItemElement on: aCanvas in: anInfiniteElement [

	"Draw any appropriate decorations into the Sparta Canvas supplied to the Infinite Element for its child element anItemElement. Any content drawn by this method will be drawn before the item elements are drawn, and will thus appear underneath them"

	
]

{ #category : #'*Album-Alexandrie' }
BlInfiniteDecoration >> aeDraw: anItemElement onOver: aSpartaCanvas in: anInfiniteElement [

	"Draw any appropriate decorations into the Sparta Canvas supplied to the Infinite Element for its child element anItemElement. Any content drawn by this method will be drawn after the item elements are drawn, and will thus appear over them"

	
]

{ #category : #'*Album-Alexandrie' }
BlInfiniteDecoration >> aeDrawOn: aCanvas in: anInfiniteElement [

	"Draw any appropriate decorations into the Sparta Canvas supplied to the Infinite Element. Any content drawn by this method will be drawn before the item elements are drawn, and will thus appear underneath them"

	anInfiniteElement children sortedByElevation do: [ :child | 
		self aeDraw: child on: aCanvas in: anInfiniteElement ].

]

{ #category : #'*Album-Alexandrie' }
BlInfiniteDecoration >> aeDrawOnOver: aCanvas in: anInfiniteElement [

	"Draw any appropriate decorations into the Sparta Canvas supplied to the Infinite Element. Any content drawn by this method will be drawn after the item elements are drawn, and will thus appear over them"
	anInfiniteElement children sortedByElevation do: [ :child | 
		self aeDraw: child onOver: aCanvas in: anInfiniteElement ].

]
