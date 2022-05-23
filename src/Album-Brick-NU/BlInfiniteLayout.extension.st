Extension { #name : #BlInfiniteLayout }

{ #category : #'*Album-Brick-NU' }
BlInfiniteLayout >> detachAndScrapChild: anElement [
	"Detach a child element and add it to a BlInfiniteRecycler's scrap heap.
	Scrapping an element allows it to be rebound and reused to show updated or different data"
	| anIndex |
	
	anIndex := childManager childIndexOf: anElement.
	self scrapOrRecycleChild: anElement at: anIndex
]

{ #category : #'*Album-Brick-NU' }
BlInfiniteLayout >> detachAndScrapChildAt: anIndex [
	"Detach a child element at anIndex and add it to a BlInfiniteRecycler's scrap heap.
	Scrapping a view allows it to be rebound and reused to show updated or different data"
	| anElement |
	
	anElement := self childAt: anIndex.
	self scrapOrRecycleChild: anElement at: anIndex
]
