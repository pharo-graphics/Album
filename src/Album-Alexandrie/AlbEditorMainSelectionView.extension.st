Extension { #name : #AlbEditorMainSelectionView }

{ #category : #'*Album-Alexandrie' }
AlbEditorMainSelectionView >> aeDrawOn: aeCanvas in: anInfiniteElement [
	super aeDrawOn: aeCanvas in: anInfiniteElement.
	echoUpdater ifNotNil: [ ^ self ].
	echo do: [ :e | e aeDrawOn: aeCanvas in: anInfiniteElement ]
]
