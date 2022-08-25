Class {
	#name : #AlbRecycler,
	#superclass : #Object,
	#traits : 'TBlDebug',
	#classTraits : 'TBlDebug classTrait',
	#instVars : [
		'controller',
		'attachedScrap',
		'fetcher'
	],
	#category : #'Album-Recycler'
}

{ #category : #'accessing - cache' }
AlbRecycler >> attachedScrap [
	"Return a collection of attached scrapped elements"
	<return: #SequenceableCollection>
	
	^ attachedScrap
]

{ #category : #initialization }
AlbRecycler >> clear [
	self removeScrap
]

{ #category : #recycling }
AlbRecycler >> clearOldPositions [

	self attachedScrap do: [ :anElementHolder |
		anElementHolder clearOldPosition ]
]

{ #category : #'accessing - cache' }
AlbRecycler >> clearScrap [
	"Removes all scrapped elements from corresponding pools"
	
	attachedScrap removeAll
]

{ #category : #accessing }
AlbRecycler >> controller [
	^ controller
]

{ #category : #accessing }
AlbRecycler >> controller: aBlInfiniteRecyclerController [
	controller := aBlInfiniteRecyclerController
]

{ #category : #initialization }
AlbRecycler >> defaultFetcher [
	^ AlbRecyclerPositionScrapFetcher new

]

{ #category : #'accessing - element' }
AlbRecycler >> elementFor: aPosition [
	"Returns an element representing the data at a position from data source.
	I should be used by InfiniteLayout implementations to obtain elements to represent data from a DataSource.

	Recycler may reuse a scrap or detached element from a shared pool if one is
	available for the correct element type. If the data source has not indicated that the
	data at the given position has changed, the Recycler will attempt to hand back
	a scrap element that was previously initialized for that data without rebinding."
	<return: #BlElement>

	^ self elementFor: aPosition dryRun: false
]

{ #category : #private }
AlbRecycler >> elementFor: aPosition dryRun: dryRun [
	"I do a hard work obtaining element for the data at a position in data source.
	@see elementFor: for more information"
	<return: #BlElement>

	| holder fromScrap fetchedResult bound itemElement anInfiniteConstraints |
	
	(aPosition < 1 or: [ aPosition > self controller dataSourceItemCount ])
		ifTrue: [ Error signal: 'Position is out of bounds!' ].

	fetchedResult := fetcher elementFor: aPosition dryRun: dryRun controller: self controller.
	
	holder := fetchedResult key.
	fromScrap := fetchedResult value.

	self assert: holder isNotNil.
	self assert: fromScrap isNotNil.

	bound := false.
	(self controller isPreLayout and: [ holder isBound ])
		ifTrue: [ holder preLayoutPosition: aPosition ]
		ifFalse: [
			(holder isBound not or: [ holder needsUpdate or: [ holder isInvalid ] ]) ifTrue: [
				| offsetPosition |
				holder isRemoved ifTrue: [ Error signal: 'Removed holder should come here only in pre-layout!' ].
				offsetPosition := self controller computePositionOffset: aPosition.
				holder infiniteElement: self controller infiniteElement.
				
				self controller bindHolder: holder at: offsetPosition.
				
				bound := true.
				self controller isPreLayout
					ifTrue: [ holder preLayoutPosition: aPosition ] ] ].
	
	itemElement := holder itemElement.
	anInfiniteConstraints := itemElement constraints infinite.
	anInfiniteConstraints holder: holder.
	anInfiniteConstraints pendingInvalidate: (fromScrap and: [ bound ]).
	^ itemElement
]

{ #category : #invalidation }
AlbRecycler >> elementRangeUpdate: aPosition itemCount: anItemCount [

	self flag: 'Not in Album'
]

{ #category : #initialization }
AlbRecycler >> initialize [
	super initialize.
	attachedScrap := OrderedCollection new.
	fetcher := self defaultFetcher.

]

{ #category : #'private - invalidation' }
AlbRecycler >> markItemDecorationsInsetsDirty [

	self flag: 'Not in Album'
]

{ #category : #'private - invalidation' }
AlbRecycler >> markKnownElementsInvalid [

	self flag: 'Not in Album'
]

{ #category : #'private - commands' }
AlbRecycler >> offsetPositionRecordsForInsert: aStartPosition itemCount: anItemCount [

	self flag: 'Not in Album'
	
]

{ #category : #'private - commands' }
AlbRecycler >> offsetPositionRecordsForRemove: aPositionStart itemCount: anItemCount applyToPreLayout: applyToPreLayout [

	self flag: 'Not in Album'
]

{ #category : #recycling }
AlbRecycler >> quickRecycleScrap: anElement [
	"Used as a fast path for unscrapping and recycling a an element during a bulk operation.
	The sender must send #clearScrap when it's done to update the recycler's internal bookkeeping.
	anElement must not be nil"
]

{ #category : #recycling }
AlbRecycler >> recycleElement: anElement [
	"Recycle a detached element.
	The specified element will be added to a pool of elements for later rebinding and reuse.
	An element must be fully detached (removed from parent) before it may be recycled.
	If the element is scrapped, it will be removed from scrap list

	Notice: I try to make element recycle-able since layout intended to recycle this element (e.g. even if it is in scrap or change cache)"
	| anElementHolder |
	anElementHolder := self controller elementHolderOf: anElement.	
	anElementHolder isScrap
		ifTrue: [ self unscrapHolder: anElementHolder ]
		ifFalse: [ anElementHolder wasReturnedFromScrap
			ifTrue: [ anElementHolder clearReturnedFromScrap ] ].
]

{ #category : #removing }
AlbRecycler >> removeChangedScrap [

	self flag: 'Not in Album'
]

{ #category : #recycling }
AlbRecycler >> removeScrap [
	"Remove all scrap elements out of this recycler.
	Detached elements contained within a recycler pool will remain"

	attachedScrap removeAll
]

{ #category : #'accessing - cache' }
AlbRecycler >> reverseScrapDo: aBlock [
	| aScrapCount |
	
	aScrapCount := self scrapCount.
	aScrapCount isZero
		ifTrue: [ ^ self ].

	aScrapCount to: 1 by: -1 do: [ :anIndex |
		| anElement |
		anElement := self scrappedElementAt: anIndex.
		anElement ifNotNil: [ aBlock cull: anElement cull: anIndex ] ]
]

{ #category : #'accessing - cache' }
AlbRecycler >> scrapCount [
	"Return amount of scrapped elements"
	<return: #Number>

	^ attachedScrap size
]

{ #category : #recycling }
AlbRecycler >> scrapElement: anElement [

	| anElementHolder |
	anElementHolder := self controller elementHolderOf: anElement.

	(anElementHolder isRemoved or: [ 
		 anElementHolder isInvalid or: [ 
			 anElementHolder isUpdated not or: [ 
				 self controller canReuseUpdatedElementHolder: anElementHolder ] ] ]) 
		ifFalse: [ ^ self ].

	(anElementHolder isInvalid and: [ 
		 anElementHolder isRemoved not and: [ 
			 self controller hasStableIds not ] ]) ifTrue: [ 
		self error:
			'Can not scrap invalid elements, because they can not be reused from scrap and should be rebound from recycler pool instead' ].
	anElementHolder recycler: self inChangeScrap: false.
	attachedScrap add: anElementHolder
]

{ #category : #'accessing - cache' }
AlbRecycler >> scrappedElementAt: anIndex [
	"Return scrapped element at anIndex"
	<return: #BlElement>

	^ (attachedScrap at: anIndex) itemElement
]

{ #category : #initialization }
AlbRecycler >> setDataSourcePositionsAsUnknown [

	self flag: 'Not in Album'
]

{ #category : #recycling }
AlbRecycler >> unscrapHolder: anElementHolder [
	"Remove a previously scrapped element holder from the pool of eligible scrap.
	An element will no longer be eligible for reuse until re-scrapped or until
	it is explicitly removed and recycled"

	attachedScrap remove: anElementHolder.
	anElementHolder detachRecycler
]
