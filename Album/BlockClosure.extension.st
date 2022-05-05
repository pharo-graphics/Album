Extension { #name : #BlockClosure }

{ #category : #'*Album' }
BlockClosure >> asStencil [
	<return: #BrStencil>

	^ AlbValuableStencil from: self
]

{ #category : #'*Album' }
BlockClosure >> asStencil: aStencilClass [
	^ aStencilClass new executor: (AlbStencilValuableExecutor from: self)
]
