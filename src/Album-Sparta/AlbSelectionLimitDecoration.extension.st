Extension { #name : #AlbSelectionLimitDecoration }

{ #category : #'*Album-Sparta' }
AlbSelectionLimitDecoration >> draw: anItemElement overOnSpartaCanvas: aCanvas in: anInfiniteElement [

	anInfiniteElement selection ifEmpty: [ ^ self ].
	super draw: anItemElement overOnSpartaCanvas: aCanvas in: anInfiniteElement
]
