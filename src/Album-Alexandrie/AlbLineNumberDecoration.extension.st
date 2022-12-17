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

	| holder index cairoScaledFont cairoGlyphsArray fontExtents |
	super aeDraw: anItemElement overOn: aeCanvas in: anInfiniteElement.
	aeCanvas restoreContextAfter: [ 
		aeCanvas pathTranslate: self computedBounds left - anInfiniteElement border width @ anItemElement bounds inParent top.
		holder := anInfiniteElement childHolderOf: anItemElement.
		index := holder layoutPosition.

		cairoScaledFont := self aeCairoScaledFontOn: aeCanvas.
		fontExtents := cairoScaledFont extents.
		aeCanvas pathTranslate: 6 @ fontExtents ascent.
		aeCanvas setSourceColor: Color gray darker.
		cairoGlyphsArray := cairoScaledFont glyphArrayForString: index asString.
		aeCanvas drawText: cairoGlyphsArray font: cairoScaledFont ]
]

{ #category : #'*Album-Alexandrie' }
AlbLineNumberDecoration >> aeDrawBackgroundOn: aeCanvas in: anInfiniteElement [

	"draw the background beneath "

	aeCanvas pathFactory: [ :cairoContext | 
		cairoContext rectangle: self computedBounds ].
	aeCanvas
		setBackgroundWith: [ aeCanvas setSourceColor: Color veryLightGray ]
		alpha: 0.10.
	aeCanvas setBorderOff.
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

	| holder cairoScaledFont fontExtents cairoGlyphsArray |
	anInfiniteElement hasChildren ifFalse: [ ^self ].
	holder := anInfiniteElement childHolderOf: anInfiniteElement children last.
	cairoScaledFont := self aeCairoScaledFontOn: aeCanvas.
	fontExtents := cairoScaledFont extents.
	cairoGlyphsArray := cairoScaledFont glyphArrayForString: holder layoutPosition asString.
	aeCanvas textExtentsFor: cairoGlyphsArray scaledFont: cairoScaledFont do: [ :aTextExtents | 
		self onActualWidthChangeWith: aTextExtents width do: [ anInfiniteElement requestLayout ] ]
]
