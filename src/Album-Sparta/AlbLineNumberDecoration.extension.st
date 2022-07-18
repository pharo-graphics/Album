Extension { #name : #AlbLineNumberDecoration }

{ #category : #'*Album-Sparta' }
AlbLineNumberDecoration >> draw: anItemElement onSpartaCanvas: aCanvas in: anInfiniteElement [

	"Draw any appropriate decorations into the Sparta Canvas supplied to the Infinite Element for its child element anItemElement.
		Any content drawn by this method will be drawn after the item elements are drawn, and will thus appear over them"

	| holder index fontBuilder textPainter w font |
	w := anInfiniteElement layout leftDecorationWidth: anItemElement.
	aCanvas transform
		by: [ :aTransform | 
			aTransform translateBy: 0 @ anItemElement bounds inParent top ]
		during: [ 
			aCanvas figure
				path: (Rectangle origin: 0 @ 0 corner: w @ anItemElement height);
				background: (Color veryLightGray alpha: 0.20);
				draw.
			holder := anInfiniteElement childHolderOf: anItemElement.
			(holder hasCursor and: [ anInfiniteElement selection isEmpty ]) 
				ifTrue: [ 
					| h path |
					h := anItemElement height.
					path := Rectangle origin: 0 @ 0 corner: w @ h.
					aCanvas clip by: path during: [ 
						aCanvas figure
							path: path;
							background: anInfiniteElement selectionColor;
							draw ] ].
			index := holder layoutPosition.
			fontBuilder := aCanvas font monospace.
			font := fontBuilder build.
			textPainter := aCanvas text
				               string: index asString;
				               font: font;
				               width: w;
				               baseline: (anInfiniteElement border width + 4) @ fontBuilder size;
				               paint: Color black.
			textPainter draw ]
]
