Trait {
	#name : #TAlbLayoutResizable,
	#category : #'Album-Brick-Core-Layout Resizer'
}

{ #category : #'api - layout resizeable' }
TAlbLayoutResizable >> exact: aPoint [
	| aSize |
	
	aSize := aPoint asPoint.
	self hExact: aSize x.
	self vExact: aSize y
]

{ #category : #'api - layout resizeable' }
TAlbLayoutResizable >> fitContent [
	self hFitContent.
	self vFitContent
]

{ #category : #'api - layout resizeable' }
TAlbLayoutResizable >> fitContentLimited [
	self hFitContentLimited.
	self vFitContentLimited
]

{ #category : #'api - layout resizeable' }
TAlbLayoutResizable >> hExact: aNumber [

	"we have to set the size in the constraints because the resizer state is stateless and does not propagate the actual size value"
	(self constraints horizontal resizer isExact
		and: [ self constraints horizontal resizer size = aNumber ])
			ifFalse: [ self constraintsDo: [ :c | c horizontal exact: aNumber ] ].

	self states addState: AlbLayoutHorizontalResizerState exact
]

{ #category : #'api - layout resizeable' }
TAlbLayoutResizable >> hFitContent [
	(self constraints horizontal resizer isFitContent)
		ifFalse: [ self constraintsDo: [ :c | c horizontal fitContent ] ].

	self states addState: AlbLayoutHorizontalResizerState fitContent
]

{ #category : #'api - layout resizeable' }
TAlbLayoutResizable >> hFitContentLimited [
	(self constraints horizontal resizer isFitContentLimited)
		ifFalse: [ self constraintsDo: [ :c | c horizontal fitContentLimited ] ].

	self states addState: AlbLayoutHorizontalResizerState fitContentLimited
]

{ #category : #'api - layout resizeable' }
TAlbLayoutResizable >> hLocal [
	self states addState: AlbLayoutHorizontalResizerState local
]

{ #category : #'api - layout resizeable' }
TAlbLayoutResizable >> hMatchParent [
	(self constraints horizontal resizer isMatchParent)
		ifFalse: [ self constraintsDo: [ :c | c horizontal matchParent ] ].

	self states addState: AlbLayoutHorizontalResizerState matchParent
]

{ #category : #'api - layout resizeable' }
TAlbLayoutResizable >> matchParent [
	self hMatchParent.
	self vMatchParent
]

{ #category : #'api - layout resizeable' }
TAlbLayoutResizable >> vExact: aNumber [
	
	"we have to set the size in the constraints because the resizer state is stateless and does not propagate the actual size value"
	(self constraints vertical resizer isExact
		and: [ self constraints vertical resizer size = aNumber ])
			ifFalse: [
				self constraintsDo: [ :c | c vertical exact: aNumber ] ].

	self states addState: AlbLayoutVerticalResizerState exact
]

{ #category : #'api - layout resizeable' }
TAlbLayoutResizable >> vFitContent [
	(self constraints vertical resizer isFitContent)
		ifFalse: [ self constraintsDo: [ :c | c vertical fitContent ] ].

	self states addState: AlbLayoutVerticalResizerState fitContent
]

{ #category : #'api - layout resizeable' }
TAlbLayoutResizable >> vFitContentLimited [
	(self constraints vertical resizer isFitContentLimited)
		ifFalse: [ self constraintsDo: [ :c | c vertical fitContentLimited ] ].

	self states addState: AlbLayoutVerticalResizerState fitContentLimited
]

{ #category : #'api - layout resizeable' }
TAlbLayoutResizable >> vLocal [
	self states addState: AlbLayoutVerticalResizerState local
]

{ #category : #'api - layout resizeable' }
TAlbLayoutResizable >> vMatchParent [
	(self constraints vertical resizer isMatchParent)
		ifFalse: [ self constraintsDo: [ :c | c vertical matchParent ] ].

	self states addState: AlbLayoutVerticalResizerState matchParent
]
