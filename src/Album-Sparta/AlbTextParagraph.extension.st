Extension { #name : #AlbTextParagraph }

{ #category : #'*Album-Sparta' }
AlbTextParagraph >> drawExtendedSelectionOnSpartaCanvas: aCanvas padding: aBlInsets [

	self
		drawselection: self extendedSelection
		onSpartaCanvas: aCanvas
		padding: aBlInsets
		color: self class extendedSelectionColor
]
