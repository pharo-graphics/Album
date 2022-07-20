Extension { #name : #AlbLineNumberDecoration }

{ #category : #'*Album-Alexandrie' }
AlbLineNumberDecoration >> aeDraw: anItemElement on: aeCanvas in: anInfiniteElement [

	| holder index w s cairoScaledFont cairoGlyphsArray fontExtents |
	w := self width - anInfiniteElement border width.
	aeCanvas restoreContextAfter: [ 
		aeCanvas pathTranslate: anInfiniteElement border width @ anItemElement bounds inParent top.

		"Hihglight the selection if the element holds it"
		holder := anInfiniteElement childHolderOf: anItemElement.
		(holder hasCursor and: [ anInfiniteElement selection isEmpty ]) ifTrue: [ 
			| h path |
			h := anItemElement height.
			path := Rectangle origin: anInfiniteElement border width @ 0 corner: w @ h.
			aeCanvas
				setBackgroundWith: [ aeCanvas setSourceColor: anInfiniteElement selectionColor ]
				alpha: 1.0.
			aeCanvas setBorderOff.
			aeCanvas
				setPathKey: self
				hasJoins: true
				hasCaps: false
				block: [ :cairoContext | cairoContext rectangle: path ].

			aeCanvas drawFigure ] ].

	aeCanvas restoreContextAfter: [ 
		index := holder layoutPosition.
		s := index asString utf8Encoded.
		cairoScaledFont := self cairoScaledFontOn: aeCanvas.
		fontExtents := cairoScaledFont extents.
		aeCanvas pathTranslate:
			anInfiniteElement border width + 4 @ (anItemElement bounds inParent top + fontExtents ascent).
		aeCanvas setSourceColor: Color black.
		cairoGlyphsArray := cairoScaledFont glyphArrayFor: s length: s size.
		aeCanvas drawText: cairoGlyphsArray font: cairoScaledFont ]
]

{ #category : #'*Album-Alexandrie' }
AlbLineNumberDecoration >> aeDrawOn: aeCanvas in: anInfiniteElement [

	"Draw the background beneath "

	aeCanvas restoreContextAfter: [ 
		aeCanvas setBackgroundWith: [ aeCanvas setSourceColor: Color veryLightGray ] alpha: 0.20.
		aeCanvas pathTranslate: anInfiniteElement border width @ anInfiniteElement bounds top.
		aeCanvas setBorderOff.
		aeCanvas
			setPathKey: self
			hasJoins: true
			hasCaps: false
			block: [ :cairoContext | 
				cairoContext rectangle: (Rectangle
						 origin: 0 @ 0
						 corner: self width - anInfiniteElement border width @ anInfiniteElement height) ].
		aeCanvas drawFigure ].
	"super sent ensure drwing for item elements"
	super aeDrawOn: aeCanvas in: anInfiniteElement
]

{ #category : #'*Album-Alexandrie' }
AlbLineNumberDecoration >> cairoScaledFontOn: aeCanvas [
	| fontAndStyleBuilder freeTypeFont |
	fontAndStyleBuilder := BlTextFontAndStyleBuilder new.
	freeTypeFont := fontAndStyleBuilder font asLogicalFont asFreetypeFont.
	^ aeCanvas scaledFontFor: freeTypeFont.
]
