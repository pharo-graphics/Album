Class {
	#name : #AlbCursorSelectionZone,
	#superclass : #AlbVisualZone,
	#instVars : [
		'previousCursorPosition'
	],
	#category : #'Album-UI'
}

{ #category : #accessing }
AlbCursorSelectionZone class >> selectionColor [

	^ Color
		  r: 0.9530791788856305
		  g: 0.8084066471163245
		  b: 0.1906158357771261
		  alpha: 1.0
]

{ #category : #updating }
AlbCursorSelectionZone >> buildSelectionPathFrom: anEditorElement onSpartaCanvas: aCanvas [
	| aCollection pathBuilder |
	aCollection := self selectionVerticesFrom: anEditorElement.
	pathBuilder := aCanvas path
		absolute;
		moveTo: aCollection first.
	aCollection allButFirstDo: [ :pt | pathBuilder lineTo: pt ].
	pathBuilder close.
	^ pathBuilder finish
]

{ #category : #sparta }
AlbCursorSelectionZone >> drawOnSpartaCanvas: aSpartaCanvas in: anInfiniteElement [

	(self selectionRectanglesFrom: anInfiniteElement) do: [ :bnds | 
		aSpartaCanvas fill
			paint: self frameColor;
			path: bnds;
			"alpha: 0.35"draw ]
]

{ #category : #sparta }
AlbCursorSelectionZone >> drawOnSpartaCanvasOver: aSpartaCanvas in: anInfiniteElement [

	
]

{ #category : #sparta }
AlbCursorSelectionZone >> frameColor [

	^ self class selectionColor
]

{ #category : #sparta }
AlbCursorSelectionZone >> selectionRectanglesFrom: anEditorElement [
	| segs lines prec |
		
	segs := Array streamContents: [ :stream | 
		anEditorElement children sortedByElevation do: [ :anElement | 
			stream nextPutAll: anElement allSelectionBounds ] ].
	segs ifEmpty: [ ^ #( ) ].
	segs := segs asOrderedCollection.
	lines := OrderedCollection new.
	prec := segs removeFirst.
	[ segs isEmpty ] whileFalse: [ | curr |
		curr := segs removeFirst.
		curr origin x <= prec origin x
			ifTrue: [ lines add: prec. prec := curr ]
			ifFalse: [ prec := prec merge: curr ] ].
	lines add: prec.
	^ lines
]

{ #category : #sparta }
AlbCursorSelectionZone >> selectionVerticesFrom: anEditorElement [

	| lines vertices currLine |
	lines := self selectionRectanglesFrom: anEditorElement.
	vertices := OrderedCollection new.
	lines ifEmpty: [ ^ vertices ].
	currLine := lines first.
	vertices add: currLine topLeft.
	vertices add: currLine topRight.
	vertices add: currLine bottomRight.
	lines size = 1 ifTrue: [ 
		vertices add: currLine bottomRight.
		vertices add: currLine bottomLeft.
		vertices add: currLine topLeft.
		^ vertices ].
	lines size > 2 ifTrue: [ 
		currLine := lines at: lines size - 1.
		vertices add: currLine bottomRight].
	currLine := lines last.
	vertices add: currLine topRight.
	vertices add: currLine bottomRight.
	vertices add: currLine bottomLeft.
	lines size > 2 ifTrue: [ 
		currLine := lines at: 2.
		vertices add: currLine topLeft].
	currLine := lines first.
	lines add: lines first bottomLeft.
	lines add: lines first topLeft.
	^ vertices
]

{ #category : #updating }
AlbCursorSelectionZone >> updateFrom: anEditorElement [

	"self zone: (self selectionRectanglesFrom: anEditorElement)"
]
