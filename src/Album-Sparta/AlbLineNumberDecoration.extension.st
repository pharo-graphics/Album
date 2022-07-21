Extension { #name : #AlbLineNumberDecoration }

{ #category : #'*Album-Sparta' }
AlbLineNumberDecoration >> cursorBackgroundDraw: anItemElement onSpartaCanvas: aCanvas in: anInfiniteElement [

	"Draw any appropriate decorations into the Sparta Canvas supplied to the Infinite Element for its child element anItemElement.
		Any content drawn by this method will be drawn after the item elements are drawn, and will thus appear over them"

	| path |
	path := self cursorBackgroundRectangleOf: anItemElement in: anInfiniteElement.
	aCanvas figure
		path: path;
		borderOutside;
		background: anInfiniteElement selectionColor;
		draw
]

{ #category : #'*Album-Sparta' }
AlbLineNumberDecoration >> draw: anItemElement onSpartaCanvas: aCanvas in: anInfiniteElement [

	"Draw any appropriate decorations into the Sparta Canvas supplied to the Infinite Element for its child element anItemElement.
		Any content drawn by this method will be drawn after the item elements are drawn, and will thus appear over them"

	| holder index fontBuilder textPainter w font s |
	w := anInfiniteElement layout leftDecorationWidth: anItemElement.
	aCanvas transform
		by: [ :aTransform | aTransform translateBy: anInfiniteElement border width @ anItemElement bounds inParent top ]
		during: [ 
			holder := anInfiniteElement childHolderOf: anItemElement.
			(holder hasCursor and: [ anInfiniteElement selection isEmpty ]) ifTrue: [ 
				self cursorBackgroundDraw: anItemElement onSpartaCanvas: aCanvas in: anInfiniteElement ].

			index := holder layoutPosition.
			s := index asString.

			fontBuilder := aCanvas font monospace.
			font := fontBuilder build.
			textPainter := aCanvas text
				               string: s;
				               font: font;
				               width: w;
				               baseline: 4 @ fontBuilder size;
				               paint: Color black.
			textPainter draw ]
]

{ #category : #'*Album-Sparta' }
AlbLineNumberDecoration >> drawBackgroundOnSpartaCanvas: aCanvas in: anInfiniteElement [

	aCanvas figure
		path: (self backgroundRectangleIn: anInfiniteElement);
		borderOutside;
		background: (Color veryLightGray alpha: 0.20);
		draw
]

{ #category : #'*Album-Sparta' }
AlbLineNumberDecoration >> drawOnSpartaCanvas: aCanvas in: anInfiniteElement [

	"Update the actual width and draw the background beneath "

	self measureActualWidthOnSpartaCanvas: aCanvas in: anInfiniteElement.
	self drawBackgroundOnSpartaCanvas: aCanvas in: anInfiniteElement.
	"super sent ensure drawing for item elements"
	super drawOnSpartaCanvas: aCanvas in: anInfiniteElement
]

{ #category : #'*Album-Sparta' }
AlbLineNumberDecoration >> measureActualWidthOnSpartaCanvas: aCanvas in: anInfiniteElement [

	| fontBuilder font holder s |
	holder := anInfiniteElement childHolderOf: anInfiniteElement children last.
	s := holder layoutPosition asString.
	fontBuilder := aCanvas font monospace.
	font := fontBuilder build.
	self
		onActualWidthChangeWith: (font averageWidthOf: $0) * s size
		do: [ anInfiniteElement requestLayout ]
]
