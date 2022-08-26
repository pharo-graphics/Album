Extension { #name : #AlbSelectionLimitDecoration }

{ #category : #'*Album-Alexandrie' }
AlbSelectionLimitDecoration >> aeDraw: anItemElement overOn: aeCanvas in: anInfiniteElement [

	anInfiniteElement selection ifEmpty: [ ^ self ].
	super aeDraw: anItemElement overOn: aeCanvas in: anInfiniteElement
]
