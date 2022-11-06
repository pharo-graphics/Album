Extension { #name : #AlbEditorElement }

{ #category : #'*Album-Alexandrie' }
AlbEditorElement >> aeDrawChildrenOn: aeCanvas [

	self selectionViewDo: [ :selView | 
		selView aeDrawOn: aeCanvas in: self ].

	" draw then decorate eventually (between the background and the childrens)"
	super aeDrawChildrenOn: aeCanvas
]
