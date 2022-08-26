Extension { #name : #AlbLineNumberDecoration }

{ #category : #'*Album-Alexandrie' }
AlbLineNumberDecoration >> aeCairoScaledFontOn: aeCanvas [

	| fontAndStyleBuilder freeTypeFont |
	fontAndStyleBuilder := BlTextFontAndStyleBuilder new.
	freeTypeFont := fontAndStyleBuilder font asAeFTFace.
	^ aeCanvas scaledFontForFace: freeTypeFont size: 12
]

{ #category : #'*Album-Alexandrie' }
AlbLineNumberDecoration >> aeDraw: anItemElement overOn: aeCanvas in: anInfiniteElement [

	| holder index s cairoScaledFont cairoGlyphsArray fontExtents |
	super aeDraw: anItemElement overOn: aeCanvas in: anInfiniteElement.
	aeCanvas restoreContextAfter: [ 
		aeCanvas pathTranslate:
			self computedBounds left - anInfiniteElement border width @ anItemElement bounds inParent top.
		holder := anInfiniteElement childHolderOf: anItemElement.
		index := holder layoutPosition.
		s := index asString utf8Encoded.

		cairoScaledFont := self aeCairoScaledFontOn: aeCanvas.
		fontExtents := cairoScaledFont extents.
		aeCanvas pathTranslate: 4 @ fontExtents ascent.
		aeCanvas setSourceColor: Color gray darker.
		cairoGlyphsArray := cairoScaledFont glyphArrayFor: s length: s size.
		aeCanvas drawText: cairoGlyphsArray font: cairoScaledFont ]
]

{ #category : #'*Album-Alexandrie' }
AlbLineNumberDecoration >> aeDrawBackgroundOn: aeCanvas in: anInfiniteElement [

	"draw the background beneath "

	aeCanvas
		setBackgroundWith: [ aeCanvas setSourceColor: Color veryLightGray ]
		alpha: 0.10.
	aeCanvas setBorderOff.
	aeCanvas drawClosedPathWith: [ :cairoContext | 
		cairoContext rectangle: self computedBounds ].
	aeCanvas drawFigure
]

{ #category : #'*Album-Alexandrie' }
AlbLineNumberDecoration >> aeDrawBeneathOn: aeCanvas in: anInfiniteElement [

	"Update the actual width and draw the background beneath "

	self aeMeasureActualWidthOn: aeCanvas in: anInfiniteElement.
	aeCanvas restoreContextAfter: [ self aeDrawBackgroundOn: aeCanvas in: anInfiniteElement ].
	"super sent ensure drawing for item elements"
	super aeDrawBeneathOn: aeCanvas in: anInfiniteElement
]

{ #category : #'*Album-Alexandrie' }
AlbLineNumberDecoration >> aeMeasureActualWidthOn: aeCanvas in: anInfiniteElement [

	"Draw the background beneath "

	| holder cairoScaledFont fontExtents cairoGlyphsArray s |
	anInfiniteElement hasChildren ifFalse: [ ^self ].
	holder := anInfiniteElement childHolderOf: anInfiniteElement children last.
	s := holder layoutPosition asString.
	cairoScaledFont := self aeCairoScaledFontOn: aeCanvas.
	fontExtents := cairoScaledFont extents.
	cairoGlyphsArray := cairoScaledFont glyphArrayFor: s length: s size.
	aeCanvas textExtentsFor: cairoGlyphsArray scaledFont: cairoScaledFont do: [ :aTextExtents | 
		self onActualWidthChangeWith: aTextExtents width do: [ anInfiniteElement requestLayout ] ]
]
