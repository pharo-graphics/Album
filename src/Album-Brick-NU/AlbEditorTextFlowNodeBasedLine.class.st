Class {
	#name : #AlbEditorTextFlowNodeBasedLine,
	#superclass : #Object,
	#instVars : [
		'nodes',
		'maxWidth',
		'availableWidth',
		'nextLine',
		'width',
		'height',
		'pushedQueue',
		'origin',
		'baseline'
	],
	#category : #'Album-Brick-NU-Layout'
}

{ #category : #adding }
AlbEditorTextFlowNodeBasedLine >> add: aLayoutNode [
	"Try to assign a given element to this line (if possible) or create a new line.
	Return a line to which next element should be tried to added"
	<return: #AlbFlowLine>
	| currentLine |
	
	aLayoutNode constraints albumTextFlow shouldPushLine
		ifTrue: [
			pushedQueue addLast: aLayoutNode.
			^ self ].
	
	currentLine := ((self hasSpaceFor: aLayoutNode) and: [ aLayoutNode constraints albumTextFlow shouldBreakLineBefore not ])
		ifTrue: [ self push: aLayoutNode ]
		ifFalse: [ self nextLine push: aLayoutNode ].
		
	^ aLayoutNode constraints albumTextFlow shouldBreakLineAfter
		ifTrue: [ currentLine nextLine ]
		ifFalse: [ currentLine ]
]

{ #category : #accessing }
AlbEditorTextFlowNodeBasedLine >> baseline [
	^ baseline
]

{ #category : #accessing }
AlbEditorTextFlowNodeBasedLine >> count [
	"Return how many lines there are in total"
	<return: #Number>
	
	^ 1 + (self hasNextLine
		ifTrue: [ self nextLine count ]
		ifFalse: [ 0 ])
]

{ #category : #geometry }
AlbEditorTextFlowNodeBasedLine >> distanceTo: aPoint [
	"Compute the vertical distance from me to a given point"
	<return: #Number>
	| aClampedCoordinate |
	
	aClampedCoordinate := (aPoint y min: (self origin y + self height)) max: self origin y.
	
	^ (aPoint y - aClampedCoordinate) abs
]

{ #category : #enumerating }
AlbEditorTextFlowNodeBasedLine >> do: aBlock [
	"Evaluate aBlock with each of my next lines as the argument"

	aBlock value: self.
	self hasNextLine
		ifTrue: [ nextLine do: aBlock ]
]

{ #category : #accessing }
AlbEditorTextFlowNodeBasedLine >> elements [
	"Return a collection of all elements assigned to this line"
	<return: #OrderedCollection>

	^ nodes
]

{ #category : #geometry }
AlbEditorTextFlowNodeBasedLine >> findClosestChildOf: anElement to: aPoint [
	<return: #BlElement>
	
	"otherwise compute based on the assigned line"
	^ self
		findClosestElementTo: aPoint
		in: (anElement children select: [ :eachChild | eachChild constraints albumTextFlow assignedLine = self ])
]

{ #category : #geometry }
AlbEditorTextFlowNodeBasedLine >> findClosestElementTo: aPoint in: aCollectionOfElements [
	<return: #BlElement>
	| aClosestElement aClosestDistance |
	
	aClosestElement := aCollectionOfElements first.
	aClosestDistance := aClosestElement distanceToX: aPoint.
	
	aCollectionOfElements do: [ :eachElement | 
		| eachDistance |
		
		eachDistance := eachElement distanceToX: aPoint.
		eachDistance < aClosestDistance
			ifTrue: [
				aClosestDistance := eachDistance.
				aClosestElement := eachElement ] ].

	^ aClosestElement
]

{ #category : #testing }
AlbEditorTextFlowNodeBasedLine >> hasNextLine [
	"Return true if there is a next line, false otherwise"
	<return: #Boolean>
	
	^ nextLine isNotNil
]

{ #category : #testing }
AlbEditorTextFlowNodeBasedLine >> hasSpaceFor: aLayoutNode [
	"Return true if I am able to provide space for a given layout node.
	By convention I always allow one node to take space if I am empty
	regardless of actual available space"
	<return: #Boolean>
	
	^ self isEmpty or: [
		| aChildWidth |

		aChildWidth := aLayoutNode width + aLayoutNode margin width.

		"we can not directly return the comparison, because it is possible that available width
		is very very close but slightly less than (by a thousand of a pixel) the child's measured width."
		availableWidth >= aChildWidth
			ifTrue: [ true ]
			ifFalse: [ availableWidth closeTo: aChildWidth epsilon: 0.5 ] ]
]

{ #category : #geometry }
AlbEditorTextFlowNodeBasedLine >> height [
	"Return my height which is equal to the height of the highest element"
	<return: #Number>

	^ height
]

{ #category : #initialization }
AlbEditorTextFlowNodeBasedLine >> initialize [
	super initialize.
	
	maxWidth := Float infinity.
	width := 0.
	height := 0.
	origin := 0@0.
	baseline := 0.
	availableWidth := maxWidth.

	nodes := OrderedCollection new.
	pushedQueue := LinkedList new.

	nextLine := nil
]

{ #category : #testing }
AlbEditorTextFlowNodeBasedLine >> isEmpty [
	"Return true if I am an empty line without any element, false otherwise"
	<return: #Boolean>

	^ nodes isEmpty
]

{ #category : #accessing }
AlbEditorTextFlowNodeBasedLine >> maxWidth [
	"Return maximal width limit for the current line"
	<return: #Number>

	^ maxWidth
]

{ #category : #accessing }
AlbEditorTextFlowNodeBasedLine >> maxWidth: aNumber [
	"Limit maximal width to the given number"

	maxWidth := aNumber.
	availableWidth := maxWidth - width
]

{ #category : #accessing }
AlbEditorTextFlowNodeBasedLine >> nextLine [
	"Return or create a new next line to which we should continue adding elements"
	<return: #AlbFlowLine>

	^ nextLine ifNil: [
		nextLine := AlbFlowLine new
			maxWidth: maxWidth;
			pushedQueue: pushedQueue;
			yourself ]
]

{ #category : #accessing }
AlbEditorTextFlowNodeBasedLine >> origin [
	<return: #Point>

	^ origin
]

{ #category : #accessing }
AlbEditorTextFlowNodeBasedLine >> origin: aPoint [
	origin := aPoint
]

{ #category : #private }
AlbEditorTextFlowNodeBasedLine >> push: aLayoutNode [
	"Push pushes given element to the end of element's collection
	and update my geometry properties taking new element into account "

	nodes addLast: aLayoutNode.
	aLayoutNode constraints albumTextFlow assignToLine: self.

	width := width + (aLayoutNode width + aLayoutNode margin width).
	height := height max: (aLayoutNode height + aLayoutNode margin height).
	availableWidth := maxWidth - width.
	
	baseline := baseline max: ("aLayoutNode baselineOffset + "aLayoutNode margin top)
]

{ #category : #accessing }
AlbEditorTextFlowNodeBasedLine >> pushedQueue [
	^ pushedQueue
]

{ #category : #accessing }
AlbEditorTextFlowNodeBasedLine >> pushedQueue: aQueue [
	pushedQueue := aQueue
]

{ #category : #geometry }
AlbEditorTextFlowNodeBasedLine >> totalHeight [
	"Return a total height taking into account all next lines"
	<return: #Number>
	| aTotalHeight |
	
	aTotalHeight := self hasNextLine
		ifTrue: [ nextLine totalHeight ]
		ifFalse: [ 0 ].
	
	^ self height + aTotalHeight
]

{ #category : #geometry }
AlbEditorTextFlowNodeBasedLine >> totalWidth [
	"Return a total width taking into account all next lines"
	<return: #Number>
	| aTotalWidth |
	
	aTotalWidth := self hasNextLine
		ifTrue: [ nextLine totalWidth ]
		ifFalse: [ 0 ].
	
	^ self width max: aTotalWidth
]

{ #category : #geometry }
AlbEditorTextFlowNodeBasedLine >> width [
	"Return my width which is a sum of widths of all my elements"
	<return: #Number>

	^ width
]
