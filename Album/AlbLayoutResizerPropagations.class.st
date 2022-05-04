Class {
	#name : #AlbLayoutResizerPropagations,
	#superclass : #Object,
	#instVars : [
		'propagations',
		'propagationMap'
	],
	#category : #'Album-Brick-Core-Layout Resizer - I dnu'
}

{ #category : #'api - layout resizeable' }
AlbLayoutResizerPropagations class >> hAll [
	^ { self hFitContent . self hFitContentLimited . self hExact . self hMatchParent }
]

{ #category : #'api - layout resizeable' }
AlbLayoutResizerPropagations class >> hExact [
	^ AlbLayoutHorizontalResizerState exact
]

{ #category : #'api - layout resizeable' }
AlbLayoutResizerPropagations class >> hExact: aWidth [
	^ AlbLayoutHorizontalExactResizerPropagatedState new width: aWidth
]

{ #category : #'api - layout resizeable' }
AlbLayoutResizerPropagations class >> hFitContent [
	^ AlbLayoutHorizontalResizerState fitContent
]

{ #category : #'api - layout resizeable' }
AlbLayoutResizerPropagations class >> hFitContentLimited [
	^ AlbLayoutHorizontalResizerState fitContentLimited
]

{ #category : #'api - layout resizeable' }
AlbLayoutResizerPropagations class >> hMatchParent [
	^ AlbLayoutHorizontalResizerState matchParent
]

{ #category : #'api - layout resizeable' }
AlbLayoutResizerPropagations class >> vAll [
	^ { self vFitContent . self vFitContentLimited . self vExact . self vMatchParent }
]

{ #category : #'api - layout resizeable' }
AlbLayoutResizerPropagations class >> vExact [
	^ AlbLayoutVerticalResizerState exact
]

{ #category : #'api - layout resizeable' }
AlbLayoutResizerPropagations class >> vFitContent [
	^ AlbLayoutVerticalResizerState fitContent
]

{ #category : #'api - layout resizeable' }
AlbLayoutResizerPropagations class >> vFitContentLimited [
	^ AlbLayoutVerticalResizerState fitContentLimited
]

{ #category : #'api - layout resizeable' }
AlbLayoutResizerPropagations class >> vMatchParent [
	^ AlbLayoutVerticalResizerState matchParent
]

{ #category : #'adding / removing' }
AlbLayoutResizerPropagations >> addPropagation: aAlbLayoutResizerPropagation [
	propagations add: aAlbLayoutResizerPropagation
]

{ #category : #'private - insance creation' }
AlbLayoutResizerPropagations >> addPropagationFor: aChildOrCollectionOrBlock [
	<return: #AlbLayoutResizerPropagation>
	| aPropagation |

	self addPropagation: (aPropagation := self newPropagationFor: aChildOrCollectionOrBlock).
	^ aPropagation
]

{ #category : #'adding / removing' }
AlbLayoutResizerPropagations >> addPropagations: aAlbLayoutResizerPropagations [
	propagations addAll: aAlbLayoutResizerPropagations
]

{ #category : #'api - to fit content' }
AlbLayoutResizerPropagations >> anyToFitContent: aChildElementOrBlock [
	(self addPropagationFor: aChildElementOrBlock)
		fromAll: self class hAll
			to: self class hFitContent;
		fromAll: self class vAll
			to: self class vFitContent
]

{ #category : #accessing }
AlbLayoutResizerPropagations >> clearPropagationRules: aParentElement [
	propagationMap removeAll
]

{ #category : #accessing }
AlbLayoutResizerPropagations >> do: aBlock [
	propagations do: aBlock
]

{ #category : #'api - to match parent' }
AlbLayoutResizerPropagations >> exactToMatchParent: aChildElementOrBlock [
	(self addPropagationFor: aChildElementOrBlock)
		from: self class hExact
			to: self class hMatchParent;
		from: self class vExact
			to: self class vMatchParent
]

{ #category : #'api - to fit content limited' }
AlbLayoutResizerPropagations >> fitContentLimitedToFitContentLimited: aChildElementOrBlock [
	(self addPropagationFor: aChildElementOrBlock)
		from: self class hFitContentLimited
			to: self class hFitContentLimited;
		from: self class vFitContentLimited
			to: self class vFitContentLimited
]

{ #category : #'api - to fit content' }
AlbLayoutResizerPropagations >> fitContentToFitContent: aChildElementOrBlock [
	(self addPropagationFor: aChildElementOrBlock)
		from: self class hFitContent
			to: self class hFitContent;
		from: self class vFitContent
			to: self class vFitContent
]

{ #category : #'api - to fit content' }
AlbLayoutResizerPropagations >> hAnyToFitContent: aChildElementOrBlock [
	(self addPropagationFor: aChildElementOrBlock)
		fromAll: self class hAll
		to: self class hFitContent
]

{ #category : #'api - to fit content limited' }
AlbLayoutResizerPropagations >> hAnyToFitContentLimited: aChildElementOrBlock [
	(self addPropagationFor: aChildElementOrBlock)
		fromAll: self class hAll
		to: self class hFitContentLimited
]

{ #category : #'api - to match parent' }
AlbLayoutResizerPropagations >> hAnyToMatchParent: aChildElementOrBlock [
	(self addPropagationFor: aChildElementOrBlock)
		fromAll: self class hAll
		to: self class hMatchParent
]

{ #category : #'api - to fit content' }
AlbLayoutResizerPropagations >> hExactToFitContent: aChildElementOrBlock [
	(self addPropagationFor: aChildElementOrBlock)
		from: self class hExact
		to: self class hFitContent
]

{ #category : #'api - to fit content limited' }
AlbLayoutResizerPropagations >> hExactToFitContentLimited: aChildElementOrBlock [
	(self addPropagationFor: aChildElementOrBlock)
		from: self class hExact
		to: self class hFitContentLimited
]

{ #category : #'api - to match parent' }
AlbLayoutResizerPropagations >> hExactToMatchParent: aChildElementOrBlock [
	(self addPropagationFor: aChildElementOrBlock)
		from: self class hExact
		to: self class hMatchParent
]

{ #category : #'api - to match parent' }
AlbLayoutResizerPropagations >> hFitContent: aChildElementOrBlock toExact: aWidth [
	(self addPropagationFor: aChildElementOrBlock)
		from: self class hFitContent
		to: (self class hExact: aWidth)
]

{ #category : #'api - to fit content' }
AlbLayoutResizerPropagations >> hFitContentLimitedToFitContent: aChildElementOrBlock [
	(self addPropagationFor: aChildElementOrBlock)
		from: self class hFitContentLimited
		to: self class hFitContent
]

{ #category : #'api - to fit content limited' }
AlbLayoutResizerPropagations >> hFitContentLimitedToFitContentLimited: aChildElementOrBlock [
	(self addPropagationFor: aChildElementOrBlock)
		from: self class hFitContentLimited
		to: self class hFitContentLimited
]

{ #category : #'api - to match parent' }
AlbLayoutResizerPropagations >> hFitContentLimitedToMatchParent: aChildElementOrBlock [
	(self addPropagationFor: aChildElementOrBlock)
		from: self class hFitContentLimited
		to: self class hMatchParent
]

{ #category : #'api - to fit content' }
AlbLayoutResizerPropagations >> hFitContentToFitContent: aChildElementOrBlock [
	(self addPropagationFor: aChildElementOrBlock)
		from: self class hFitContent
		to: self class hFitContent
]

{ #category : #'api - to fit content limited' }
AlbLayoutResizerPropagations >> hFitContentToFitContentLimited: aChildElementOrBlock [
	(self addPropagationFor: aChildElementOrBlock)
		from: self class hFitContent
		to: self class hFitContentLimited
]

{ #category : #'api - to match parent' }
AlbLayoutResizerPropagations >> hFitContentToMatchParent: aChildElementOrBlock [
	(self addPropagationFor: aChildElementOrBlock)
		from: self class hFitContent
		to: self class hMatchParent
]

{ #category : #'api - inherit' }
AlbLayoutResizerPropagations >> hInherit: aChildElementOrBlock [
	(self addPropagationFor: aChildElementOrBlock)
		from: self class hExact
			to: self class hMatchParent;
		from: self class hFitContent
			to: self class hFitContent;
		from: self class hFitContentLimited
			to: self class hFitContentLimited;
		from: self class hMatchParent
			to: self class hMatchParent
]

{ #category : #'api - to match parent' }
AlbLayoutResizerPropagations >> hMatchParent: aChildElementOrBlock toExact: aWidth [
	(self addPropagationFor: aChildElementOrBlock)
		from: self class hMatchParent
		to: (self class hExact: aWidth)
]

{ #category : #'api - to fit content' }
AlbLayoutResizerPropagations >> hMatchParentToFitContent: aChildElementOrBlock [
	(self addPropagationFor: aChildElementOrBlock)
		from: self class hMatchParent
		to: self class hFitContent
]

{ #category : #'api - to fit content limited' }
AlbLayoutResizerPropagations >> hMatchParentToFitContentLimited: aChildElementOrBlock [
	(self addPropagationFor: aChildElementOrBlock)
		from: self class hFitContentLimited
		to: self class hFitContentLimited
]

{ #category : #'api - to match parent' }
AlbLayoutResizerPropagations >> hMatchParentToMatchParent: aChildElementOrBlock [
	(self addPropagationFor: aChildElementOrBlock)
		from: self class hMatchParent
		to: self class hMatchParent
]

{ #category : #'api - inherit' }
AlbLayoutResizerPropagations >> inherit: aChildElementOrBlock [
	(self addPropagationFor: aChildElementOrBlock)
		from: self class hExact
			to: self class hMatchParent;
		from: self class hFitContent
			to: self class hFitContent;
		from: self class hFitContentLimited
			to: self class hFitContentLimited;
		from: self class hMatchParent
			to: self class hMatchParent;
		from: self class vExact
			to: self class vMatchParent;
		from: self class vFitContent
			to: self class vFitContent;
		from: self class vFitContentLimited
			to: self class vFitContentLimited;
		from: self class vMatchParent
			to: self class vMatchParent
]

{ #category : #initialization }
AlbLayoutResizerPropagations >> initialize [
	super initialize.
	
	propagations := OrderedCollection new.
	propagationMap := IdentityDictionary new
]

{ #category : #'api - to match parent' }
AlbLayoutResizerPropagations >> matchParentToMatchParent: aChildElementOrBlock [
	(self addPropagationFor: aChildElementOrBlock)
		from: self class hMatchParent
			to: self class hMatchParent;
		from: self class vMatchParent
			to: self class vMatchParent
]

{ #category : #'private - insance creation' }
AlbLayoutResizerPropagations >> newPropagationFor: aChildOrCollectionOrBlock [
	<return: #AlbLayoutResizerPropagation>

	aChildOrCollectionOrBlock isBlock
		ifTrue: [ ^ AlbLayoutResizerDynamicPropagation new childrenBlock: aChildOrCollectionOrBlock ].

	aChildOrCollectionOrBlock isCollection
		ifTrue: [ ^ AlbLayoutResizerChildrenPropagation new childrenElements: aChildOrCollectionOrBlock ].

	(aChildOrCollectionOrBlock respondsTo: #asBlocElementId)
		ifTrue: [ ^ AlbLayoutResizerChildByIdPropagation new childId: aChildOrCollectionOrBlock ].

	^ AlbLayoutResizerChildPropagation new childElement: aChildOrCollectionOrBlock
]

{ #category : #accessing }
AlbLayoutResizerPropagations >> precomputePropagationRules: aParentElement [
	propagationMap
		ifNotEmpty: [ ^ self ].

	propagationMap removeAll.

	propagations do: [ :eachPropagation |
		eachPropagation
			childrenToPropagateFrom: aParentElement
			do: [ :eachChildElement |
				| eachPropagationMap |

				eachPropagationMap := propagationMap
					at: eachChildElement
					ifAbsentPut: [ Dictionary new ].
					
				eachPropagation propagationAssociations do: [ :eachAssociation |
					eachPropagationMap at: eachAssociation key put: eachAssociation value ] ] ]
]

{ #category : #accessing }
AlbLayoutResizerPropagations >> propagateState: aAlbLayoutResizerState from: aParentElement to: aChildElement [

	^ propagationMap
		at: aChildElement
		ifPresent: [ :aPropagationMap |
			aPropagationMap
				at: aAlbLayoutResizerState asNotPropagated
				ifPresent: [ :aMappedState | aMappedState asPropagated ]
				ifAbsent: [ aAlbLayoutResizerState asNotPropagated ] ]
		ifAbsent: [ aAlbLayoutResizerState asNotPropagated ]
]

{ #category : #'adding / removing' }
AlbLayoutResizerPropagations >> removePropagation: aAlbLayoutResizerPropagation [
	propagations remove: aAlbLayoutResizerPropagation ifAbsent: [  ]
]

{ #category : #'adding / removing' }
AlbLayoutResizerPropagations >> removePropagations: aAlbLayoutResizerPropagations [
	propagations removeAll: aAlbLayoutResizerPropagations
]

{ #category : #'api - to fit content' }
AlbLayoutResizerPropagations >> vAnyToFitContent: aChildElementOrBlock [
	(self addPropagationFor: aChildElementOrBlock)
		fromAll: self class vAll
		to: self class vFitContent
]

{ #category : #'api - to fit content limited' }
AlbLayoutResizerPropagations >> vAnyToFitContentLimited: aChildElementOrBlock [
	(self addPropagationFor: aChildElementOrBlock)
		fromAll: self class vAll
		to: self class vFitContentLimited
]

{ #category : #'api - to match parent' }
AlbLayoutResizerPropagations >> vAnyToMatchParent: aChildElementOrBlock [
	(self addPropagationFor: aChildElementOrBlock)
		fromAll: self class vAll
		to: self class vMatchParent
]

{ #category : #'api - to fit content' }
AlbLayoutResizerPropagations >> vExactToFitContent: aChildElementOrBlock [
	(self addPropagationFor: aChildElementOrBlock)
		from: self class vExact
		to: self class vFitContent
]

{ #category : #'api - to fit content limited' }
AlbLayoutResizerPropagations >> vExactToFitContentLimited: aChildElementOrBlock [
	(self addPropagationFor: aChildElementOrBlock)
		from: self class vExact
		to: self class vFitContentLimited
]

{ #category : #'api - to match parent' }
AlbLayoutResizerPropagations >> vExactToMatchParent: aChildElementOrBlock [
	(self addPropagationFor: aChildElementOrBlock)
		from: self class vExact
		to: self class vMatchParent
]

{ #category : #'api - to fit content' }
AlbLayoutResizerPropagations >> vFitContentLimitedToFitContent: aChildElementOrBlock [
	(self addPropagationFor: aChildElementOrBlock)
		from: self class vFitContentLimited
		to: self class vFitContent
]

{ #category : #'api - to fit content limited' }
AlbLayoutResizerPropagations >> vFitContentLimitedToFitContentLimited: aChildElementOrBlock [
	(self addPropagationFor: aChildElementOrBlock)
		from: self class vFitContentLimited
		to: self class vFitContentLimited
]

{ #category : #'api - to match parent' }
AlbLayoutResizerPropagations >> vFitContentLimitedToMatchParent: aChildElementOrBlock [
	(self addPropagationFor: aChildElementOrBlock)
		from: self class vFitContentLimited
		to: self class vMatchParent
]

{ #category : #'api - to fit content' }
AlbLayoutResizerPropagations >> vFitContentToFitContent: aChildElementOrBlock [
	(self addPropagationFor: aChildElementOrBlock)
		from: self class vFitContent
		to: self class vFitContent
]

{ #category : #'api - to fit content limited' }
AlbLayoutResizerPropagations >> vFitContentToFitContentLimited: aChildElementOrBlock [
	(self addPropagationFor: aChildElementOrBlock)
		from: self class vFitContent
		to: self class vFitContentLimited
]

{ #category : #'api - to match parent' }
AlbLayoutResizerPropagations >> vFitContentToMatchParent: aChildElementOrBlock [
	(self addPropagationFor: aChildElementOrBlock)
		from: self class vFitContent
		to: self class vMatchParent
]

{ #category : #'api - inherit' }
AlbLayoutResizerPropagations >> vInherit: aChildElementOrBlock [
	(self addPropagationFor: aChildElementOrBlock)
		from: self class vExact
			to: self class vMatchParent;
		from: self class vFitContent
			to: self class vFitContent;
		from: self class vFitContentLimited
			to: self class vFitContentLimited;
		from: self class vMatchParent
			to: self class vMatchParent
]

{ #category : #'api - to fit content' }
AlbLayoutResizerPropagations >> vMatchParentToFitContent: aChildElementOrBlock [
	(self addPropagationFor: aChildElementOrBlock)
		from: self class vMatchParent
		to: self class vFitContent
]

{ #category : #'api - to fit content limited' }
AlbLayoutResizerPropagations >> vMatchParentToFitContentLimited: aChildElementOrBlock [
	(self addPropagationFor: aChildElementOrBlock)
		from: self class vFitContentLimited
		to: self class vFitContentLimited
]

{ #category : #'api - to match parent' }
AlbLayoutResizerPropagations >> vMatchParentToMatchParent: aChildElementOrBlock [
	(self addPropagationFor: aChildElementOrBlock)
		from: self class vMatchParent
		to: self class vMatchParent
]
