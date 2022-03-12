Class {
	#name : #AlbEditorTextFlowLayoutConstraints,
	#superclass : #BlLayoutConstraints,
	#instVars : [
		'pushLine',
		'shouldFillLine',
		'breakLineBefore',
		'breakLineAfter',
		'assignedLine'
	],
	#category : #'Album-Layout'
}

{ #category : #accessing }
AlbEditorTextFlowLayoutConstraints >> assignToLine: aEditorTextFlowLine [
	assignedLine := aEditorTextFlowLine
]

{ #category : #accessing }
AlbEditorTextFlowLayoutConstraints >> assignedLine [
	^ assignedLine
]

{ #category : #accessing }
AlbEditorTextFlowLayoutConstraints >> breakLineAfter [
	"Mark an element such that a line should be broken AFTER it"

	breakLineAfter := true
]

{ #category : #accessing }
AlbEditorTextFlowLayoutConstraints >> breakLineBefore [
	"Mark an element such that a line should be broken BEFORE it"

	breakLineBefore := true
]

{ #category : #accessing }
AlbEditorTextFlowLayoutConstraints >> doNotFillLine [
	shouldFillLine := false
]

{ #category : #initialization }
AlbEditorTextFlowLayoutConstraints >> initialize [
	super initialize.
	breakLineBefore := false.
	breakLineAfter := false.
	pushLine := false.
	shouldFillLine := true
]

{ #category : #accessing }
AlbEditorTextFlowLayoutConstraints >> pushLine [
	"Mark an element such that it will be pushed to the new line after the current line"
	
	pushLine := true
]

{ #category : #testing }
AlbEditorTextFlowLayoutConstraints >> shouldBreakLineAfter [
	"Return true if current line should be broken AFTER an element, false otherwise"
	<return: #Boolean>

	^ breakLineAfter
]

{ #category : #testing }
AlbEditorTextFlowLayoutConstraints >> shouldBreakLineBefore [
	"Return true if current line should be broken BEFORE an element, false otherwise"
	<return: #Boolean>

	^ breakLineBefore
]

{ #category : #testing }
AlbEditorTextFlowLayoutConstraints >> shouldFillLine [
	"Return true if the element should fill all available space in the line if it is the last element"

	^ shouldFillLine
]

{ #category : #testing }
AlbEditorTextFlowLayoutConstraints >> shouldPushLine [
	"Return true if an element should be pushed to the new line after the end of the current line, false otherwise"
	<return: #Boolean>
	
	^ pushLine
]
