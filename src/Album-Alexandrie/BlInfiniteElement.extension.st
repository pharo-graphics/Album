Extension { #name : #BlInfiniteElement }

{ #category : #'*Album-Alexandrie' }
BlInfiniteElement >> aeDrawChildrenOn: aCanvas [
	" draw then decorate eventually (between the background and the childrens)"
	super aeDrawChildrenOn: aCanvas.
	self itemDecorationsDo: [ :d | 
		d aeDrawOnOver: aCanvas in: self ]
]

{ #category : #'*Album-Alexandrie' }
BlInfiniteElement >> aeDrawOn: aCanvas [
	" draw then decorate eventually (between the background and the childrens)"
	super aeDrawOn: aCanvas.
	self itemDecorationsDo: [ :d | 
		d aeDrawOn: aCanvas in: self ].

]
