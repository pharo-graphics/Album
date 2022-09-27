Extension { #name : #AlbEditorMainSelectionView }

{ #category : #'*Album-Alexandrie' }
AlbEditorMainSelectionView >> aeDrawOn: aeCanvas in: anInfiniteElement [
	super aeDrawOn: aeCanvas in: anInfiniteElement.
	remanentUpdater ifNotNil: [ ^ self ].
	remanents do: [ :e | e aeDrawOn: aeCanvas in: anInfiniteElement ].


]
