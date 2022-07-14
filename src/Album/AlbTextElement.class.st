Class {
	#name : #AlbTextElement,
	#superclass : #BlTextElement,
	#instVars : [
		'cursorElement',
		'cursorStencil',
		'segmentPiece',
		'oppositeIndex',
		'extendedSelection'
	],
	#category : #'Album-UI'
}

{ #category : #acccessing }
AlbTextElement class >> oppositeDelimiterBackgroundColor [
	^ Color yellow
]

{ #category : #'cursor - management' }
AlbTextElement >> addCursorAt: aTextPosition [
	<return: #AlbCursorElement>
	^ self
		cursorAt: aTextPosition
		ifFound: #yourself
		ifNone: [
			cursorElement ifNotNil: [ cursorElement removeFromParent].
			cursorElement := self newCursor.
			cursorElement textPosition: aTextPosition.
			self addChild: cursorElement.
			cursorElement ]
]

{ #category : #asserting }
AlbTextElement >> assertCursor: aCursorElement [
	self assertCursorPosition: aCursorElement textPosition
]

{ #category : #asserting }
AlbTextElement >> assertCursorPosition: anIndex [
	self
		assert: [ self text isNotEmpty or: [ anIndex isZero ] ]
		description: [ 'Cursor position can only be zero if text is empty' ].
	self
		assert: [ anIndex between: 0 and: self text size ]
		description: [ 'Cursor must be within text bounds (0 is allowed)' ].
]

{ #category : #drawing }
AlbTextElement >> characterBoundsAtIndex: aLocalIndex [

	| startSpan startPos start rect endPos endSpan end |
	start := (aLocalIndex - 1 max: 0) min: self text size.
	startSpan := paragraph spanAtIndex: start.
	startPos := startSpan positionAt: start. 

	end := start + 1 min: self text size.
	endSpan := paragraph spanAtIndex: end.
	endPos := endSpan positionAt: end. 
	rect := startPos x @ 0 corner: endPos x @ self extent y.
	^ rect
]

{ #category : #'private - paragraph' }
AlbTextElement >> createTextParagraph [
	"Create a text paragraph used to measure and render text"

	^ AlbTextParagraph new
]

{ #category : #private }
AlbTextElement >> cursorAt: aTextPosition ifFound: aFoundBlock ifNone: aNoneBlock [

	cursorElement ifNil: [ ^ aNoneBlock value ].
	cursorElement textPosition = aTextPosition ifFalse: [ ^ aNoneBlock value ].
	^ aFoundBlock value: cursorElement
]

{ #category : #accessing }
AlbTextElement >> cursorStencil [
	^ cursorStencil
]

{ #category : #accessing }
AlbTextElement >> cursorStencil: aStencil [
	cursorStencil := aStencil
]

{ #category : #drawing }
AlbTextElement >> drawOnSpartaCanvas: aCanvas [

	paragraph ifNil: [ ^ self ].
	paragraph containerExtent: self extent.
	paragraph selection: self selection.
	paragraph extendedSelection: self extendedSelection.
	aCanvas clip
		by: (self geometry pathOnSpartaCanvas: aCanvas of: self)
		during: [ 
			paragraph
				drawHighlightsOnSpartaCanvas: aCanvas
				padding: self padding.
			paragraph
				drawExtendedSelectionOnSpartaCanvas: aCanvas
				padding: self padding.
			paragraph 
				drawSelectionOnSpartaCanvas: aCanvas
				padding: self padding.

			aCanvas transform
				by: [ :t | t translateBy: self padding topLeft ]
				during: [ 
					self drawOppositeOnSpartaCanvas: aCanvas.
					paragraph drawOn: aCanvas ] ]
]

{ #category : #drawing }
AlbTextElement >> drawOppositeOnSpartaCanvas: aCanvas [

	| bnds |
	oppositeIndex < 0 ifTrue: [ ^ self ].
	bnds := self characterBoundsAtIndex: oppositeIndex.
	aCanvas fill
			paint: (self class oppositeDelimiterBackgroundColor);
			path: bnds;
			draw. 
	aCanvas figure
		path:
			(bnds expandBy: (Margin
						  left: 1
						  right: 1
						  top: 0
						  bottom: 0));
		border: Color black;
		borderAlpha: 1.0;
		width: 1;
		draw
]

{ #category : #'extended selection - management' }
AlbTextElement >> extendedSelect: aFromIndex to: aToIndex [

	self extendedSelection select: aFromIndex to: aToIndex.
	self invalidate
]

{ #category : #'extended selection - management' }
AlbTextElement >> extendedSelectNone [
	self extendedSelection isEmpty
		ifTrue: [ ^ self ].
	self extendedSelection removeAll.
	self invalidate
]

{ #category : #'extended selection - management' }
AlbTextElement >> extendedSelection [
	<return: #BlSelection>
	
	self
		assert: [ extendedSelection isNotNil ]
		description: [ 'Selection can not be nil' ].

	^ extendedSelection
]

{ #category : #'extended selection - management' }
AlbTextElement >> extendedSelectionInterval: anInterval [
	self extendedSelect: anInterval first to: anInterval last
]

{ #category : #private }
AlbTextElement >> hasCursor [

	^ cursorElement notNil
]

{ #category : #testing }
AlbTextElement >> hasCursorAt: aTextPosition [
	"Return true if cursor at a given position exists"
	<return: #Boolean>
		
	^ self
		cursorAt: aTextPosition
		ifFound: [ :c | true ]
		ifNone: [ false ]
]

{ #category : #'cursor - management' }
AlbTextElement >> hideCursor [
	cursorElement ifNil: [ ^self ].
	cursorElement visibility: BlVisibility gone
]

{ #category : #initialization }
AlbTextElement >> initialize [
	super initialize.
	extendedSelection := BlCompositeSelection new.
	cursorStencil := AlbCursorStencil uniqueInstance.
	oppositeIndex := -1.
]

{ #category : #layout }
AlbTextElement >> layoutCursor: aBounds context: aBlElementBoundsUpdateContext [
		| cursorPos textPosX maxTextPosX minTextPosX textPos |
		cursorElement ifNil: [ ^self ].
		"we make sure that the cursor is within text bounds (we allow to add a cursor outside of the text bounds)"
		cursorPos := cursorElement textPosition min: self text size max: 0.0.
		
		maxTextPosX := ((self measuredWidth - (cursorElement measuredWidth))) max: 0.0.
		minTextPosX := 0.0.
		
		textPosX := (self screenPositionAt: cursorPos) x.
		textPosX := ((textPosX - (cursorElement measuredWidth // 2)) min: maxTextPosX) max: minTextPosX.
		textPos := textPosX @ self padding top.
		
		cursorElement
			applyLayoutIn: (textPos extent: (cursorElement measuredWidth @ ((cursorElement measuredHeight - self padding height) max: 0.0)))
			context: aBlElementBoundsUpdateContext
]

{ #category : #initialization }
AlbTextElement >> newCursor [
	"Create and return a new instance of a cursor element"
	<return: #BlElement>

	^ self cursorStencil asElement constraintsDo: [ :c | c ignoreByLayout ]
]

{ #category : #layout }
AlbTextElement >> onLayout: aBounds context: aBlElementBoundsUpdateContext [
	super onLayout: aBounds context: aBlElementBoundsUpdateContext.	
	self layoutCursor: aBounds context: aBlElementBoundsUpdateContext
]

{ #category : #'opposite index - management' }
AlbTextElement >> oppositeIndex: anIndex [
	oppositeIndex := anIndex
]

{ #category : #'private - pool' }
AlbTextElement >> recycledFrom: aStencilBuilder [
	self removeFromParent.
	self removeCursor.
	self selectNone.
	self resetExtendedSelectionInterval.
	self resetOppositeIndex.

	"otherwise attributes may not be garbage collected
	see https://github.com/feenkcom/gtoolkit/issues/537"
	self removeSegmentPiece.
]

{ #category : #'cursor - management' }
AlbTextElement >> removeCursor [
	"Remove all cursors"
	cursorElement ifNil: [ ^self ].
	cursorElement removeFromParent.
	cursorElement := nil

]

{ #category : #'cursor - management' }
AlbTextElement >> removeCursorAt: aTextIndex [
	"Remove cursor at a goven position"

	^ self
		cursorAt: aTextIndex
		ifFound: [ :c |
			cursorElement removeFromParent.
			cursorElement := nil.
			c ]
		ifNone: [ self error: 'Cursor at ', aTextIndex asString, ' does not exist' ]
]

{ #category : #accessing }
AlbTextElement >> removeSegmentPiece [
	segmentPiece := nil.	
	self text: '' asRopedText
]

{ #category : #'extended selection - management' }
AlbTextElement >> resetExtendedSelectionInterval [
	self extendedSelectNone
]

{ #category : #'opposite index - management' }
AlbTextElement >> resetOppositeIndex [
	oppositeIndex := -1
]

{ #category : #accessing }
AlbTextElement >> segmentPiece [
	<return: #TAlbTextEditorTextualPiece>

	^ segmentPiece
]

{ #category : #accessing }
AlbTextElement >> segmentPiece: aSegmentPiece [
	| isTextSame |
	segmentPiece := aSegmentPiece.
	
	self telemetry
		timeSync: [ 'Compare text `{1}` with `{2}`' format: { self text . aSegmentPiece text } ]
		during: [ isTextSame := self text equals: aSegmentPiece text ].

	isTextSame
		ifFalse: [
			| aTextCopy |
			
			self telemetry
				timeSync: [ 'Copy text `{1}`' format: { aSegmentPiece text } ]
				during: [ aTextCopy := aSegmentPiece text copyFrom: 1 to: aSegmentPiece text size ].

			self telemetry
				timeSync: [ 'Set text `{1}`' format: { aTextCopy } ]
				during: [ self text: aTextCopy ] ]
]

{ #category : #'cursor - management' }
AlbTextElement >> showCursor [
	cursorElement ifNil: [ ^self ].
	cursorElement visibility: BlVisibility visible
]

{ #category : #'text - accessing' }
AlbTextElement >> textEnd [
	"Return an index of the last character of a subtext that I represent"
	<return: #Number>
	
	^ segmentPiece textEnd
]

{ #category : #'text - accessing' }
AlbTextElement >> textStart [
	"Return an index of the first character of a subtext that I represent"
	<return: #Number>
	
	^ segmentPiece textStart
]
