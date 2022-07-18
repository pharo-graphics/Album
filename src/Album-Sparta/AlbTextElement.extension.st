Extension { #name : #AlbTextElement }

{ #category : #'*Album-Sparta' }
AlbTextElement >> drawBeneathOnSpartaCanvas: aCanvas [
	super drawBeneathOnSpartaCanvas: aCanvas.
	paragraph drawExtendedSelectionOnSpartaCanvas: aCanvas padding: self padding.
	paragraph drawOppositeOnSpartaCanvas: aCanvas
]
