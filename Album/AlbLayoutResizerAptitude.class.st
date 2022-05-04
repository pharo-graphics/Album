Class {
	#name : #AlbLayoutResizerAptitude,
	#superclass : #AlbStyleAptitude,
	#instVars : [
		'propagations'
	],
	#category : #'Album-Brick-Core-Layout Resizer - I dnu'
}

{ #category : #'api - style' }
AlbLayoutResizerAptitude class >> inherit [
	^ self new inherit
]

{ #category : #'api - to fit content' }
AlbLayoutResizerAptitude >> anyToFitContent [
	"Always fit content irrelevant from what model says"

	self
		hAnyToFitContent;
		vAnyToFitContent
]

{ #category : #'api - to fit content element' }
AlbLayoutResizerAptitude >> anyToFitContent: aChildElementOrBlock [
	"Always fit content vertically and horizontally irrelevant from what model says"

	propagations anyToFitContent: aChildElementOrBlock
]

{ #category : #'api - style' }
AlbLayoutResizerAptitude >> exactDo: aBlock [
	aBlock value: (self styleFor: (AlbLayoutHorizontalResizerState exact and: AlbLayoutVerticalResizerState exact))
]

{ #category : #'api - to fit content' }
AlbLayoutResizerAptitude >> exactToFitContent [
	self hExactToFitContent.
	self vExactToFitContent
]

{ #category : #'api - to match parent element' }
AlbLayoutResizerAptitude >> exactToMatchParent: aChildElementOrBlock [
	propagations exactToMatchParent: aChildElementOrBlock
]

{ #category : #'api - style' }
AlbLayoutResizerAptitude >> fitContentDo: aBlock [
	aBlock value: (self styleFor: (AlbLayoutHorizontalResizerState fitContent and: AlbLayoutVerticalResizerState fitContent))
]

{ #category : #'api - to fit content limited element' }
AlbLayoutResizerAptitude >> fitContentLimitedToFitContentLimited: aChildElementOrBlock [
	"Inherit fit content limited in both directions if model says so"
		
	propagations fitContentLimitedToFitContentLimited: aChildElementOrBlock
]

{ #category : #'api - to fit content' }
AlbLayoutResizerAptitude >> fitContentToFitContent [
	self hFitContentToFitContent.
	self vFitContentToFitContent
]

{ #category : #'api - to fit content element' }
AlbLayoutResizerAptitude >> fitContentToFitContent: aChildElementOrBlock [
	"Inherit fit content in both directions if model says so"
	
	propagations fitContentToFitContent: aChildElementOrBlock
]

{ #category : #'api - style' }
AlbLayoutResizerAptitude >> hAny [
	^ self styleFor: AlbLayoutHorizontalResizerState any
]

{ #category : #'api - to fit content' }
AlbLayoutResizerAptitude >> hAnyToFitContent [
	"Always fit content horizontally irrelevant from what model says"

	self hAny hFitContent
]

{ #category : #'api - to fit content element' }
AlbLayoutResizerAptitude >> hAnyToFitContent: aChildElementOrBlock [
	"Always fit content horizontally irrelevant from what model says"

	propagations hAnyToFitContent: aChildElementOrBlock
]

{ #category : #'api - to match parent' }
AlbLayoutResizerAptitude >> hAnyToMatchParent [
	"Always match parent horizontally irrelevant from what model says"

	self hAny hMatchParent
]

{ #category : #'api - to match parent element' }
AlbLayoutResizerAptitude >> hAnyToMatchParent: aChildElementOrBlock [
	"Match parent horizontally"

	propagations hAnyToMatchParent: aChildElementOrBlock
]

{ #category : #'api - style' }
AlbLayoutResizerAptitude >> hExact [
	^ self styleFor: AlbLayoutHorizontalResizerState exact
]

{ #category : #'api - style' }
AlbLayoutResizerAptitude >> hExactDo: aBlock [
	aBlock value: self hExact
]

{ #category : #'api - to fit content' }
AlbLayoutResizerAptitude >> hExactToFitContent [
	"Fit content if model specifies exact size horizontally"

	self hExact hFitContent
]

{ #category : #'api - to fit content element' }
AlbLayoutResizerAptitude >> hExactToFitContent: aChildElementOrBlock [
	"Fit content horizontally if model says to be exact size"	

	propagations hExactToFitContent: aChildElementOrBlock
]

{ #category : #'api - to match parent' }
AlbLayoutResizerAptitude >> hExactToMatchParent [
	"Match parent if model specifies exact size horizontally"

	self hExact hMatchParent
]

{ #category : #'api - to match parent element' }
AlbLayoutResizerAptitude >> hExactToMatchParent: aChildElementOrBlock [
	"Match parent if model specifies exact size horizontally"

	propagations hExactToMatchParent: aChildElementOrBlock
]

{ #category : #'api - style' }
AlbLayoutResizerAptitude >> hFitContent [
	^ self styleFor: AlbLayoutHorizontalResizerState fitContent
]

{ #category : #'api - style' }
AlbLayoutResizerAptitude >> hFitContentLimited [
	^ self styleFor: AlbLayoutHorizontalResizerState fitContentLimited
]

{ #category : #'api - to fit content' }
AlbLayoutResizerAptitude >> hFitContentLimitedToFitContent [
	"Fit content if model specifies fit content limited horizontally"

	self hFitContentLimited hFitContent
]

{ #category : #'api - to fit content limited' }
AlbLayoutResizerAptitude >> hFitContentLimitedToFitContentLimited [
	"Inherit fit content limited horizontally if model says so"

	self hFitContentLimited hFitContentLimited
]

{ #category : #'api - to fit content limited element' }
AlbLayoutResizerAptitude >> hFitContentLimitedToFitContentLimited: aChildElementOrBlock [
	"Inherit fit content limited horizontally if model says so"

	propagations hFitContentLimitedToFitContentLimited: aChildElementOrBlock
]

{ #category : #'api - to fit content' }
AlbLayoutResizerAptitude >> hFitContentToFitContent [
	"Inherit fit content horizontally if model says so"

	self hFitContent hFitContent
]

{ #category : #'api - to fit content element' }
AlbLayoutResizerAptitude >> hFitContentToFitContent: aChildElementOrBlock [
	"Inherit fit content horizontally if model says so"
		
	propagations hFitContentToFitContent: aChildElementOrBlock
]

{ #category : #'api - to match parent' }
AlbLayoutResizerAptitude >> hFitContentToMatchParent [
	"Match parent if model specifies fit content horizontally"

	self hFitContent hMatchParent
]

{ #category : #'api - inherit' }
AlbLayoutResizerAptitude >> hInherit [
	self
		hMatchParentToMatchParent;
		hFitContentToFitContent;
		hFitContentLimitedToFitContentLimited
]

{ #category : #'api - inherit' }
AlbLayoutResizerAptitude >> hInherit: aChildElementOrBlock [
	propagations hInherit: aChildElementOrBlock
]

{ #category : #'api - style' }
AlbLayoutResizerAptitude >> hMatchParent [
	^ self styleFor: AlbLayoutHorizontalResizerState matchParent
]

{ #category : #'api - to fit content' }
AlbLayoutResizerAptitude >> hMatchParentToFitContent [
	"Fit content if model specifies match parent parent horizontally"

	self hMatchParent hFitContent
]

{ #category : #'api - to fit content element' }
AlbLayoutResizerAptitude >> hMatchParentToFitContent: aChildElementOrBlock [
	"Fit content horizontally if model says match parent"

	propagations hMatchParentToFitContent: aChildElementOrBlock
]

{ #category : #'api - to match parent' }
AlbLayoutResizerAptitude >> hMatchParentToMatchParent [
	"Inherit match parent horizontally if model says so"

	self hMatchParent hMatchParent
]

{ #category : #'api - to match parent element' }
AlbLayoutResizerAptitude >> hMatchParentToMatchParent: aChildElementOrBlock [
	"Match parent if model specifies match parent horizontally"

	propagations hMatchParentToMatchParent: aChildElementOrBlock
]

{ #category : #'api - inherit' }
AlbLayoutResizerAptitude >> inherit [
	self hInherit.
	self vInherit.

]

{ #category : #'api - inherit' }
AlbLayoutResizerAptitude >> inherit: aChildElementOrBlock [
	propagations inherit: aChildElementOrBlock
]

{ #category : #initialization }
AlbLayoutResizerAptitude >> initialize [
	super initialize.

	propagations := AlbLayoutResizerPropagations new.

	self addChange:
		(AlbLookChange new
			up: [ :thisLook | thisLook widget layoutResizerPropagations addPropagations: propagations ];
			down: [ :thisLook | thisLook widget layoutResizerPropagations removePropagations: propagations ];
			yourself)
]

{ #category : #'api - style' }
AlbLayoutResizerAptitude >> matchParentDo: aBlock [
	aBlock value: (self styleFor: (AlbLayoutHorizontalResizerState matchParent and: AlbLayoutVerticalResizerState matchParent))
]

{ #category : #'api - to match parent element' }
AlbLayoutResizerAptitude >> matchParentToMatchParent: aChildElementOrBlock [
	"Match parent if model specifies match parent in both dimensions"

	propagations matchParentToMatchParent: aChildElementOrBlock
]

{ #category : #'api - style' }
AlbLayoutResizerAptitude >> vAny [
	^ self styleFor: AlbLayoutVerticalResizerState any
]

{ #category : #'api - to fit content' }
AlbLayoutResizerAptitude >> vAnyToFitContent [
	"Always fit content vertically irrelevant from what model says"

	self vAny vFitContent
]

{ #category : #'api - to fit content element' }
AlbLayoutResizerAptitude >> vAnyToFitContent: aChildElementOrBlock [
	"Always fit content vertically irrelevant from what model says"

	propagations vAnyToFitContent: aChildElementOrBlock
]

{ #category : #'api - style' }
AlbLayoutResizerAptitude >> vExact [
	^ self styleFor: AlbLayoutVerticalResizerState exact
]

{ #category : #'api - style' }
AlbLayoutResizerAptitude >> vExactDo: aBlock [
	aBlock value: self vExact
]

{ #category : #'api - to fit content' }
AlbLayoutResizerAptitude >> vExactToFitContent [
	"Fit content if model specifies exact size vertically"

	self vExact vFitContent
]

{ #category : #'api - to fit content element' }
AlbLayoutResizerAptitude >> vExactToFitContent: aChildElementOrBlock [
	"Fit content vertically if model says to be exact size"	

	propagations vExactToFitContent: aChildElementOrBlock
]

{ #category : #'api - to match parent' }
AlbLayoutResizerAptitude >> vExactToMatchParent [
	"Match parent if model specifies exact size vertically"

	self vExact vMatchParent
]

{ #category : #'api - to match parent element' }
AlbLayoutResizerAptitude >> vExactToMatchParent: aChildElementOrBlock [
	"Match parent if model specifies exact size horizontally"

	propagations vExactToMatchParent: aChildElementOrBlock
]

{ #category : #'api - style' }
AlbLayoutResizerAptitude >> vFitContent [
	^ self styleFor: AlbLayoutVerticalResizerState fitContent
]

{ #category : #'api - style' }
AlbLayoutResizerAptitude >> vFitContentLimited [
	^ self styleFor: AlbLayoutVerticalResizerState fitContentLimited
]

{ #category : #'api - to fit content' }
AlbLayoutResizerAptitude >> vFitContentLimitedToFitContent [
	"Fit content if model specifies fit content limited vertically"

	self vFitContentLimited vFitContent
]

{ #category : #'api - to fit content limited' }
AlbLayoutResizerAptitude >> vFitContentLimitedToFitContentLimited [
	"Inherit fit content limited horizontally if model says so"

	self vFitContentLimited vFitContentLimited
]

{ #category : #'api - to fit content limited element' }
AlbLayoutResizerAptitude >> vFitContentLimitedToFitContentLimited: aChildElementOrBlock [
	"Inherit fit content limited vertically if model says so"
		
	propagations vFitContentLimitedToFitContentLimited: aChildElementOrBlock
]

{ #category : #'api - to fit content' }
AlbLayoutResizerAptitude >> vFitContentToFitContent [
	"Fit content if model specifies fit content vertically"

	self vFitContent vFitContent
]

{ #category : #'api - to fit content element' }
AlbLayoutResizerAptitude >> vFitContentToFitContent: aChildElementOrBlock [
	"Inherit fit content vertically if model says so"
		
	propagations vFitContentToFitContent: aChildElementOrBlock
]

{ #category : #'api - to match parent' }
AlbLayoutResizerAptitude >> vFitContentToMatchParent [
	"Match parent if model specifies fit content vertically"

	self vFitContent vMatchParent
]

{ #category : #'api - inherit' }
AlbLayoutResizerAptitude >> vInherit [
	self
		vMatchParentToMatchParent;
		vFitContentToFitContent;
		vFitContentLimitedToFitContentLimited
]

{ #category : #'api - inherit' }
AlbLayoutResizerAptitude >> vInherit: aChildElementOrBlock [
	propagations vInherit: aChildElementOrBlock
]

{ #category : #'api - style' }
AlbLayoutResizerAptitude >> vMatchParent [
	^ self styleFor: AlbLayoutVerticalResizerState matchParent
]

{ #category : #'api - to fit content' }
AlbLayoutResizerAptitude >> vMatchParentToFitContent [
	"Fit content if model specifies match parent parent vertically"

	self vMatchParent vFitContent
]

{ #category : #'api - to fit content element' }
AlbLayoutResizerAptitude >> vMatchParentToFitContent: aChildElementOrBlock [
	"Fit content vertically if model says match parent"
	
	propagations vMatchParentToFitContent: aChildElementOrBlock
]

{ #category : #'api - to match parent' }
AlbLayoutResizerAptitude >> vMatchParentToMatchParent [
	"Inherit match parent vertical if model says so"

	self vMatchParent vMatchParent
]

{ #category : #'api - to match parent element' }
AlbLayoutResizerAptitude >> vMatchParentToMatchParent: aChildElementOrBlock [
	"Match parent if model specifies match parent vertically"

	propagations vMatchParentToMatchParent: aChildElementOrBlock
]
