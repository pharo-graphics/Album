Class {
	#name : #AlbLineNumberDecoration,
	#superclass : #BlInfiniteDecoration,
	#instVars : [
		'metricsProvider',
		'dirty'
	],
	#category : #'Album-UI'
}

{ #category : #drawing }
AlbLineNumberDecoration >> draw: anItemElement onSpartaCanvasOver: aCanvas in: anInfiniteElement [

	"Draw any appropriate decorations into the Sparta Canvas supplied to the Infinite Element for its child element anItemElement.
		Any content drawn by this method will be drawn after the item elements are drawn, and will thus appear over them"

	| textPainter holder index fontBuilder |
	aCanvas transform
		by: [ :aTransform | aTransform translateBy: 0 @ anItemElement bounds inParent top ]
		during: [ 
			holder := anInfiniteElement childHolderOf: anItemElement.
			(holder hasCursor and: [ anInfiniteElement selection isEmpty ]) ifTrue: [ 
				| h path |
				h := anItemElement height.
				path := Rectangle origin: 0 @ 0 corner: self totalWidth @ h.
				aCanvas clip by: path during: [ 
					aCanvas figure
						path: path;
						background: AlbCursorSelectionZone selectionColor;
						draw ] ].
			index := holder layoutPosition.
			fontBuilder := aCanvas font.
			textPainter := aCanvas text
				               string: index asString;
				               font: fontBuilder build;
				               width: self width;
				               baseline: 2 @ self fontSize + 1;
				               paint: Color black. "(anItemElement height // 2 max: self height // 2) + self underlineOffset"
			textPainter draw ]
]

{ #category : #drawing }
AlbLineNumberDecoration >> drawOnSpartaCanvas: aCanvas in: anInfiniteElement [

	"Draw any appropriate decorations into the Sparta Canvas supplied to the Infinite Element
	Any content drawn by this method will be drawn after the item elements are drawn, and will thus appear underneath them"

	"Draw any appropriate decorations into the Sparta Canvas supplied to the Infinite Element.
		Any content drawn by this method will be drawn after the item elements are drawn, and will thus appear over them"

	| h w |
	h := anInfiniteElement height.
	w := self totalWidth.
	aCanvas figure
		path: (Rectangle origin: 0 @ 0 corner: w @ h);
		background: (Color veryLightGray alpha: 0.20);
		draw.
	super drawOnSpartaCanvas: aCanvas in: anInfiniteElement

]

{ #category : #geometry }
AlbLineNumberDecoration >> fontFromCanvas: aCanvas [


	^ aCanvas font
		  named: 'Arial';
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
AlbLineNumberDecoration >> metricsProvider [

	^ metricsProvider ifNil: [ 
		  | canvas textPainter |
		  canvas := Bloc preferableSpartaCanvas offscreen.
		  canvas
			  ensureFont;
			  build.
		  textPainter := canvas text string: '9999999'.

		  metricsProvider := textPainter measure ]
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

	^ 50 "self metricsProvider textMetrics width"
]
