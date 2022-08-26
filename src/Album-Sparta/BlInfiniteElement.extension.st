Extension { #name : #BlInfiniteElement }

{ #category : #'*Album-Sparta' }
BlInfiniteElement >> drawChildrenOnSpartaCanvas: aCanvas [
	" draw then decorate eventually (between the background and the childrens)"
	super drawChildrenOnSpartaCanvas: aCanvas.
	self itemDecorationsDo: [ :d | 
		d drawOverOnSpartaCanvas: aCanvas in: self ]
]

{ #category : #'*Album-Sparta' }
BlInfiniteElement >> drawOnSpartaCanvas: aCanvas [
	" draw then decorate eventually (between the background and the childrens)"
	super drawOnSpartaCanvas: aCanvas.
	self itemDecorationsDo: [ :d | 
		d drawBeneathOnSpartaCanvas: aCanvas in: self ].

]
