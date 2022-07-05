Class {
	#name : #AlbLineNumberDecoration,
	#superclass : #BlInfiniteItemDecoration,
	#instVars : [
		'width',
		'height',
		'ascent',
		'strikeoutOffset',
		'underlineOffset'
	],
	#category : #'Album-UI'
}

{ #category : #geometry }
AlbLineNumberDecoration >> ascent [

	^ ascent ifNil: [ 
		  self computeSize.
		  ascent ]
]

{ #category : #geometry }
AlbLineNumberDecoration >> computeSize [

	| canvas font textPainter metricsProvider |
	canvas := Bloc preferableSpartaCanvas offscreen.
	font := canvas font
		        named: 'Arial';
		        size: 10;
		        build.

	textPainter := canvas text
		               string: '99999';
		               font: font.
	metricsProvider := textPainter measure.
	width := metricsProvider textMetrics width + 2.
	height :=  metricsProvider textMetrics height.
	ascent := metricsProvider fontMetrics ascent.
	strikeoutOffset := metricsProvider fontMetrics strikeoutOffset.
	underlineOffset := metricsProvider fontMetrics underlineOffset.
]

{ #category : #drawing }
AlbLineNumberDecoration >> draw: anItemElement onSpartaCanvas: aCanvas in: anInfiniteElement [

	"Draw any appropriate decorations into the Sparta Canvas supplied to the Infinite Element.
	Any content drawn by this method will be drawn after the item elements are drawn, and will thus appear over them"


]

{ #category : #drawing }
AlbLineNumberDecoration >> draw: anItemElement onSpartaCanvasOver: aCanvas in: anInfiniteElement [

	"Draw any appropriate decorations into the Sparta Canvas supplied to the Infinite Element.
	Any content drawn by this method will be drawn after the item elements are drawn, and will thus appear over them"

	| textPainter holder index font |
	holder := anInfiniteElement childHolderOf: anItemElement.
	(holder hasCursor and: [ anInfiniteElement selection isEmpty ]) ifTrue: [ 
		| h path |
		h := anItemElement height.
		path := Rectangle
			        origin: self width negated + anInfiniteElement padding left negated @ 0
			        corner: 2 negated @ h.
		aCanvas clip
			by: path
			during: [ 
				aCanvas figure
					path: path;
					background: AlbCursorSelectionZone selectionColor;
					"backgroundAlpha: 0.30;"
					draw ] ].

	index := holder layoutPosition.
	font := aCanvas font
		        named: 'Source Code Pro';
		        size: 10;
		        build.
	textPainter := aCanvas text
		               string: index asString;
		               width: self width;
		               font: font;
		               baseline: self width negated @ (anItemElement height // 2 max: self height);
		               paint: Color black.
	textPainter draw
]

{ #category : #geometry }
AlbLineNumberDecoration >> height [

	^ height ifNil: [ 
		  self computeSize.
		  height ]
]

{ #category : #initialization }
AlbLineNumberDecoration >> initialize [
	super initialize.

]

{ #category : #geometry }
AlbLineNumberDecoration >> itemInsets: aBlInsets of: anItemElement in: anInfiniteElement [

	^ (BlInsets left: self width + 2) + aBlInsets
]

{ #category : #geometry }
AlbLineNumberDecoration >> strikeoutOffset [

	^ strikeoutOffset ifNil: [ 
		  self computeSize.
		  strikeoutOffset ]
]

{ #category : #geometry }
AlbLineNumberDecoration >> underlineOffset [

	^ underlineOffset ifNil: [ 
		  self computeSize.
		  underlineOffset ]
]

{ #category : #geometry }
AlbLineNumberDecoration >> width [

	^ width ifNil: [ 
		  self computeSize.
		  width ]
]
