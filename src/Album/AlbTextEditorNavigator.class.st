"
I am responsible for cursor navigation.

- First I perform all cursor remove operations.
- Then I add new cursors
- and finally perform cursor movement operations
"
Class {
	#name : #AlbTextEditorNavigator,
	#superclass : #AlbTextEditorOperator,
	#instVars : [
		'shouldResetDesiredCoordinate',
		'operations',
		'dueTo',
		'shouldHistorize',
		'nextTextPosition'
	],
	#category : #'Album-Model-Operators'
}

{ #category : #'api - configuration' }
AlbTextEditorNavigator >> addAt: aTextPosition [
	"Add a cursor at a given text position"
	self privateAssertPosition: aTextPosition.

	self moveTo: aTextPosition
]

{ #category : #'api - configuration' }
AlbTextEditorNavigator >> addAtScreenPosition: aScreenPosition [
	"Add a cursor at a given screen position"

	self moveToScreenPosition: aScreenPosition 
]

{ #category : #'api - processing' }
AlbTextEditorNavigator >> apply [
	| prevTextPosition |
	
	prevTextPosition := self cursor position.
	nextTextPosition := prevTextPosition.
	operations do: [ :anOperation| anOperation performOn: self ].
	
	shouldHistorize ifTrue: [
		self editor history
			cursorsMovedFrom: {prevTextPosition} to: { nextTextPosition } ].

	self privateMoveCursor: self cursor to: nextTextPosition.
	dueTo := nil
]

{ #category : #accessing }
AlbTextEditorNavigator >> dueTo [
	^ dueTo
]

{ #category : #accessing }
AlbTextEditorNavigator >> dueTo: aTextEditorOperator [
	dueTo := aTextEditorOperator
]

{ #category : #initialization }
AlbTextEditorNavigator >> initialize [
	super initialize.
	operations := OrderedCollection new.
	shouldResetDesiredCoordinate := true.
	shouldHistorize := false.

]

{ #category : #'api - configuration' }
AlbTextEditorNavigator >> move: aCursor by: aDelta [
	"Move a given cursor by a provided delta"

	operations add: ((AlbTextEditorNavigatorMoveByOperation cursor: aCursor) delta: aDelta)
]

{ #category : #'api - configuration' }
AlbTextEditorNavigator >> move: aCursor to: aTextPosition [
	"Move a given cursor to a provided position"
	self privateAssertPosition: aTextPosition.
	operations add: ((AlbTextEditorNavigatorMoveToOperation cursor: aCursor) position: aTextPosition)
]

{ #category : #'api - configuration' }
AlbTextEditorNavigator >> moveBy: aDelta [
	"Move all cursors by a given delta. The operation is only applied on existing cursor, not the ones that will be added"

	self cursor do: [ :aCursor | operations add: ((AlbTextEditorNavigatorMoveByOperation cursor: aCursor) delta: aDelta) ]
]

{ #category : #'api - configuration' }
AlbTextEditorNavigator >> moveDown [
	"Move all cursors down one line"

	self cursor do: [ :aCursor | operations add: (AlbTextEditorNavigatorMoveDownOperation cursor: aCursor) ]
]

{ #category : #'api - configuration' }
AlbTextEditorNavigator >> moveLeft [
	"Move all cursors to the left"

	self cursor do: [ :aCursor | operations add: (AlbTextEditorNavigatorMoveLeftOperation cursor: aCursor) ]
]

{ #category : #'api - configuration' }
AlbTextEditorNavigator >> moveRight [
	"Move all cursors one to the right"

	self cursor do: [ :aCursor | operations add: (AlbTextEditorNavigatorMoveRightOperation cursor: aCursor) ]
]

{ #category : #'api - configuration' }
AlbTextEditorNavigator >> moveTo: aTextPosition [
	"Move all cursors to a given position (basically, remove all cursors except one)"
	self privateAssertPosition: aTextPosition.

	operations add: ((AlbTextEditorNavigatorMoveToOperation cursor: self cursor) position: aTextPosition).

]

{ #category : #'api - configuration' }
AlbTextEditorNavigator >> moveToEndNextWord [
	"Move all cursors to the end of the next word"

	self cursor do: [ :aCursor | operations add: (AlbTextEditorNavigatorMoveToEndNextWordOperation cursor: aCursor) ]
]

{ #category : #'api - configuration' }
AlbTextEditorNavigator >> moveToLineEnd [
	"Move all cursors to the end of their corresponding lines"

	self cursor do: [ :aCursor | operations add: (AlbTextEditorNavigatorMoveToLineEndOperation cursor: aCursor) ]
]

{ #category : #'api - configuration' }
AlbTextEditorNavigator >> moveToLineStart [
	"Move all cursors to the start of their corresponding lines"

	self cursor do: [ :aCursor | operations add: (AlbTextEditorNavigatorMoveToLineStartOperation cursor: aCursor) ]
]

{ #category : #'api - configuration' }
AlbTextEditorNavigator >> moveToScreenPosition: aScreenPosition [
	"Move all cursors to a given screen position (basically, remove all cursors except one)"
	operations add: ((AlbTextEditorNavigatorMoveAtScreenPositionOperation cursor: self cursor) screenPosition: aScreenPosition).
]

{ #category : #'api - configuration' }
AlbTextEditorNavigator >> moveToStartPreviousWord [
	"Move all cursors to the start of the previous word"

	self cursor do: [ :aCursor | operations add: (AlbTextEditorNavigatorMoveToStartPreviousWordOperation cursor: aCursor) ]
]

{ #category : #'api - configuration' }
AlbTextEditorNavigator >> moveUp [
	"Move all cursors up one line"

	self cursor do: [ :aCursor | operations add: (AlbTextEditorNavigatorMoveUpOperation cursor: aCursor) ]
]

{ #category : #'api - configuration' }
AlbTextEditorNavigator >> moveWithin: anInterval [
	"Move all cursors so that they end up within a given text interval.
	The operation is only applied on existing cursor, not the ones that will be added"

	self cursor do: [ :aCursor |
		aCursor position < anInterval first
			ifTrue: [ self move: aCursor to: anInterval first ]
			ifFalse: [ aCursor position > anInterval last
				ifTrue: [ self move: aCursor to: anInterval last ] ] ]
]

{ #category : #notifying }
AlbTextEditorNavigator >> notifyCursorChanged: aCursor [
	| aCommand |

	aCommand := AlbTextEditorCursorChangeCommand new
		context: self context;
		cursor: aCursor;
		position: aCursor position.
	self editor enqueueCommand: aCommand
]

{ #category : #notifying }
AlbTextEditorNavigator >> notifyCursorMoved: aCursor from: aFromIndex to: aToIndex [
	self editor dispatchEvent: (AlbTextEditorCursorMovedEvent cursor: aCursor from: aFromIndex to: aToIndex dueTo: (dueTo ifNil: [self])).
	self notifyCursorChanged: aCursor
]

{ #category : #'private - accessing' }
AlbTextEditorNavigator >> privateAssertPosition: aTextPosition [
	self
		assert: [ aTextPosition between: 0 and: self text size ]
		description: [ 'Cursor position ({1}) must be within the interval [0.. {2}]' format: { aTextPosition . self text size } ].
]

{ #category : #private }
AlbTextEditorNavigator >> privateMoveCursor: aCursor to: aTextIndex [
	| anOldCursor  idx |
	idx := self privateNormalizePosition: aTextIndex.
	
	anOldCursor := aCursor copy.
	self flag: 'here, notifyCursorChanged: anOldCursor will not work. why ???????'. 
	aCursor position: idx.
	self privateUpdateDesiredCoordinate: aCursor.

	self notifyCursorChanged: anOldCursor.
	self notifyCursorChanged: aCursor.
	self notifyCursorMoved: aCursor from: anOldCursor position to: idx.
]

{ #category : #'private - accessing' }
AlbTextEditorNavigator >> privateNormalizePosition: aTextPosition [
	^ (aTextPosition max: 0) min: self text size
]

{ #category : #'private - registration' }
AlbTextEditorNavigator >> privateRegisterForMove: aCursor by: aDelta [
	nextTextPosition := self cursor position + aDelta
]

{ #category : #'private - registration' }
AlbTextEditorNavigator >> privateRegisterForMove: aCursor to: aTextPosition [
	nextTextPosition := aTextPosition
]

{ #category : #private }
AlbTextEditorNavigator >> privateUpdateDesiredCoordinate: aCursor [
	shouldResetDesiredCoordinate
		ifFalse: [ ^ self ].

	aCursor resetDesiredCoordinate
]

{ #category : #'api - events' }
AlbTextEditorNavigator >> whenMoved: aBlock [
	"Subscribe to the cursor moved event and return an event handler"

	^ self when: AlbTextEditorCursorMovedEvent do: aBlock
]

{ #category : #'api - events' }
AlbTextEditorNavigator >> whenReachedBoundary: aBlock [
	"Subscribe to the cursor reached boundary event and return an event handler"

	^ self when: AlbTextEditorCursorReachedBoundaryEvent do: aBlock
]

{ #category : #'api - configuration' }
AlbTextEditorNavigator >> withHistorization [
	"Add cursor movement to the history sos that it can be undone / redone"
	
	shouldHistorize := true
]

{ #category : #'api - configuration' }
AlbTextEditorNavigator >> withResettingDesiredCoordinate [
	shouldResetDesiredCoordinate := true
]

{ #category : #'api - configuration' }
AlbTextEditorNavigator >> withoutResettingDesiredCoordinate [
	shouldResetDesiredCoordinate := false
]
