Extension { #name : #AlbTextElement }

{ #category : #'*Album-Sparta' }
AlbTextElement >> drawOnSpartaCanvas: aCanvas [

	paragraph ifNil: [ ^ self ].
	paragraph containerExtent: self extent.
	paragraph selection: self selection.
	paragraph extendedSelection: self extendedSelection.
	aCanvas clip
		by: (self geometry pathOnSpartaCanvas: aCanvas of: self)
		during: [ 
			paragraph
				drawHighlightsOnSpartaCanvas: aCanvas
				padding: self padding.
			paragraph
				drawExtendedSelectionOnSpartaCanvas: aCanvas
				padding: self padding.
			paragraph 
				drawSelectionOnSpartaCanvas: aCanvas
				padding: self padding.

			aCanvas transform
				by: [ :t | t translateBy: self padding topLeft ]
				during: [ 
					self drawOppositeOnSpartaCanvas: aCanvas.
					paragraph drawOn: aCanvas ] ]
]

{ #category : #'*Album-Sparta' }
AlbTextElement >> drawOppositeOnSpartaCanvas: aCanvas [

	| bnds |
	oppositeIndex < 0 ifTrue: [ ^ self ].
	bnds := self characterBoundsAtIndex: oppositeIndex.
	aCanvas fill
			paint: (self class oppositeDelimiterBackgroundColor);
			path: bnds;
			draw. 
	aCanvas figure
		path:
			(bnds expandBy: (Margin
						  left: 1
						  right: 1
						  top: 0
						  bottom: 0));
		border: Color black;
		borderAlpha: 1.0;
		width: 1;
		draw
]
