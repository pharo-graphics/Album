Extension { #name : #AlbInfiniteElement }

{ #category : #'*Album-Alexandrie' }
AlbInfiniteElement >> aeDrawChildrenOn: aeCanvas [

	self selectionViewDo: [ :selView | 
		selView aeDrawOn: aeCanvas in: self ].

	" draw then decorate eventually (between the background and the childrens)"
	super aeDrawChildrenOn: aeCanvas
]
