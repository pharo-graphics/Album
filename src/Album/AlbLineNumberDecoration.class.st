Class {
	#name : #AlbLineNumberDecoration,
	#superclass : #BlInfiniteItemDecoration,
	#category : #'Album-UI'
}

{ #category : #drawing }
AlbLineNumberDecoration >> draw: anItemElement onSpartaCanvas: aCanvas in: anInfiniteElement [

	"Draw any appropriate decorations into the Sparta Canvas supplied to the Infinite Element for its child element anItemElement. Any content drawn by this method will be drawn before the item elements are drawn, and will thus appear underneath them"

	
]

{ #category : #drawing }
AlbLineNumberDecoration >> draw: anItemElement onSpartaCanvasOver: aCanvas in: anInfiniteElement [

	"Draw any appropriate decorations into the Sparta Canvas supplied to the Infinite Element for its child element anItemElement.
		Any content drawn by this method will be drawn after the item elements are drawn, and will thus appear over them"

	| textPainter holder index |
	holder := anInfiniteElement childHolderOf: anItemElement.
	(holder hasCursor and: [ anInfiniteElement selection isEmpty ]) 
		ifTrue: [ 
			| h path |
			h := anItemElement height.
			path := Rectangle
				        origin: (self totalWidth) negated @ 0
				        corner: (self rightGap + 3) negated @ h.
			aCanvas clip by: path during: [ 
				aCanvas figure
					path: path;
					background: AlbCursorSelectionZone selectionColor;
					draw ] ].

	index := holder layoutPosition.
	textPainter := aCanvas text
		               string: index asString;
		               width: self width;
		               font: (self fontFromCanvas: aCanvas);
		               baseline: self width negated @ ((self fontSize) );
		               paint: Color black. "(anItemElement height // 2 max: self height // 2) + self underlineOffset"
	textPainter draw
]

{ #category : #drawing }
AlbLineNumberDecoration >> drawOnSpartaCanvas: aCanvas in: anInfiniteElement [

	"Draw any appropriate decorations into the Sparta Canvas supplied to the Infinite Element
	Any content drawn by this method will be drawn after the item elements are drawn, and will thus appear underneath them"


]

{ #category : #drawing }
AlbLineNumberDecoration >> drawOnSpartaCanvasOver: aCanvas in: anInfiniteElement [

	"Draw any appropriate decorations into the Sparta Canvas supplied to the Infinite Element.
		Any content drawn by this method will be drawn after the item elements are drawn, and will thus appear over them"

	| h w |
	h := anInfiniteElement height.
	w := self width - (self rightGap // 2).
	aCanvas figure
		path: (Rectangle encompassing: { 
						 (0 @ 0).
						 (w @ h) });
		background: (Color veryLightGray alpha: 0.10);
		draw.

	anInfiniteElement childrenDo: [ :child | 
		self draw: child onSpartaCanvasOver: aCanvas in: anInfiniteElement ]
]

{ #category : #geometry }
AlbLineNumberDecoration >> fontFromCanvas: aCanvas [


	^ aCanvas font
"		  named: 'Source Code Pro';"
		  size: self fontSize;
		  build
]

{ #category : #geometry }
AlbLineNumberDecoration >> fontSize [
	^ 12
]

{ #category : #geometry }
AlbLineNumberDecoration >> itemInsets: aBlInsets of: anItemElement in: anInfiniteElement [

	^ (BlInsets left: self totalWidth) + aBlInsets
]

{ #category : #geometry }
AlbLineNumberDecoration >> rightGap [

	^ 5
]

{ #category : #geometry }
AlbLineNumberDecoration >> totalWidth [

	^ self width + self rightGap
]

{ #category : #geometry }
AlbLineNumberDecoration >> width [

	^ 40
]
