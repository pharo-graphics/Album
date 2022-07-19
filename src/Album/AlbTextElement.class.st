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

{ #category : #'cursor - asserting' }
AlbTextElement >> assertCursor: aCursorElement [
	self assertCursorPosition: aCursorElement textPosition
]

{ #category : #'cursor - asserting' }
AlbTextElement >> assertCursorPosition: anIndex [
	self
		assert: [ self text isNotEmpty or: [ anIndex isZero ] ]
		description: [ 'Cursor position can only be zero if text is empty' ].
	self
		assert: [ anIndex between: 0 and: self text size ]
		description: [ 'Cursor must be within text bounds (0 is allowed)' ].
]

{ #category : #'private - paragraph' }
AlbTextElement >> createTextParagraph [
	"Create a text paragraph used to measure and render text"

	^ AlbTextParagraph new
]

{ #category : #'cursor - accessing' }
AlbTextElement >> cursorAt: aTextPosition ifFound: aFoundBlock ifNone: aNoneBlock [

	cursorElement ifNil: [ ^ aNoneBlock value ].
	cursorElement textPosition = aTextPosition ifFalse: [ ^ aNoneBlock value ].
	^ aFoundBlock value: cursorElement
]

{ #category : #'cursor - management' }
AlbTextElement >> cursorStencil [
	^ cursorStencil
]

{ #category : #'cursor - management' }
AlbTextElement >> cursorStencil: aStencil [
	cursorStencil := aStencil
]

{ #category : #'extended selection - management' }
AlbTextElement >> extendedSelect: aFromIndex to: aToIndex [

	self extendedSelection select: aFromIndex to: aToIndex.
	self parent invalidate
]

{ #category : #'extended selection - management' }
AlbTextElement >> extendedSelectNone [
	self extendedSelection isEmpty
		ifTrue: [ ^ self ].
	self extendedSelection removeAll.
	self parent invalidate
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

{ #category : #'cursor - accessing' }
AlbTextElement >> hasCursor [

	^ cursorElement notNil
]

{ #category : #'cursor - accessing' }
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
AlbTextElement >> oppositeIndex [
	^ oppositeIndex
]

{ #category : #'opposite index - management' }
AlbTextElement >> oppositeIndex: anIndex [
	oppositeIndex := anIndex
]

{ #category : #'cursor - management' }
AlbTextElement >> recycledFrom: aStencilBuilder [

	super recycledFrom: aStencilBuilder.
	self removeCursor.
	self resetExtendedSelectionInterval.
	self resetOppositeIndex.

	"otherwise attributes may not be garbage collected
	see https://github.com/feenkcom/gtoolkit/issues/537"
	self removeSegmentPiece
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
	self isAttachedToSceneGraph ifTrue:[ self extendedSelectNone ]
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

{ #category : #'private - paragraph' }
AlbTextElement >> setupParagraphBeforeDrawing [
	super setupParagraphBeforeDrawing.
	paragraph extendedSelection: self extendedSelection.
	paragraph oppositeIndex: self oppositeIndex.

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
