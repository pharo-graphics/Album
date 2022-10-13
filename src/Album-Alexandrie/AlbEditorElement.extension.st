Extension { #name : #AlbEditorElement }

{ #category : #'*Album-Alexandrie' }
AlbEditorElement >> aeDrawChildrenOn: aeCanvas [

	self allowSelection ifTrue: [
		selectionView aeDrawOn: aeCanvas in: self.

		self flag: #todo.
		"Workaround: selectionView may change the clipping area, we restore it for text segments, which are my children."
		self geometry aeApplyTo: aeCanvas element: self.
		aeCanvas prepareToDrawChildrenWithClipping: self clipChildren ].

	" draw then decorate eventually (between the background and the childrens)"
	super aeDrawChildrenOn: aeCanvas
]
