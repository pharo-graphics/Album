Extension { #name : #AlbTextParagraph }

{ #category : #'*Album-Alexandrie' }
AlbTextParagraph >> aeDrawExtendedSelectionOn: aCanvas [ 

	self
		aeDrawselection: self extendedSelection
		on: aCanvas
		color: self class extendedSelectionColor
]

{ #category : #'*Album-Alexandrie' }
AlbTextParagraph >> aeDrawOppositeOn: aeCanvas [

	| bnds |
	self oppositeIndex < 0 ifTrue: [ ^ self ].
	bnds := self characterBoundsAtIndex: self oppositeIndex.
	Transcript show: self padding asString; cr.
	aeCanvas restoreContextAfter: [ 
		aeCanvas setBackgroundWith: [ aeCanvas setSourceColor: self class oppositeDelimiterBackgroundColor ] alpha: 0.3.
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
