Extension { #name : #BlInfiniteElement }

{ #category : #'*Album-Sparta' }
BlInfiniteElement >> aeDrawChildrenOn: aCanvas [
	" draw then decorate eventually (between the background and the childrens)"
	super aeDrawChildrenOn: aCanvas.
	self itemDecorationsDo: [ :d | 
		d aeDrawOnOver: aCanvas in: self ]
]

{ #category : #'*Album-Sparta' }
BlInfiniteElement >> aeDrawOn: aCanvas [
	" draw then decorate eventually (between the background and the childrens)"
	super aeDrawOn: aCanvas.
	self itemDecorationsDo: [ :d | 
		d aeDrawOn: aCanvas in: self ].

]

{ #category : #'*Album-Sparta' }
BlInfiniteElement >> drawChildrenOnSpartaCanvas: aCanvas [
	" draw then decorate eventually (between the background and the childrens)"
	super drawChildrenOnSpartaCanvas: aCanvas.
	self itemDecorationsDo: [ :d | 
		d drawOnSpartaCanvasOver: aCanvas in: self ]
]

{ #category : #'*Album-Sparta' }
BlInfiniteElement >> drawOnSpartaCanvas: aCanvas [
	" draw then decorate eventually (between the background and the childrens)"
	super drawOnSpartaCanvas: aCanvas.
	self itemDecorationsDo: [ :d | 
		d drawOnSpartaCanvas: aCanvas in: self ].

]
