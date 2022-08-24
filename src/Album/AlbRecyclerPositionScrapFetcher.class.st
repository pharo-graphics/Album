Class {
	#name : #AlbRecyclerPositionScrapFetcher,
	#superclass : #BlInfiniteRecyclerFetcher,
	#category : #'Album-Recycler'
}

{ #category : #initialization }
AlbRecyclerPositionScrapFetcher >> defaultNext [
	^ AlbRecyclerDataSourceFetcher new
]

{ #category : #'element fetching' }
AlbRecyclerPositionScrapFetcher >> elementFor: aPosition dryRun: dryRun controller: aRecyclerController [

	| holder fromScrap |
	fromScrap := false.
	holder := self
		          positionedScrapFor: aPosition
		          type: BlInfiniteItemType invalid
		          dryRun: dryRun
		          controller: aRecyclerController.
	holder ifNotNil: [ 
		(self validateHolder: holder controller: aRecyclerController)
			ifFalse: [ 
				dryRun ifFalse: [ 
					holder flags addInvalid.
					holder isScrap
						ifTrue: [ 
							aRecyclerController childRemoved: holder itemElement.
							holder itemElement dispatchRemovedFromParent: holder infiniteElement.
							aRecyclerController unscrapHolder: holder ]
						ifFalse: [ 
							holder wasReturnedFromScrap ifTrue: [ holder clearReturnedFromScrap ] ] ].
				holder := nil ]
			ifTrue: [ fromScrap := true ] ].

	^ holder ifNotNil: [ holder -> fromScrap ] ifNil: [
		  self nextDo: [ :next | 
			  next
				  elementFor: aPosition
				  dryRun: dryRun
				  controller: aRecyclerController ] ]
]

{ #category : #private }
AlbRecyclerPositionScrapFetcher >> exactScrapFor: aPosition type: itemType dryRun: dryRun controller: aRecyclerController [

	^ aRecyclerController attachedScrap 
		detect: [ :holder | (holder wasReturnedFromScrap not
			and: [ holder layoutPosition = aPosition 
				and: [ holder isInvalid not
					and: [ aRecyclerController isPreLayout
						or: [ holder isRemoved not ] ] ] ]) ]
		ifFound: [ :holder | 
			(itemType = BlInfiniteItemType invalid
				or: [ holder itemType = itemType ])
					ifFalse: [ 
						Error signal: 'Scrap holder has wrong item type!' ].
			holder flags addReturnedFromScrap.
			holder ]
		ifNone: [ nil ]
]

{ #category : #private }
AlbRecyclerPositionScrapFetcher >> positionedScrapFor: aPosition type: itemType dryRun: dryRun controller: aRecyclerController [
	
	(self exactScrapFor: aPosition type: itemType dryRun: dryRun controller: aRecyclerController)
		ifNotNil: [ :holder | 
			^ holder  ].
	
	dryRun ifFalse: [ 
		(aRecyclerController findHiddenNonRemovedChildAt: aPosition type: itemType)
			ifNotNil: [ :child |
				aRecyclerController endAnimation: (aRecyclerController elementHolderOf: child) ] ].
		
	^ nil
]

{ #category : #private }
AlbRecyclerPositionScrapFetcher >> validateHolder: aHolder controller: aRecyclerController [

	aHolder isRemoved ifTrue: [ 
		aRecyclerController isPreLayout
			ifFalse: [ Error signal: 'Should not get a removed holder!' ].
		^ aRecyclerController isPreLayout ].

	(aHolder position <= 0 or: [ aHolder position > aRecyclerController dataSourceItemCount ])
		ifTrue: [ Error signal: ('Holder has completely wrong position! position = {1}, count = {2}'
			format: { aHolder position. aRecyclerController dataSourceItemCount. }) ].

	aRecyclerController isPreLayout ifFalse: [ 
		| type |
		type := aRecyclerController itemTypeAt: aHolder position.
		type = aHolder itemType
			ifFalse: [ ^ false ] ].

	^ aRecyclerController hasStableIds
		ifTrue: [ aHolder itemId = (aRecyclerController itemIdAt: aHolder position) ]
		ifFalse: [ true ]
]
