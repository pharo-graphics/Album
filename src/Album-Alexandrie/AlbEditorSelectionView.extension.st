Extension { #name : #AlbEditorSelectionView }

{ #category : #'*Album-Alexandrie' }
AlbEditorSelectionView >> aeDrawOn: aeCanvas in: anInfiniteElement [
	"Draw an editor element selection polygon"

	self selectionGeometry ifNil: [ ^ self ].
	aeCanvas restoreContextAfter: [ 
		self selectionGeometry aeApplyTo: aeCanvas element: anInfiniteElement.
		(self backgroundIn: anInfiniteElement) aeApplyTo: aeCanvas.
		aeCanvas setOutskirtsCentered.

		aeCanvas setBorderBlock: [ 
			| border |
			border := self borderIn: anInfiniteElement.
			border paint aeApplyTo: aeCanvas.
			border style in: [ :style |
				aeCanvas setBorderWidth: border width ]].

		aeCanvas drawFigure ]
]
