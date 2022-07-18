Extension { #name : #AlbTextParagraph }

{ #category : #'*Album-Sparta' }
AlbTextParagraph >> drawExtendedSelectionOnSpartaCanvas: aCanvas padding: aBlInsets [

	self
		drawSelection: self extendedSelection
		onSpartaCanvas: aCanvas
		color: self class extendedSelectionColor
]

{ #category : #'*Album-Sparta' }
AlbTextParagraph >> drawOppositeOnSpartaCanvas: aCanvas [

	| bnds |
	oppositeIndex < 0 ifTrue: [ ^ self ].

	bnds := self characterBoundsAtIndex: oppositeIndex.
	aCanvas transform by: [ :t | t translateBy: self padding topLeft ] during: [ 
		aCanvas fill
			paint: self class oppositeDelimiterBackgroundColor;
			path: bnds;
			draw.
		aCanvas figure
			path: (bnds expandBy: (Margin
							  left: 1
							  right: 1
							  top: 0
							  bottom: 0));
			border: Color black;
			borderAlpha: 1.0;
			width: 1;
			draw ]
]
