Extension { #name : #AlbTextElement }

{ #category : #'*Album-Alexandrie' }
AlbTextElement >> aeDrawBeneathOn: aeCanvas [
	super aeDrawBeneathOn: aeCanvas.
	paragraph aeDrawExtendedSelectionOn: aeCanvas.
	paragraph aeDrawOppositeOn: aeCanvas
]
