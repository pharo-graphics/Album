Extension { #name : #AlbEditorSelectionView }

{ #category : #'*Album-Alexandrie' }
AlbEditorSelectionView >> aeDrawOn: aeCanvas in: anInfiniteElement [

	"Draw an editor element selection polygon"

	vertices ifNil: [ ^ self ].
	anInfiniteElement isWithSelection ifFalse: [ ^ false ].

	aeCanvas restoreContextAfter: [ 
		self background aeApplyTo: aeCanvas.

		aeCanvas setOutskirtsCentered.
		
		aeCanvas setBorderBlock: [ 
			| border |
			
			border := self border.
			border paint aeApplyTo: aeCanvas.
			border style aeApplyTo: aeCanvas.
			aeCanvas setLineJoinBlock: [ aeCanvas setJoinRound ].
			aeCanvas setBorderWidth: border width.
			aeCanvas prepareToDrawChildrenWithClipping: true.].

		self geometry aeApplyTo: aeCanvas element: anInfiniteElement.

		aeCanvas drawFigure ]
]
