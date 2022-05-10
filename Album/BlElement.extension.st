Extension { #name : #BlElement }

{ #category : #'*Album' }
BlElement >> applyStyles [
	self styles applyStylesForStates: self states allStates.
]
