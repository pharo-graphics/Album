Extension { #name : #AlbLineNumberDecoration }

{ #category : #'*Album-Alexandrie' }
AlbLineNumberDecoration >> aeCairoScaledFontOn: aeCanvas [

	| fontAndStyleBuilder freeTypeFont |
	fontAndStyleBuilder := BlTextFontAndStyleBuilder new.
	freeTypeFont := fontAndStyleBuilder font asLogicalFont asFreetypeFont.
	^ aeCanvas scaledFontFor: freeTypeFont
]

{ #category : #'*Album-Alexandrie' }
AlbLineNumberDecoration >> aeCursorBackgroundDraw: anItemElement on: aeCanvas in: anInfiniteElement [

	| path |
	path := self cursorBackgroundRectangleOf: anItemElement in: anInfiniteElement.
	aeCanvas
		setBackgroundWith: [ aeCanvas setSourceColor: anInfiniteElement selectionColor ]
		alpha: 1.0.
	aeCanvas setBorderOff.
	aeCanvas
		setPathKey: self
		hasJoins: true
		hasCaps: false
		block: [ :cairoContext | cairoContext rectangle: path ].

	aeCanvas drawFigure
]

{ #category : #'*Album-Alexandrie' }
AlbLineNumberDecoration >> aeDraw: anItemElement on: aeCanvas in: anInfiniteElement [

	| holder index s cairoScaledFont cairoGlyphsArray fontExtents |
	aeCanvas restoreContextAfter: [ 
		aeCanvas pathTranslate: anInfiniteElement border width @ anItemElement bounds inParent top.

		"Hihglight the selection if the element holds it"
		holder := anInfiniteElement childHolderOf: anItemElement.
		(holder hasCursor and: [ anInfiniteElement selection isEmpty ]) ifTrue: [ 
			self aeCursorBackgroundDraw: anItemElement on: aeCanvas in: anInfiniteElement ].

		index := holder layoutPosition.
		s := index asString utf8Encoded.

		cairoScaledFont := self aeCairoScaledFontOn: aeCanvas.
		fontExtents := cairoScaledFont extents.
		aeCanvas pathTranslate: 4 @ fontExtents ascent.
		aeCanvas setSourceColor: Color black.
		cairoGlyphsArray := cairoScaledFont glyphArrayFor: s length: s size.
		aeCanvas drawText: cairoGlyphsArray font: cairoScaledFont ]
]

{ #category : #'*Album-Alexandrie' }
AlbLineNumberDecoration >> aeDrawBackgroundOn: aeCanvas in: anInfiniteElement [

	"draw the background beneath "

	aeCanvas setBackgroundWith: [ aeCanvas setSourceColor: Color veryLightGray ] alpha: 0.20.
	aeCanvas setBorderOff.
	aeCanvas
		setPathKey: self
		hasJoins: true
		hasCaps: false
		block: [ :cairoContext | 
			cairoContext rectangle: (self backgroundRectangleIn: anInfiniteElement) ].
	aeCanvas drawFigure
]

{ #category : #'*Album-Alexandrie' }
AlbLineNumberDecoration >> aeDrawOn: aeCanvas in: anInfiniteElement [

	"Update the actual width and draw the background beneath "

	aeCanvas restoreContextAfter: [ 
		self aeMeasureActualWidthOn: aeCanvas in: anInfiniteElement.
		self aeDrawBackgroundOn: aeCanvas in: anInfiniteElement ].
	"super sent ensure drawing for item elements"
	super aeDrawOn: aeCanvas in: anInfiniteElement
]

{ #category : #'*Album-Alexandrie' }
AlbLineNumberDecoration >> aeMeasureActualWidthOn: aeCanvas in: anInfiniteElement [

	"Draw the background beneath "

	| holder cairoScaledFont fontExtents cairoGlyphsArray s |
	holder := anInfiniteElement childHolderOf: anInfiniteElement children last.
	s := holder layoutPosition asString.
	cairoScaledFont := self aeCairoScaledFontOn: aeCanvas.
	fontExtents := cairoScaledFont extents.
	cairoGlyphsArray := cairoScaledFont glyphArrayFor: s length: s size.
	aeCanvas textExtentsFor: cairoGlyphsArray scaledFont: cairoScaledFont do: [ :aTextExtents | 
		self onActualWidthChangeWith: aTextExtents width do: [ anInfiniteElement requestLayout ] ]
]
