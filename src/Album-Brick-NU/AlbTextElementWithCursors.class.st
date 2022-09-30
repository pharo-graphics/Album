"
I am extended version of the ${class:BlTextElement}$ with support of multiple cursors.
"
Class {
	#name : #AlbTextElementWithCursors,
	#superclass : #BlTextElement,
	#instVars : [
		'cursorElements',
		'cursorStencil',
		'segmentPiece'
	],
	#category : #'Album-Brick-NU-UI'
}

{ #category : #'cursor - management' }
AlbTextElementWithCursors >> addCursorAt: aTextPosition [
	<return: #AlbCursorElement>
	
	^ self
		cursorAt: aTextPosition
		ifFound: #yourself
		ifNone: [
			| aCursorElement |
			aCursorElement := self newCursor.
			aCursorElement textPosition: aTextPosition.
			cursorElements add: aCursorElement.
			self addChild: aCursorElement.
			aCursorElement ]
]

{ #category : #'private - selection' }
AlbTextElementWithCursors >> allSelectionBounds [

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
AlbTextElementWithCursors >> assertCursor: aCursorElement [
	self assertCursorPosition: aCursorElement textPosition
]

{ #category : #asserting }
AlbTextElementWithCursors >> assertCursorPosition: anIndex [
	self
		assert: [ self text isNotEmpty or: [ anIndex isZero ] ]
		description: [ 'Cursor position can only be zero if text is empty' ].
	self
		assert: [ anIndex between: 0 and: self text size ]
		description: [ 'Cursor must be within text bounds (0 is allowed)' ].
]

{ #category : #private }
AlbTextElementWithCursors >> cursorAt: aTextPosition ifFound: aFoundBlock ifNone: aNoneBlock [

	^ cursorElements
		detect: [ :aCursor | aCursor textPosition = aTextPosition ]
		ifFound: aFoundBlock
		ifNone: aNoneBlock
]

{ #category : #accessing }
AlbTextElementWithCursors >> cursorElements [
	<return: #Collection of: #AlbCursorElement>

	^ cursorElements
]

{ #category : #accessing }
AlbTextElementWithCursors >> cursorStencil [
	^ cursorStencil
]

{ #category : #accessing }
AlbTextElementWithCursors >> cursorStencil: aStencil [
	cursorStencil := aStencil
]

{ #category : #drawing }
AlbTextElementWithCursors >> drawOnSpartaCanvas: aCanvas [

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

{ #category : #testing }
AlbTextElementWithCursors >> hasCursorAt: aTextPosition [
	"Return true if cursor at a given position exists"
	<return: #Boolean>
		
	^ self
		cursorAt: aTextPosition
		ifFound: [ true ]
		ifNone: [ false ]
]

{ #category : #'cursor - management' }
AlbTextElementWithCursors >> hideCursors [
	self cursorElements do: [ :aCursorElement | aCursorElement visibility: BlVisibility gone ]
]

{ #category : #initialization }
AlbTextElementWithCursors >> initialize [
	super initialize.

	cursorElements := OrderedCollection new.
	cursorStencil := AlbCursorStencil uniqueInstance
]

{ #category : #layout }
AlbTextElementWithCursors >> layoutCursors: aBounds context: aBlElementBoundsUpdateContext [
	cursorElements do: [ :aCursorElement |
		| aCursorPosition aTextPositionX aMaxTextPositionX aMinTextPositionX aTextPosition |
		
		"we make sure that the cursor is within text bounds (we allow to add a cursor outside of the text bounds)"
		aCursorPosition := aCursorElement textPosition min: self text size max: 0.0.
		
		aMaxTextPositionX := ((self measuredWidth - (aCursorElement measuredWidth))) max: 0.0.
		aMinTextPositionX := 0.0.
		
		aTextPositionX := (self screenPositionAt: aCursorPosition) x.
		aTextPositionX := ((aTextPositionX - (aCursorElement measuredWidth // 2)) min: aMaxTextPositionX) max: aMinTextPositionX.
		aTextPosition := aTextPositionX @ self padding top.
		
		aCursorElement
			applyLayoutIn: (aTextPosition extent: (aCursorElement measuredWidth @ ((aCursorElement measuredHeight - self padding height) max: 0.0)))
			context: aBlElementBoundsUpdateContext ]
]

{ #category : #initialization }
AlbTextElementWithCursors >> newCursor [
	"Create and return a new instance of a cursor element"
	<return: #BlElement>

	^ self cursorStencil asElement
]

{ #category : #layout }
AlbTextElementWithCursors >> onLayout: aBounds context: aBlElementBoundsUpdateContext [
	super onLayout: aBounds context: aBlElementBoundsUpdateContext.
	
	self layoutCursors: aBounds context: aBlElementBoundsUpdateContext
]

{ #category : #'private - pool' }
AlbTextElementWithCursors >> recycledFrom: aStencilBuilder [
	self removeFromParent.
	self removeCursors.
	self selectNone.

	"otherwise attributes may not be garbage collected
	see https://github.com/feenkcom/gtoolkit/issues/537"
	self removeSegmentPiece.
]

{ #category : #'cursor - management' }
AlbTextElementWithCursors >> removeCursorAt: aTextIndex [
	"Remove cursor at a goven position"

	^ self
		cursorAt: aTextIndex
		ifFound: [ :aCursorElement |
			cursorElements remove: aCursorElement.
			aCursorElement removeFromParent.
			aCursorElement ]
		ifNone: [ self error: 'Cursor at ', aTextIndex asString, ' does not exist' ]
]

{ #category : #'cursor - management' }
AlbTextElementWithCursors >> removeCursors [
	"Remove all cursors"

	self cursorElements reverseDo: [ :eachCursorElement | eachCursorElement removeFromParent ].
	self cursorElements removeAll
]

{ #category : #accessing }
AlbTextElementWithCursors >> removeSegmentPiece [
	segmentPiece := nil.	
	self text: '' asRopedText
]

{ #category : #accessing }
AlbTextElementWithCursors >> segmentPiece [
	<return: #TAlbTextEditorTextualPiece>

	^ segmentPiece
]

{ #category : #accessing }
AlbTextElementWithCursors >> segmentPiece: aSegmentPiece [
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
AlbTextElementWithCursors >> showCursors [
	self cursorElements do: [ :aCursorElement | aCursorElement visibility: BlVisibility visible ]
]

{ #category : #'text - accessing' }
AlbTextElementWithCursors >> textEnd [
	"Return an index of the last character of a subtext that I represent"
	<return: #Number>
	
	^ segmentPiece textEnd
]

{ #category : #'text - accessing' }
AlbTextElementWithCursors >> textStart [
	"Return an index of the first character of a subtext that I represent"
	<return: #Number>
	
	^ segmentPiece textStart
]
