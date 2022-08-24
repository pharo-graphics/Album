Extension { #name : #OBlInfiniteElement }

{ #category : #'*Album-Sparta' }
OBlInfiniteElement >> drawChildrenOnSpartaCanvas: aCanvas [
	" draw then decorate eventually (between the background and the childrens)"
	super drawChildrenOnSpartaCanvas: aCanvas.
	self itemDecorationsDo: [ :d | 
		d drawOnSpartaCanvasOver: aCanvas in: self ]
]

{ #category : #'*Album-Sparta' }
OBlInfiniteElement >> drawOnSpartaCanvas: aCanvas [
	" draw then decorate eventually (between the background and the childrens)"
	super drawOnSpartaCanvas: aCanvas.
	self itemDecorationsDo: [ :d | 
		d drawOnSpartaCanvas: aCanvas in: self ].

]
