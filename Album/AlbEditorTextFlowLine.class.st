Class {
	#name : #AlbEditorTextFlowLine,
	#superclass : #Object,
	#instVars : [
		'elements',
		'maxWidth',
		'availableWidth',
		'nextLine',
		'width',
		'height',
		'pushedQueue',
		'origin',
		'baseline'
	],
	#category : #'Album-Layout'
}

{ #category : #adding }
AlbEditorTextFlowLine >> add: anElement [
	"Try to assign a given element to this line (if possible) or create a new line.
	Return a line to which next element should be tried to added"
	<return: #AlbEditorTextFlowLine>
	| currentLine textFlow |

	textFlow := 	anElement constraints at: AlbEditorTextFlowLayout.
	textFlow shouldPushLine
		ifTrue: [
			pushedQueue addLast: anElement.
			^ self ].
	
	currentLine := ((self hasSpaceFor: anElement) and: [ textFlow shouldBreakLineBefore not ])
		ifTrue: [ self push: anElement ]
		ifFalse: [ self nextLine push: anElement ].
		
	^ textFlow shouldBreakLineAfter
		ifTrue: [ currentLine nextLine ]
		ifFalse: [ currentLine ]
]

{ #category : #accessing }
AlbEditorTextFlowLine >> baseline [
	^ baseline
]

{ #category : #accessing }
AlbEditorTextFlowLine >> count [
	"Return how many lines there are in total"
	<return: #Number>
	
	^ 1 + (self hasNextLine
		ifTrue: [ self nextLine count ]
		ifFalse: [ 0 ])
]

{ #category : #geometry }
AlbEditorTextFlowLine >> distanceTo: aPoint [
	"Compute the vertical distance from me to a given point"
	<return: #Number>
	| aClampedCoordinate |
	
	aClampedCoordinate := (aPoint y min: (self origin y + self height)) max: self origin y.
	
	^ (aPoint y - aClampedCoordinate) abs
]

{ #category : #enumerating }
AlbEditorTextFlowLine >> do: aBlock [
	"Evaluate aBlock with each of my next lines as the argument"

	aBlock value: self.
	self hasNextLine
		ifTrue: [ nextLine do: aBlock ]
]

{ #category : #accessing }
AlbEditorTextFlowLine >> elements [
	"Return a collection of all elements assigned to this line"
	<return: #OrderedCollection>

	^ elements
]

{ #category : #accessing }
AlbEditorTextFlowLine >> elementsIn: anElement [
	"Return a collection of all elements assigned to this line"
	<return: #OrderedCollection>

	^ elements ifNil: [ elements := anElement children select: [ :eachChild | eachChild constraints textFlow assignedLine = self ] ]
]

{ #category : #geometry }
AlbEditorTextFlowLine >> findClosestChildOf: anElement to: aPoint [
	<return: #BlElement>
	
	"use cached elements"
	elements
		ifNotNil: [ ^ self findClosestElementTo: aPoint in: elements ].
	
	"otherwise compute based on the assigned line"
	^ self
		findClosestElementTo: aPoint
		in: (anElement children select: [ :eachChild | eachChild constraints textFlow assignedLine = self ])
]

{ #category : #geometry }
AlbEditorTextFlowLine >> findClosestElementTo: aPoint in: aCollectionOfElements [
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
AlbEditorTextFlowLine >> hasNextLine [
	"Return true if there is a next line, false otherwise"
	<return: #Boolean>
	
	^ nextLine isNotNil
]

{ #category : #testing }
AlbEditorTextFlowLine >> hasSpaceFor: anElement [
	"Return true if I am able to provide space for a given element.
	By convention I always allow element to take space if I am empty
	regardless of actual available space"
	<return: #Boolean>
	
	^ self isEmpty or: [
		| aChildWidth |
		
		aChildWidth := anElement measuredWidth + anElement margin width.
		
		"we can not directly return the comparison, because it is possible that available width
		is very very close but slightly less than (by a thousand of a pixel) the child's measured width."
		availableWidth >= aChildWidth
			ifTrue: [ true ]
			ifFalse: [ availableWidth closeTo: aChildWidth epsilon: 0.5 ] ]
]

{ #category : #geometry }
AlbEditorTextFlowLine >> height [
	"Return my height which is equal to the height of the highest element"
	<return: #Number>

	^ height
]

{ #category : #initialization }
AlbEditorTextFlowLine >> initialize [
	super initialize.
	
	maxWidth := Float infinity.
	width := 0.
	height := 0.
	origin := 0@0.
	baseline := 0.
	availableWidth := maxWidth.

	elements := OrderedCollection new.
	pushedQueue := LinkedList new.

	nextLine := nil
]

{ #category : #testing }
AlbEditorTextFlowLine >> isEmpty [
	"Return true if I am an empty line without any element, false otherwise"
	<return: #Boolean>

	^ elements isEmpty
]

{ #category : #accessing }
AlbEditorTextFlowLine >> maxWidth [
	"Return maximal width limit for the current line"
	<return: #Number>

	^ maxWidth
]

{ #category : #accessing }
AlbEditorTextFlowLine >> maxWidth: aNumber [
	"Limit maximal width to the given number"

	maxWidth := aNumber.
	availableWidth := maxWidth - width
]

{ #category : #accessing }
AlbEditorTextFlowLine >> nextLine [
	"Return or create a new next line to which we should continue adding elements"
	<return: #AlbEditorTextFlowLine>

	^ nextLine ifNil: [
		nextLine := AlbEditorTextFlowLine new
			maxWidth: maxWidth;
			pushedQueue: pushedQueue;
			yourself ]
]

{ #category : #accessing }
AlbEditorTextFlowLine >> origin [
	<return: #Point>

	^ origin
]

{ #category : #accessing }
AlbEditorTextFlowLine >> origin: aPoint [
	origin := aPoint
]

{ #category : #private }
AlbEditorTextFlowLine >> push: anElement [
	"Push pushes given element to the end of element's collection
	and update my geometry properties taking new element into account "

	| textFlow |
	elements addLast: anElement.
	textFlow := anElement constraints at: AlbEditorTextFlowLayout.
	textFlow assignToLine: self.

	width := width + (anElement measuredWidth + anElement margin width).
	height := height max: (anElement measuredHeight + anElement margin height).
	availableWidth := maxWidth - width.
	
	baseline := baseline max: (anElement baselineOffset + anElement margin top)
]

{ #category : #accessing }
AlbEditorTextFlowLine >> pushedQueue [
	^ pushedQueue
]

{ #category : #accessing }
AlbEditorTextFlowLine >> pushedQueue: aQueue [
	pushedQueue := aQueue
]

{ #category : #initialization }
AlbEditorTextFlowLine >> reset [
	elements := nil.
	pushedQueue := nil.

	nextLine ifNotNil: [ :aNextLine | aNextLine reset ]
]

{ #category : #geometry }
AlbEditorTextFlowLine >> totalHeight [
	"Return a total height taking into account all next lines"
	<return: #Number>
	| aTotalHeight |
	
	aTotalHeight := self hasNextLine
		ifTrue: [ nextLine totalHeight ]
		ifFalse: [ 0 ].
	
	^ self height + aTotalHeight
]

{ #category : #geometry }
AlbEditorTextFlowLine >> totalWidth [
	"Return a total width taking into account all next lines"
	<return: #Number>
	| aTotalWidth |
	
	aTotalWidth := self hasNextLine
		ifTrue: [ nextLine totalWidth ]
		ifFalse: [ 0 ].
	
	^ self width max: aTotalWidth
]

{ #category : #geometry }
AlbEditorTextFlowLine >> width [
	"Return my width which is a sum of widths of all my elements"
	<return: #Number>

	^ width
]
