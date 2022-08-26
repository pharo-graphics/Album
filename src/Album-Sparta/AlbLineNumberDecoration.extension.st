Extension { #name : #AlbLineNumberDecoration }

{ #category : #'*Album-Sparta' }
AlbLineNumberDecoration >> draw: anItemElement overOnSpartaCanvas: aCanvas in: anInfiniteElement [

	"Draw any appropriate decorations into the Sparta Canvas supplied to the Infinite Element for its child element anItemElement.
		Any content drawn by this method will be drawn after the item elements are drawn, and will thus appear over them"

	| holder index fontBuilder textPainter font s |
	super draw: anItemElement overOnSpartaCanvas: aCanvas in: anInfiniteElement.
	aCanvas transform
		by: [ :aTransform | 
			aTransform translateBy: self computedBounds left - anInfiniteElement border width @ anItemElement bounds inParent top ]
		during: [ 
			holder := anInfiniteElement childHolderOf: anItemElement.
			index := holder layoutPosition.
			s := index asString.

			fontBuilder := aCanvas font monospace.
			font := fontBuilder build.
			textPainter := aCanvas text
				               string: s;
				               font: font;
				               width: self computedBounds width;
				               baseline: 4 @ fontBuilder size;
				               paint: Color gray darker.
			textPainter draw ]
]

{ #category : #'*Album-Sparta' }
AlbLineNumberDecoration >> drawBackgroundOnSpartaCanvas: aCanvas in: anInfiniteElement [

	aCanvas figure
		path: self computedBounds;
		borderOutside;
		background: (Color veryLightGray alpha: 0.20);
		draw
]

{ #category : #'*Album-Sparta' }
AlbLineNumberDecoration >> drawBeneathOnSpartaCanvas: aCanvas in: anInfiniteElement [

	"Update the actual width and draw the background beneath "

	self measureActualWidthOnSpartaCanvas: aCanvas in: anInfiniteElement.
	self drawBackgroundOnSpartaCanvas: aCanvas in: anInfiniteElement.
	"super sent ensure drawing for item elements"
	super drawBeneathOnSpartaCanvas: aCanvas in: anInfiniteElement
]

{ #category : #'*Album-Sparta' }
AlbLineNumberDecoration >> measureActualWidthOnSpartaCanvas: aCanvas in: anInfiniteElement [

	| fontBuilder font holder s |
	holder := anInfiniteElement childHolderOf: anInfiniteElement children last.
	s := holder layoutPosition asString.
	fontBuilder := aCanvas font monospace size: 12.
	font := fontBuilder build.
	self
		onActualWidthChangeWith: (font averageWidthOf: $0) * s size
		do: [ anInfiniteElement requestLayout ]
]

{ #category : #'*Album-Sparta' }
AlbLineNumberDecoration >> selectionBackgroundDraw: anItemElement onSpartaCanvas: aCanvas in: anInfiniteElement [

	"Draw any appropriate decorations into the Sparta Canvas supplied to the Infinite Element for its child element anItemElement.
		Any content drawn by this method will be drawn after the item elements are drawn, and will thus appear over them"

	self selectionLimitRectangleOf: anItemElement in: anInfiniteElement do: [ :bnds | 
		aCanvas figure
			path: bnds;
			borderOutside;
			background: (self selectionBackgroundColorOf: anItemElement in: anInfiniteElement);
			draw ]
]
