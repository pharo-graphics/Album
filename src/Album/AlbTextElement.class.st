Class {
	#name : #AlbTextElement,
	#superclass : #BlTextElement,
	#instVars : [
		'cursorElement',
		'segmentPiece'
	],
	#category : #'Album-UI'
}

{ #category : #'cursor - management' }
AlbTextElement >> addCursorAt: aTextPosition inEditorElement: anEditorElement [

	<return: #AlbCursorElement>
	^ self cursorAt: aTextPosition ifFound: #yourself ifNone: [ 
		  cursorElement ifNil: [ 
			  cursorElement := anEditorElement cursorStencil asElement.
			  cursorElement removeFromParent.
			  self addChild: cursorElement ].
		  cursorElement textPosition: aTextPosition.
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

	^ AlbTextParagraph new segmentPiece: segmentPiece
]

{ #category : #'cursor - accessing' }
AlbTextElement >> cursorAt: aTextPosition ifFound: aFoundBlock ifNone: aNoneBlock [

	cursorElement ifNil: [ ^ aNoneBlock value ].
	cursorElement textPosition = aTextPosition ifFalse: [ ^ aNoneBlock value ].

	^ aFoundBlock value: cursorElement
]

{ #category : #initialization }
AlbTextElement >> defaultMinWidth [

	"to ensure that the clickable area is width enough event in case of fitContent"

	^ 2
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
	self constraints minWidth: self defaultMinWidth.
	self clipChildren: false.
]

{ #category : #layout }
AlbTextElement >> layoutCursor: aBounds context: aBlElementBoundsUpdateContext [
		| cursorPos textPosX maxTextPosX minTextPosX textPos |
		cursorElement ifNil: [ ^self ].
		"we make sure that the cursor is within text bounds (we allow to add a cursor outside of the text bounds)"
		cursorPos := cursorElement textPosition min: self text size max: 0.0.
		
		maxTextPosX := ((self measuredWidth - (cursorElement measuredWidth))) max: 0.0.
		minTextPosX := cursorElement measuredWidth negated.
		
		textPosX := (self screenPositionAt: cursorPos) x.
		textPosX := ((textPosX - (cursorElement measuredWidth // 2)) min: maxTextPosX) max: minTextPosX.
		textPos := (textPosX max: -1.0) @ self padding top.
		
		cursorElement
			applyLayoutIn: (textPos extent: (cursorElement measuredWidth @ ((cursorElement measuredHeight - self padding height) max: 0.0)))
			context: aBlElementBoundsUpdateContext
]

{ #category : #layout }
AlbTextElement >> onLayout: aBounds context: aBlElementBoundsUpdateContext [
	super onLayout: aBounds context: aBlElementBoundsUpdateContext.	
	self layoutCursor: aBounds context: aBlElementBoundsUpdateContext
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
AlbTextElement >> segmentPiece [
	<return: #TAlbTextEditorTextualPiece>

	^ segmentPiece
]

{ #category : #accessing }
AlbTextElement >> segmentPiece: aSegmentPiece [

	segmentPiece := aSegmentPiece.
	"need to copy (copying is fast enough)"
	self text: (aSegmentPiece text copyFrom: 1 to: aSegmentPiece text size)
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
