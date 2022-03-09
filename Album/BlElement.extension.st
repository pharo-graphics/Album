Extension { #name : #BlElement }

{ #category : #'*Album' }
BlElement >> layoutResizerPropagations [
	^ self userData
		at: #layoutResizerPropagations
		ifAbsentPut: [ AlbLayoutResizerElementPropagations new element: self ]
]
