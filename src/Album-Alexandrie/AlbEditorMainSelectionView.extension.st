Extension { #name : #AlbEditorMainSelectionView }

{ #category : #'*Album-Alexandrie' }
AlbEditorMainSelectionView >> aeDrawOn: aeCanvas in: anInfiniteElement [

	super aeDrawOn: aeCanvas in: anInfiniteElement.
	remanentUpdater ifNotNil: [ ^ self ].
	remanents ifEmpty: [ ^ self ].
	aeCanvas restoreContextAfter: [ 
		aeCanvas setBorderOff.
		selectionColor asBlPaint aeApplyTo: aeCanvas opacity: 0.3.
		remanents do: [ :e | 
			e aeApplyTo: aeCanvas element: anInfiniteElement.
			aeCanvas drawFigure ] ]
]
