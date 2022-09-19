Extension { #name : #AlbEditorSelectionView }

{ #category : #'*Album-Alexandrie' }
AlbEditorSelectionView >> aeDrawBeneathOn: aeCanvas in: anInfiniteElement [

	"Draw any appropriate decorations into the Sparta Canvas supplied to the Infinite Element. Any content drawn by this method will be drawn before the item elements are drawn, and will thus appear underneath them"

	| myBackground myBorder geometry |
	vertices ifNil: [ ^ self ].

	aeCanvas restoreContextAfter: [ 
		myBackground := (BlPaintBackground paint:
			                 anInfiniteElement selectionColor asBlPaint)
			                yourself.
		myBackground aeApplyTo: aeCanvas.

		myBorder := BlBorder
			            paint:
			            anInfiniteElement selectionColor lighter asBlPaint
			            width: 1.
		myBorder isTransparent
			ifTrue: [ aeCanvas setBorderOff ]
			ifFalse: [ 
				aeCanvas setOutskirtsOutside.
				aeCanvas setBorderBlock: [ 
					myBorder paint aeApplyTo: aeCanvas.
					myBorder style aeApplyTo: aeCanvas.
					aeCanvas setBorderWidth: myBorder width ] ].

		geometry := BlPolygonGeometry vertices: vertices.
		geometry aeApplyTo: aeCanvas element: anInfiniteElement.

		aeCanvas drawFigure ]
]
