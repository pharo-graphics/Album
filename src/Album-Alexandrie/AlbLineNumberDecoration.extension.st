Extension { #name : #AlbLineNumberDecoration }

{ #category : #'*Album-Alexandrie' }
AlbLineNumberDecoration >> aeDraw: anItemElement on: aeCanvas in: anInfiniteElement [

	"Draw any appropriate decorations into the Sparta Canvas supplied to the Infinite Element for its child element anItemElement.
		Any content drawn by this method will be drawn after the item elements are drawn, and will thus appear over them"

	| holder index w s cairoScaledFont cairoGlyphsArray fontExtents |
	w := anInfiniteElement layout  leftDecorationWidth: anItemElement.
	aeCanvas restoreContextAfter: [ 
		"first : draw the background beneath "
		aeCanvas setBackgroundWith: [ aeCanvas setSourceColor: Color veryLightGray ] alpha: 0.20.
		aeCanvas pathTranslate: anInfiniteElement border width @ anItemElement bounds inParent top.
		aeCanvas setBorderOff.
		aeCanvas
			setPathKey: self
			hasJoins: true
			hasCaps: false
			block: [ :cairoContext | cairoContext rectangle: (Rectangle origin: 0 @ 0 corner: w @ anItemElement height) ].
		aeCanvas drawFigure.

		"second hihglight the selection is the element holds it"
		holder := anInfiniteElement childHolderOf: anItemElement.
		(holder hasCursor and: [ anInfiniteElement selection isEmpty ]) ifTrue: [ 
			| h path |
			h := anItemElement height.
			path := Rectangle origin: anInfiniteElement border width @ 0 corner: w @ h.
			aeCanvas setBackgroundWith: [ aeCanvas setSourceColor: anInfiniteElement selectionColor ] alpha: 1.0.
			aeCanvas setBorderOff.
			aeCanvas
				setPathKey: self
				hasJoins: true
				hasCaps: false
				block: [ :cairoContext | cairoContext rectangle: path ].

			aeCanvas drawFigure ]].
	
	aeCanvas restoreContextAfter: [ 
		index := holder layoutPosition.
		s := index asString utf8Encoded.
		cairoScaledFont := self cairoScaledFontOn: aeCanvas.
		fontExtents := cairoScaledFont extents.
		aeCanvas pathTranslate: (anInfiniteElement border width + 4) @ (anItemElement bounds inParent top + fontExtents ascent).
		aeCanvas setSourceColor: Color black.
		cairoGlyphsArray := cairoScaledFont glyphArrayFor: s length: s size.
		aeCanvas drawText: cairoGlyphsArray font: cairoScaledFont ]
]

{ #category : #'*Album-Alexandrie' }
AlbLineNumberDecoration >> cairoScaledFontOn: aeCanvas [
	| fontAndStyleBuilder freeTypeFont |
	fontAndStyleBuilder := BlTextFontAndStyleBuilder new.
	freeTypeFont := fontAndStyleBuilder font asLogicalFont asFreetypeFont.
	^ aeCanvas scaledFontFor: freeTypeFont.
]
