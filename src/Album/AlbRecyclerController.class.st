Class {
	#name : #AlbRecyclerController,
	#superclass : #Object,
	#instVars : [
		'infiniteElement'
	],
	#category : #'Album-Recycler'
}

{ #category : #'scrap fetcher -> recycler' }
AlbRecyclerController >> attachedScrap [
	^ self recycler attachedScrap
]

{ #category : #'recycler -> data source' }
AlbRecyclerController >> bindHolder: aHolder at: aPosition [
	self dataSource bindHolder: aHolder at: aPosition
]

{ #category : #'recycler -> animator' }
AlbRecyclerController >> canReuseUpdatedElementHolder: anElementHolder [
	"Return true if changed element holder can be reused"
	<return: #Boolean>
	
	^ infiniteElement itemAnimator supportsAnimations not or: [ 
			infiniteElement itemAnimator
				canReuseUpdatedElementHolder: anElementHolder
				payloads: anElementHolder payloads ]
]

{ #category : #'recycler -> element' }
AlbRecyclerController >> childRemoved: anElement [
	self flag: 'todo'.
]

{ #category : #accessing }
AlbRecyclerController >> childrenManager [
	^ infiniteElement childrenManager
]

{ #category : #'recycler -> data source' }
AlbRecyclerController >> computePositionOffset: aPosition [
	^ self dataSourceManager computePositionOffset: aPosition
]

{ #category : #'recycler -> data source' }
AlbRecyclerController >> createElementHolderOfType: anItemType [
	<return: #BlInfiniteHolder>

	^ self dataSource createHolder: infiniteElement type: anItemType
]

{ #category : #accessing }
AlbRecyclerController >> dataSource [
	^ infiniteElement dataSource
]

{ #category : #'recycler -> data source' }
AlbRecyclerController >> dataSourceItemCount [
	^ self dataSource itemCount
]

{ #category : #accessing }
AlbRecyclerController >> dataSourceManager [
	^ infiniteElement dataSourceManager
]

{ #category : #'recycler -> element' }
AlbRecyclerController >> elementHolderOf: anElement [
	^ infiniteElement elementHolderOf: anElement
]

{ #category : #'recycler -> animator' }
AlbRecyclerController >> endAnimation: aChildHolder [
	^ self shouldBeImplemented
]

{ #category : #'recycler -> children' }
AlbRecyclerController >> findHiddenNonRemovedChildAt: aPosition type: anItemType [
	^ self childrenManager findHiddenNonRemovedChildAt: aPosition type: anItemType
]

{ #category : #'scrap fetcher -> recycler' }
AlbRecyclerController >> hasChangedScrap [
	^ self shouldBeImplemented
]

{ #category : #'recycler -> data source' }
AlbRecyclerController >> hasStableIds [
	^ self dataSource hasStableIds
]

{ #category : #accessing }
AlbRecyclerController >> infiniteElement [
	^ infiniteElement
]

{ #category : #accessing }
AlbRecyclerController >> infiniteElement: anInfiniteElement [

	infiniteElement := anInfiniteElement.
	infiniteElement recycler controller: self.
]

{ #category : #accessing }
AlbRecyclerController >> infoStore [
	^ infiniteElement infoStore
]

{ #category : #'recycler -> element' }
AlbRecyclerController >> isItemPrefetchEnabled [
	^ infiniteElement layout isItemPrefetchEnabled
]

{ #category : #'recycler -> state' }
AlbRecyclerController >> isPreLayout [
	^ self state isPreLayout
]

{ #category : #'recycler -> data source' }
AlbRecyclerController >> itemIdAt: aPosition [
	^ self dataSource itemIdAt: aPosition
]

{ #category : #'recycler -> element' }
AlbRecyclerController >> itemPrefetchCount [
	^ self shouldBeImplemented
]

{ #category : #'recycler -> data source' }
AlbRecyclerController >> itemTypeAt: aPosition [
	^ self dataSource itemTypeAt: aPosition
]

{ #category : #'recycler -> element' }
AlbRecyclerController >> lastPrefetchIncludedPosition: aPosition [
	^ self shouldBeImplemented
]

{ #category : #accessing }
AlbRecyclerController >> recycler [
	^ infiniteElement recycler
]

{ #category : #'scrap fetcher -> recycler' }
AlbRecyclerController >> recyclerPool [
	^ self recycler pool
]

{ #category : #accessing }
AlbRecyclerController >> state [
	^ infiniteElement state
]

{ #category : #'recycler -> state' }
AlbRecyclerController >> stateItemCount [
	^ self shouldBeImplemented
]

{ #category : #'recycler -> element' }
AlbRecyclerController >> unscrapHolder: anElementHolder [
	self recycler unscrapHolder: anElementHolder
]
