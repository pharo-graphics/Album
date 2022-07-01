Class {
	#name : #AlbTextElement,
	#superclass : #BlTextElement,
	#instVars : [
		'cursorElement',
		'cursorStencil',
		'segmentPiece'
	],
	#category : #'Album-UI'
}

{ #category : #'cursor - management' }
AlbTextElement >> addCursorAt: aTextPosition [
	<return: #AlbCursorElement>
	
	^ self
		cursorAt: aTextPosition
		ifFound: [:c | c ]
		ifNone: [
			cursorElement ifNotNil: [ cursorElement removeFromParent].
			cursorElement := self newCursor.
			cursorElement textPosition: aTextPosition.
			self addChild: cursorElement.
			cursorElement ]
]

{ #category : #drawing }
AlbTextElement >> allSelectionBounds [

	self selection isEmpty ifTrue: [ ^ #(  ) ].
	paragraph ifNil: [ ^ #(  ) ].
	paragraph containerExtent: self extent.
	paragraph selection: self selection.

	^ Array streamContents: [ :stream | 
		  self selection do: [ :currSel | 
			  | start selStartSpan selStartPos selRect |
			  start := currSel from min: self text size.
			  selStartSpan := paragraph spanAtIndex: start.
			  selStartPos := (selStartSpan positionAt: start) + (self padding left @ 0).

			  selRect := currSel to > self text size
				             ifTrue: [ selStartPos x @ 0 corner: self extent ]
				             ifFalse: [ 
					             | selEndPos selEndSpan end |
					             end := currSel to min: self text size.
					             selEndSpan := paragraph spanAtIndex: end.
					             selEndPos := (selEndSpan positionAt: end) + (self padding left @ 0).
					             selStartPos x @ 0 corner: selEndPos x @ self extent y ].

			  " - note that self extent includes padding "
			  " - have to convert selRect to BlBounds because of #localBoundsToParent: "
			  "   this is because Rectangle>>translateBy: answers a new Rectangle "
			  "   whereas BlBounds>>translateBy: updates the receiver."
			  stream nextPut: (self localBoundsToParent: (BlBounds fromRectangle: selRect)) ] ]
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

	| startSpan startPos start rect |
	paragraph ifNil: [ ^ #(  ) ].
	paragraph containerExtent: self extent.
	start := (aLocalIndex - 1 max: 0) min: self text size.
	startSpan := paragraph spanAtIndex: start.
	startPos := startSpan positionAt: start. "+ (self padding left @ 0)"

	rect := start > self text size
		        ifTrue: [ startPos x @ 0 corner: self extent ]
		        ifFalse: [ 
			        | endPos endSpan end |
			        end := start + 1 min: self text size.
			        endSpan := paragraph spanAtIndex: end.
			        endPos := endSpan positionAt: end. "+ (self padding left @ 0)"
			        startPos x @ 0 corner: endPos x @ self extent y ].
	^ self localPointToGlobal: (BlBounds fromRectangle: rect)
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
	aCanvas clip
		by: (self geometry
				 pathOnSpartaCanvas: aCanvas
				 of: self)
		during: [ 
			paragraph
				drawHighlightsOnSpartaCanvas: aCanvas
				padding: self padding.

			aCanvas transform
				by: [ :t | t translateBy: self padding topLeft ]
				during: [ paragraph drawOn: aCanvas ]].

		
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

	cursorStencil := AlbCursorStencil uniqueInstance
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

{ #category : #'private - pool' }
AlbTextElement >> recycledFrom: aStencilBuilder [
	self removeFromParent.
	self removeCursor.
	self selectNone.

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
