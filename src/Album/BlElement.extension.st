Extension { #name : #BlElement }

{ #category : #'*Album' }
BlElement >> allSelectionBounds [

	^ Array streamContents: [ :stream | 
		self children sortedByElevation do: [ :anElement | 
				stream nextPutAll: (anElement allSelectionBounds collect: [ :b | self localBoundsToParent: b ] ) ] ]
]
