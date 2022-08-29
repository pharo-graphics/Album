Extension { #name : #OBlInfiniteElement }

{ #category : #'*Album-Alexandrie' }
OBlInfiniteElement >> aeDrawChildrenOn: aCanvas [
	" draw then decorate eventually (between the background and the childrens)"
	super aeDrawChildrenOn: aCanvas.
	self itemDecorationsDo: [ :d | 
		d aeDrawOverOn: aCanvas in: self ]
]

{ #category : #'*Album-Alexandrie' }
OBlInfiniteElement >> aeDrawOn: aCanvas [
	" draw then decorate eventually (between the background and the childrens)"
	super aeDrawOn: aCanvas.
	self itemDecorationsDo: [ :d | 
		d aeDrawBeneathOn: aCanvas in: self ].


]
