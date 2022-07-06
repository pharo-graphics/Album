Class {
	#name : #AlbLineNumberDecoration,
	#superclass : #BlInfiniteItemDecoration,
	#instVars : [
		'metricsProvider',
		'font'
	],
	#category : #'Album-UI'
}

{ #category : #geometry }
AlbLineNumberDecoration >> ascent [
	^ self metricsProvider fontMetrics ascent
]

{ #category : #geometry }
AlbLineNumberDecoration >> computeSize [

	| canvas textPainter |
	metricsProvider ifNotNil: [ ^ self ].
	canvas := Bloc preferableSpartaCanvas offscreen.
	font := canvas font
		        named: 'Source Code Pro';
		        size: 12;
		        build.
	textPainter := canvas text
		               string: '9999999';
		               font: font.
	metricsProvider := textPainter measure
]

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
				        origin: (self width + (self rightGap // 2)) negated @ 0
				        corner: self rightGap negated @ h.
			aCanvas clip by: path during: [ 
				aCanvas figure
					path: path;
					background: AlbCursorSelectionZone selectionColor;
					draw ] ].

	index := holder layoutPosition.
	textPainter := aCanvas text
		               string: index asString;
		               width: self width;
		               font: self font;
		               baseline: self width negated @ self ascent negated;
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
AlbLineNumberDecoration >> font [

	self computeSize.
	^ font
]

{ #category : #geometry }
AlbLineNumberDecoration >> fontHeight [

	^ self metricsProvider fontMetrics height
]

{ #category : #geometry }
AlbLineNumberDecoration >> height [

	^ self metricsProvider textMetrics height
]

{ #category : #initialization }
AlbLineNumberDecoration >> initialize [

	super initialize
]

{ #category : #geometry }
AlbLineNumberDecoration >> itemInsets: aBlInsets of: anItemElement in: anInfiniteElement [

	^ (BlInsets left: self width + 2) + aBlInsets
]

{ #category : #geometry }
AlbLineNumberDecoration >> maxCharacterWidth [

	^ self metricsProvider fontMetrics maxCharacterWidth
]

{ #category : #geometry }
AlbLineNumberDecoration >> metricsProvider [

	metricsProvider ifNil: [ self computeSize ].
	^ metricsProvider
]

{ #category : #geometry }
AlbLineNumberDecoration >> rightGap [

	^ 5
]

{ #category : #geometry }
AlbLineNumberDecoration >> strikeoutOffset [

	^ self metricsProvider fontMetrics strikeoutOffset
]

{ #category : #geometry }
AlbLineNumberDecoration >> totalWidth [

	^ self width + self rightGap
]

{ #category : #geometry }
AlbLineNumberDecoration >> underlineOffset [

	^ self metricsProvider fontMetrics underlineOffset
]

{ #category : #geometry }
AlbLineNumberDecoration >> width [

	^ self metricsProvider textMetrics width
]
