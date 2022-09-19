Extension { #name : #AlbEditorElement }

{ #category : #'*Album-Alexandrie' }
AlbEditorElement >> aeDrawChildrenOn: aeCanvas [
	selectionView aeDrawBeneathOn: aeCanvas in: self.
	" draw then decorate eventually (between the background and the childrens)"
	super aeDrawChildrenOn: aeCanvas
]
