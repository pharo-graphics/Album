Extension { #name : #AlbEditorSelectionView }

{ #category : #'*Album-Alexandrie' }
AlbEditorSelectionView >> aeDrawOn: aeCanvas in: anInfiniteElement [
	"Draw an editor element selection polygon"

	self aeDrawSelectionOn: aeCanvas in: anInfiniteElement.
	self aeDrawRemanentsOn: aeCanvas in: anInfiniteElement 
]

{ #category : #'*Album-Alexandrie' }
AlbEditorSelectionView >> aeDrawRemanentsOn: aeCanvas in: anInfiniteElement [

	remanentUpdater ifNotNil: [ ^ self ].
	remanents ifEmpty: [ ^ self ].
	aeCanvas restoreContextAfter: [ 
		aeCanvas setBorderOff.
		selectionColor asBlPaint aeApplyTo: aeCanvas opacity: 0.3.
		remanents do: [ :e | 
			e aeApplyTo: aeCanvas element: anInfiniteElement.
			aeCanvas drawFigure ] ]
]

{ #category : #'*Album-Alexandrie' }
AlbEditorSelectionView >> aeDrawSelectionOn: aeCanvas in: anInfiniteElement [
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
