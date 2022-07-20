Extension { #name : #AlbTextParagraph }

{ #category : #'*Album-Alexandrie' }
AlbTextParagraph >> aeDrawOppositeOn: aeCanvas at: oppositeIndex [
	| bnds |
	self flag: 'Not used but kept for the record for now'.
	bnds := self characterBoundsAtIndex: oppositeIndex.
	aeCanvas restoreContextAfter: [ 
		aeCanvas setBackgroundWith: [ aeCanvas setSourceColor: Color random ] alpha: 0.3.
				aeCanvas pathTranslate: self padding topLeft.

		aeCanvas setOutskirtsCentered.
		aeCanvas setBorderBlock: [
				aeCanvas setSourceColor: Color black.
				aeCanvas setBorderWidth: 1.0 ].
		aeCanvas
			setPathKey: self
			hasJoins: true
			hasCaps: false
			block: [ :cairoContext | cairoContext rectangle: (bnds expandBy: (Margin
						  left: 0
						  right: 0
						  top: 0
						  bottom: 0)) ].

		aeCanvas drawFigure ]
]
