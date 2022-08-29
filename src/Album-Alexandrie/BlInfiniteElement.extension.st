Extension { #name : #BlInfiniteElement }

{ #category : #'*Album-Alexandrie' }
BlInfiniteElement >> aeDrawChildrenOn: aCanvas [
	" draw then decorate eventually (between the background and the childrens)"
	super aeDrawChildrenOn: aCanvas.
	self itemDecorationsDo: [ :d | 
		d aeDrawOverOn: aCanvas in: self ]
]

{ #category : #'*Album-Alexandrie' }
BlInfiniteElement >> aeDrawOn: aCanvas [
	" decorate beneath eventually"
	super aeDrawOn: aCanvas.
	self itemDecorationsDo: [ :d | 
		d aeDrawBeneathOn: aCanvas in: self ].


]
