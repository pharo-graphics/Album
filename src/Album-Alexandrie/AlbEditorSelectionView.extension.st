Extension { #name : #AlbEditorSelectionView }

{ #category : #'*Album-Alexandrie' }
AlbEditorSelectionView >> aeDrawOn: aeCanvas in: anInfiniteElement [
	"Draw an editor element selection polygon"

	vertices ifNil: [ ^ self ].

	aeCanvas restoreContextAfter: [ 

		self geometry aeApplyTo: aeCanvas element: anInfiniteElement.
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
