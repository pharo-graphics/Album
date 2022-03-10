Class {
	#name : #AlbTextAdornmentAttributePooledCache,
	#superclass : #AlbTextAdornmentAttributeCache,
	#instVars : [
		'cachePool'
	],
	#category : #'Album-Editor-Attributes - Support'
}

{ #category : #'private - cache' }
AlbTextAdornmentAttributePooledCache >> canElementBeReusedFromCache: anElement [
	"Return true if given element can be reused from the cache"
	<return: #Boolean>
	
	"element is detached - we can reuse it"
	anElement isDetachedFromSceneGraph
		ifTrue: [ ^ true ].

	^ anElement isRemovedFromSceneGraph and: [ anElement hasParent not ]
]

{ #category : #'private - cache' }
AlbTextAdornmentAttributePooledCache >> canEntryBeReusedFromCache: aCollectionOfElementsOrElement [
	"Return true if a given cache entry can be reused from the cache"
	<return: #Boolean>

	^ aCollectionOfElementsOrElement isCollection
		ifTrue: [ aCollectionOfElementsOrElement allSatisfy: [ :eachElement | self canElementBeReusedFromCache: eachElement ] ]
		ifFalse: [ self canElementBeReusedFromCache: aCollectionOfElementsOrElement ]
]

{ #category : #'api - cache' }
AlbTextAdornmentAttributePooledCache >> ifAbsentPut: aBlock [
	"Return available cached elements previously created by an adornment attribute"
	<return: #SequenceableCollection of: #BlElement>

	^ cachePool
		detect: [ :eachCacheEntry | self canEntryBeReusedFromCache: eachCacheEntry ]
		ifNone: [
			| aNewCacheEntry |
			aNewCacheEntry := aBlock value.
			cachePool add: aNewCacheEntry.
			aNewCacheEntry ]
]

{ #category : #initialization }
AlbTextAdornmentAttributePooledCache >> initialize [
	super initialize.
	
	cachePool := OrderedCollection new
]
