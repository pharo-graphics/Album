"
I am special text flow layout constraints that add support line breaking and pushing which is very useful for embedding visual elements in moldable text editor.
"
Class {
	#name : #AlbLineFlowLayoutConstraints,
	#superclass : #BlLayoutConstraints,
	#instVars : [
		'pushLine',
		'breakLineBefore',
		'breakLineAfter',
		'assignedLine',
		'offsetFromSegmentStart',
		'positionInEditor'
	],
	#classVars : [
		'ShouldFillLine'
	],
	#category : #'Album-Layout'
}

{ #category : #asserting }
AlbLineFlowLayoutConstraints class >> shouldFillLine [
	"Return true if the element should fill all available space in the line if it is the last element"

	^ ShouldFillLine ifNil: [ ShouldFillLine := false ]
]

{ #category : #asserting }
AlbLineFlowLayoutConstraints class >> shouldFillLine: aBoolean [
	"true if the element should fill all available space in the line if it is the last element"

	ShouldFillLine := aBoolean
]

{ #category : #accessing }
AlbLineFlowLayoutConstraints >> assignToLine: aEditorTextFlowLine [
	assignedLine := aEditorTextFlowLine
]

{ #category : #accessing }
AlbLineFlowLayoutConstraints >> assignedLine [
	^ assignedLine
]

{ #category : #initialization }
AlbLineFlowLayoutConstraints >> breakLineAfter [
	"Mark an element such that a line should be broken AFTER it"

	breakLineAfter := true
]

{ #category : #initialization }
AlbLineFlowLayoutConstraints >> breakLineBefore [
	"Mark an element such that a line should be broken BEFORE it"

	breakLineBefore := true
]

{ #category : #initialization }
AlbLineFlowLayoutConstraints >> initialize [
	super initialize.
	breakLineBefore := false.
	breakLineAfter := false.
	pushLine := false.
	offsetFromSegmentStart := 0
]

{ #category : #accessing }
AlbLineFlowLayoutConstraints >> offsetFromSegmentStart [
	"computed and set during layout"
	^ offsetFromSegmentStart
]

{ #category : #accessing }
AlbLineFlowLayoutConstraints >> offsetFromSegmentStart: aNumber [
	"computed and set during layout"
	offsetFromSegmentStart := aNumber
]

{ #category : #accessing }
AlbLineFlowLayoutConstraints >> positionInEditor [
	^ positionInEditor 
]

{ #category : #accessing }
AlbLineFlowLayoutConstraints >> positionInEditor: aPoint [
	positionInEditor := aPoint
]

{ #category : #initialization }
AlbLineFlowLayoutConstraints >> pushLine [
	"Mark an element such that it will be pushed to the new line after the current line"
	
	pushLine := true
]

{ #category : #testing }
AlbLineFlowLayoutConstraints >> shouldBreakLineAfter [
	"Return true if current line should be broken AFTER an element, false otherwise"
	<return: #Boolean>

	^ breakLineAfter
]

{ #category : #testing }
AlbLineFlowLayoutConstraints >> shouldBreakLineBefore [
	"Return true if current line should be broken BEFORE an element, false otherwise"
	<return: #Boolean>

	^ breakLineBefore
]

{ #category : #testing }
AlbLineFlowLayoutConstraints >> shouldFillLine [
	"Return true if the element should fill all available space in the line if it is the last element"

	^ self class shouldFillLine
]

{ #category : #testing }
AlbLineFlowLayoutConstraints >> shouldPushLine [
	"Return true if an element should be pushed to the new line after the end of the current line, false otherwise"
	<return: #Boolean>
	
	^ pushLine
]
