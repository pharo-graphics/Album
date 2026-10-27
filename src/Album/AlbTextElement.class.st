Class {
	#name : #AlbTextElement,
	#superclass : #BlTextElement,
	#instVars : [
		'cursorElement',
		'segmentPiece',
		'secondaryCursorElements'
	],
	#category : #'Album-UI'
}

{ #category : #'cursor - management' }
AlbTextElement >> addCursorAt: aTextPosition inEditorElement: anEditorElement [

	<return: #AlbCursorElement>
	^ self addCursorAt: aTextPosition inEditorElement: anEditorElement primary: true
]

{ #category : #cursor }
AlbTextElement >> addCursorAt: aTextPosition inEditorElement: anEditorElement primary: isPrimary [
	"The primary cursor uses the unique cursor element of the editor element, secondary ones get their own element"

	<return: #AlbCursorElement>
	| aBackground aCursorElement |
	isPrimary ifTrue: [
		cursorElement ifNil: [
			cursorElement := anEditorElement cursorElement.
			cursorElement removeFromParent.
			self addChild: cursorElement ].
		cursorElement textPosition: aTextPosition.
		^ cursorElement ].
	self secondaryCursorElements
		detect: [ :each | each textPosition = aTextPosition ]
		ifFound: [ :anExisting | ^ anExisting ].
	aBackground := anEditorElement cursorElement focusedBackground.
	aCursorElement := AlbCursorElement new
		focusedBackground: aBackground;
		textPosition: aTextPosition;
		yourself.
	self secondaryCursorElements add: aCursorElement.
	self addChild: aCursorElement.
	^ aCursorElement
]

{ #category : #cursor }
AlbTextElement >> allCursorElements [

	^ cursorElement
		ifNil: [ self secondaryCursorElements asArray ]
		ifNotNil: [ (Array with: cursorElement) , self secondaryCursorElements asArray ]
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

{ #category : #'cursor - accessing' }
AlbTextElement >> cursorAt: aTextPosition ifFound: aFoundBlock ifNone: aNoneBlock [

	(cursorElement notNil and: [ cursorElement textPosition = aTextPosition ])
		ifTrue: [ ^ aFoundBlock value: cursorElement ].
	^ self secondaryCursorElements
		detect: [ :each | each textPosition = aTextPosition ]
		ifFound: aFoundBlock
		ifNone: aNoneBlock
]

{ #category : #initialization }
AlbTextElement >> defaultMinWidth [

	"to ensure that the clickable area is width enough event in case of fitContent"

	^ 2
]

{ #category : #'cursor - accessing' }
AlbTextElement >> hasCursor [

	^ cursorElement notNil or: [ self secondaryCursorElements notEmpty ]
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

	self allCursorElements do: [ :each | each visibility: BlVisibility gone ]
]

{ #category : #initialization }
AlbTextElement >> initialize [

	super initialize.
	self constraints minWidth: self defaultMinWidth.
	self clipChildren: false.
]

{ #category : #initialization }
AlbTextElement >> initializeMeasurement [

	self editorMeasurement
]

{ #category : #layout }
AlbTextElement >> layoutCursor: aBounds context: aBlElementBoundsUpdateContext [

	self allCursorElements do: [ :each | self layoutCursorElement: each context: aBlElementBoundsUpdateContext ]
]

{ #category : #layout }
AlbTextElement >> layoutCursorElement: aCursorElement context: aBlElementBoundsUpdateContext [

	| cursorPos textPosX maxTextPosX minTextPosX textPos |
	"we make sure that the cursor is within text bounds (we allow to add a cursor outside of the text bounds)"
	cursorPos := aCursorElement textPosition min: self text size max: 0.0.
	maxTextPosX := self measuredWidth - aCursorElement measuredWidth max: 0.0.
	minTextPosX := aCursorElement measuredWidth negated.
	textPosX := (self screenPositionAt: cursorPos) x.
	textPosX := textPosX - (aCursorElement measuredWidth // 2) min: maxTextPosX max: minTextPosX.
	textPos := (textPosX max: 0.0) @ self padding top.
	aCursorElement
		applyLayoutIn: (textPos extent: aCursorElement measuredWidth @ (aCursorElement measuredHeight - self padding height max: 0.0))
		context: aBlElementBoundsUpdateContext
]

{ #category : #accessing }
AlbTextElement >> lineIndex [ 

	self hasParent ifFalse: [ ^ nil ].
	^ self parent constraints infinite holder position
]

{ #category : #'private - paragraph' }
AlbTextElement >> newTextParagraph [
	"Create a text paragraph used to measure and render text"

	^ AlbTextParagraph new segmentPiece: segmentPiece
]

{ #category : #layout }
AlbTextElement >> onLayout: aBounds context: aBlElementBoundsUpdateContext [
	super onLayout: aBounds context: aBlElementBoundsUpdateContext.	
	self layoutCursor: aBounds context: aBlElementBoundsUpdateContext
]

{ #category : #'cursor - management' }
AlbTextElement >> removeCursorAt: aTextIndex [
	"Remove cursor at a given position"

	(cursorElement notNil and: [ cursorElement textPosition = aTextIndex ]) ifTrue: [
		| aRemoved |
		aRemoved := cursorElement.
		cursorElement removeFromParent.
		cursorElement := nil.
		^ aRemoved ].
	^ self secondaryCursorElements
		detect: [ :each | each textPosition = aTextIndex ]
		ifFound: [ :aSecondary |
			self secondaryCursorElements remove: aSecondary.
			aSecondary removeFromParent.
			aSecondary ]
		ifNone: [ self error: 'Cursor at ' , aTextIndex asString , ' does not exist' ]
]

{ #category : #cursor }
AlbTextElement >> secondaryCursorElements [

	^ secondaryCursorElements ifNil: [ secondaryCursorElements := OrderedCollection new ]
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

	self allCursorElements do: [ :each | each visibility: BlVisibility visible ]
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
