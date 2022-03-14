Class {
	#name : #AlbTriangleAptitude,
	#superclass : #AlbAptitude,
	#instVars : [
		'isExpanded',
		'collapsedStencil',
		'expandedStencil',
		'collapsedTriangle',
		'expandedTriangle'
	],
	#category : #'Album-Brick-Triangle-Look'
}

{ #category : #'api - expandable' }
AlbTriangleAptitude >> collapse [
	self isExpanded ifFalse: [ ^ self ].
	isExpanded := false.
	self updateVisibleTriangle.
]

{ #category : #'private - ui' }
AlbTriangleAptitude >> collapseWidget: aWidget [
	self collapsedTriangle removeFromParent.
	self expandedTriangle removeFromParent.
	self widgetContent addChild: self collapsedTriangle as: #triangle.
	isExpanded := false.
]

{ #category : #accessing }
AlbTriangleAptitude >> collapsedStencil [
	^ collapsedStencil
]

{ #category : #accessing }
AlbTriangleAptitude >> collapsedStencil: aStencil [
	collapsedStencil := aStencil.
	collapsedTriangle ifNotNil: [ :aTriangle | aTriangle removeFromParent ].
	collapsedTriangle := nil.
	self updateVisibleTriangle.
]

{ #category : #accessing }
AlbTriangleAptitude >> collapsedTriangle [
	collapsedTriangle ifNil: [ 
		collapsedTriangle := self collapsedStencil asElement.
		self initializeTriangle: collapsedTriangle ].
	^ collapsedTriangle.
]

{ #category : #defaults }
AlbTriangleAptitude >> defaultCollapsedStencil [
	^ BrCollapsedTriangleStencil new
]

{ #category : #defaults }
AlbTriangleAptitude >> defaultExpandedStencil [
	^ BrExpandedTriangleStencil new
]

{ #category : #'api - expandable' }
AlbTriangleAptitude >> expand [
	self isExpanded ifTrue: [ ^ self ].
	isExpanded := true.
	self updateVisibleTriangle.
]

{ #category : #'private - ui' }
AlbTriangleAptitude >> expandWidget: aWidget [
	self collapsedTriangle removeFromParent.
	self expandedTriangle removeFromParent.
	self widgetContent addChild: self expandedTriangle as: #triangle.
	isExpanded := true
]

{ #category : #accessing }
AlbTriangleAptitude >> expandedStencil [
	^ expandedStencil
]

{ #category : #accessing }
AlbTriangleAptitude >> expandedStencil: aStencil [
	expandedStencil := aStencil.
	expandedTriangle ifNotNil: [ :aTriangle | aTriangle removeFromParent ].
	expandedTriangle := nil.
	self updateVisibleTriangle.
]

{ #category : #accessing }
AlbTriangleAptitude >> expandedTriangle [
	expandedTriangle ifNil: [ 
		expandedTriangle := self expandedStencil asElement.
		self initializeTriangle: expandedTriangle ].
	^ expandedTriangle.
]

{ #category : #initialization }
AlbTriangleAptitude >> initialize [
	super initialize.
	
	isExpanded := false.
	
	collapsedStencil := self defaultCollapsedStencil.
	expandedStencil := self defaultExpandedStencil.
	
	self 
		addChangeAddChildAs: #(content triangle) 
		with: [ self triangle ]
]

{ #category : #initialization }
AlbTriangleAptitude >> initializeListeners [
	super initializeListeners.
	
	self when: BrTriangleStencilsChanged do: [ :anEvent | self onStencilsChanged: anEvent ].
	self when: BrExpandedEvent do: [ :anEvent | self expandWidget: self widget ].
	self when: BrCollapsedEvent do: [ :anEvent | self collapseWidget: self widget ]
]

{ #category : #initialization }
AlbTriangleAptitude >> initializeRequests [
	super initializeRequests.
	
	self request: BrTriangleStencilsRequest new.
]

{ #category : #initialization }
AlbTriangleAptitude >> initializeTriangle: aTriangle [
	"subclasses may configure collapsed and expanded triangle elements"
]

{ #category : #'api - expandable' }
AlbTriangleAptitude >> isExpanded [
	<return: #Boolean>
	^ isExpanded
]

{ #category : #hooks }
AlbTriangleAptitude >> onStencilsChanged: anEvent [
	self collapsedStencil: anEvent collapsedStencil.
	self expandedStencil: anEvent expandedStencil.
]

{ #category : #'api - expandable' }
AlbTriangleAptitude >> toggle [
	isExpanded := isExpanded not.
	self updateVisibleTriangle.
]

{ #category : #accessing }
AlbTriangleAptitude >> triangle [
	^ self isExpanded 
		ifTrue: [ self expandedTriangle ]
		ifFalse: [ self collapsedTriangle ] 
]

{ #category : #'private - ui' }
AlbTriangleAptitude >> updateVisibleTriangle [
	self widgetDo: [ :aWidget |
		self isExpanded 
			ifTrue: [ self expandWidget: aWidget ]
			ifFalse: [ self collapseWidget: aWidget ] ]
]
