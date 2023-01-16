Extension { #name : #AlbInfiniteTextEditorElement }

{ #category : #'*Album-Alexandrie' }
AlbInfiniteTextEditorElement >> aeDrawChildrenOn: aeCanvas [

	self selectionViewDo: [ :selView | 
		"selView aeDrawOn: aeCanvas in: self" ].

	" draw then decorate eventually (between the background and the childrens)"
	super aeDrawChildrenOn: aeCanvas
]
