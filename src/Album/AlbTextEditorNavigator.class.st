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
		'nextPositions',
		'cursorsToAdd',
		'positionsToRemove',
		'shouldRemoveSecondaries'
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

{ #category : #'cursor - management' }
AlbTextEditorNavigator >> addCursorAt: aTextPosition [
	"Add a new cursor at a given text position, in addition to the existing ones"

	self privateAssertPosition: aTextPosition.
	cursorsToAdd add: aTextPosition
]

{ #category : #'api - processing' }
AlbTextEditorNavigator >> apply [

	| previousPositions toRemove moves |
	previousPositions := editor cursors collect: [ :each | each position ].
	operations do: [ :anOperation | anOperation performOn: self ].

	toRemove := self privateCursorsToRemove.
	moves := OrderedCollection new.
	nextPositions keysAndValuesDo: [ :aCursor :aPosition |
		(toRemove includes: aCursor) ifFalse: [
			moves add: aCursor -> (aCursor position -> (self privateNormalizePosition: aPosition)) ] ].

	"first remove the cursors from their old location, then update the model,
	and only then add them back, so that cursors sharing a segment do not hide each other"
	toRemove do: [ :each | self notifyCursorRemoved: each ].
	moves do: [ :each | self notifyCursorRemoved: (AlbTextEditorCursor position: each value key) ].

	moves do: [ :each |
		each key position: each value value.
		shouldResetDesiredCoordinate ifTrue: [ each key resetDesiredCoordinate ] ].
	editor secondaryCursors removeAll: toRemove.
	cursorsToAdd do: [ :aPosition |
		editor secondaryCursors add: (AlbTextEditorCursor position: (self privateNormalizePosition: aPosition)) ].
	self privateMergeCursors.

	self selection ifEmpty: [ editor cursors do: [ :each | self notifyCursorAdded: each ] ].

	moves do: [ :each |
		each value key ~= each value value ifTrue: [
			editor dispatchEvent: (AlbCursorMovedEvent
				 cursor: each key
				 from: each value key
				 to: each value value
				 dueTo: (dueTo ifNil: [ self ])) ] ].
	shouldHistorize ifTrue: [
		editor history
			cursorsMovedFrom: previousPositions
			to: (editor cursors collect: [ :each | each position ]) ].
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
	nextPositions := IdentityDictionary new.
	cursorsToAdd := OrderedCollection new.
	positionsToRemove := OrderedCollection new.
	shouldRemoveSecondaries := false.
	shouldResetDesiredCoordinate := true.
	shouldHistorize := false
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
	"Move all cursors by a given delta. The operation is only applied on existing cursors, not the ones that will be added"

	editor cursors do: [ :eachCursor |
		operations add: ((AlbTextEditorNavigatorMoveByOperation cursor: eachCursor) delta: aDelta) ]
]

{ #category : #'api - configuration' }
AlbTextEditorNavigator >> moveDown [
	"Move all cursors down one line"

	editor cursors do: [ :eachCursor |
		operations add: (AlbTextEditorNavigatorMoveDownOperation cursor: eachCursor) ]
]

{ #category : #'api - configuration' }
AlbTextEditorNavigator >> moveLeft [
	"Move all cursors one to the left"

	editor cursors do: [ :eachCursor |
		| delta |
		delta := -1.
		(self hasString: String crlf beforeCursor: eachCursor) ifTrue: [ delta := -2 ].
		operations add: ((AlbTextEditorNavigatorMoveByOperation cursor: eachCursor) delta: delta) ]
]

{ #category : #'api - configuration' }
AlbTextEditorNavigator >> moveRight [
	"Move all cursors one to the right"

	editor cursors do: [ :eachCursor |
		| delta |
		delta := 1.
		(self hasString: String crlf afterCursor: eachCursor) ifTrue: [ delta := 2 ].
		operations add: ((AlbTextEditorNavigatorMoveByOperation cursor: eachCursor) delta: delta) ]
]

{ #category : #'api - configuration' }
AlbTextEditorNavigator >> moveTo: aTextPosition [
	"Move all cursors to a given position (basically, remove all cursors except one)"

	self privateAssertPosition: aTextPosition.
	shouldRemoveSecondaries := true.
	operations add: ((AlbTextEditorNavigatorMoveToOperation cursor: self cursor) position: aTextPosition)
]

{ #category : #'api - configuration' }
AlbTextEditorNavigator >> moveToEndNextWord [
	"Move all cursors to the end of the next word"

	editor cursors do: [ :eachCursor |
		operations add: (AlbTextEditorNavigatorMoveToEndNextWordOperation cursor: eachCursor) ]
]

{ #category : #'api - configuration' }
AlbTextEditorNavigator >> moveToLineEnd [
	"Move all cursors to the end of their corresponding lines"

	editor cursors do: [ :eachCursor |
		operations add: (AlbTextEditorNavigatorMoveToLineEndOperation cursor: eachCursor) ]
]

{ #category : #'api - configuration' }
AlbTextEditorNavigator >> moveToLineStart [
	"Move all cursors to the start of their corresponding lines"

	editor cursors do: [ :eachCursor |
		operations add: (AlbTextEditorNavigatorMoveToLineStartOperation cursor: eachCursor) ]
]

{ #category : #'api - configuration' }
AlbTextEditorNavigator >> moveToScreenPosition: aScreenPosition [
	"Move all cursors to a given screen position (basically, remove all cursors except one)"

	shouldRemoveSecondaries := true.
	operations add: ((AlbTextEditorNavigatorMoveAtScreenPositionOperation cursor: self cursor) screenPosition: aScreenPosition)
]

{ #category : #'api - configuration' }
AlbTextEditorNavigator >> moveToStartPreviousWord [
	"Move all cursors to the start of the previous word"

	editor cursors do: [ :eachCursor |
		operations add: (AlbTextEditorNavigatorMoveToStartPreviousWordOperation cursor: eachCursor) ]
]

{ #category : #'api - configuration' }
AlbTextEditorNavigator >> moveUp [
	"Move all cursors up one line"

	editor cursors do: [ :eachCursor |
		operations add: (AlbTextEditorNavigatorMoveUpOperation cursor: eachCursor) ]
]

{ #category : #'api - configuration' }
AlbTextEditorNavigator >> moveWithin: anInterval [
	"Move all cursors so that they end up within a given text interval.
	The operation is only applied on existing cursors, not the ones that will be added"

	editor cursors do: [ :eachCursor |
		eachCursor position < anInterval first
			ifTrue: [ self move: eachCursor to: anInterval first ]
			ifFalse: [
				eachCursor position > anInterval last
					ifTrue: [ self move: eachCursor to: anInterval last ] ] ]
]

{ #category : #'private - accessing' }
AlbTextEditorNavigator >> privateAssertPosition: aTextPosition [
	self
		assert: [ aTextPosition between: 0 and: self text size ]
		description: [ 'Cursor position ({1}) must be within the interval [0.. {2}]' format: { aTextPosition . self text size } ].
]

{ #category : #private }
AlbTextEditorNavigator >> privateCursorsToRemove [
	"Return the cursors to be removed by this navigation. The primary cursor is never part of it:
	if it must be removed while other cursors survive, one of them is promoted to primary first"

	<return: #IdentitySet>
	| toRemove |
	toRemove := IdentitySet new.
	shouldRemoveSecondaries ifTrue: [ toRemove addAll: editor secondaryCursors ].
	positionsToRemove do: [ :aPosition |
		editor cursors
			detect: [ :each | each position = aPosition ]
			ifFound: [ :aCursor | toRemove add: aCursor ] ].
	(toRemove includes: editor cursor) ifFalse: [ ^ toRemove ].
	toRemove remove: editor cursor.
	(editor secondaryCursors reject: [ :each | toRemove includes: each ]) ifNotEmpty: [ :theSurvivors |
		| anOldPrimary |
		anOldPrimary := editor cursor.
		editor secondaryCursors remove: theSurvivors first.
		editor cursor: theSurvivors first.
		editor secondaryCursors add: anOldPrimary.
		toRemove add: anOldPrimary ].
	^ toRemove
]

{ #category : #private }
AlbTextEditorNavigator >> privateMergeCursors [
	"Remove secondary cursors sharing their position with another cursor (the primary one wins)"

	| theOccupiedPositions |
	theOccupiedPositions := Set with: editor cursor position.
	editor secondaryCursors copy do: [ :eachCursor |
		(theOccupiedPositions includes: eachCursor position)
			ifTrue: [ editor secondaryCursors remove: eachCursor ]
			ifFalse: [ theOccupiedPositions add: eachCursor position ] ]
]

{ #category : #private }
AlbTextEditorNavigator >> privateMoveCursor: aCursor to: aTextIndex [

	| prevIndex nextIndex |
	prevIndex := aCursor position.
	nextIndex := self privateNormalizePosition: aTextIndex.
		
	"remove old one"
	self notifyCursorRemoved: aCursor.

	"update then add the new one"
	aCursor position: nextIndex.

	shouldResetDesiredCoordinate ifTrue: [ aCursor resetDesiredCoordinate ].
	self selection ifEmpty: [ self notifyCursorAdded: aCursor ].

	"now tell everyone interested that the cursor has moved"
	prevIndex ~= aCursor position ifTrue: [
		editor dispatchEvent: (AlbCursorMovedEvent
			 cursor: aCursor
			 from: prevIndex
			 to: aCursor position
			 dueTo: (dueTo ifNil: [ self ])) ]
]

{ #category : #'private - accessing' }
AlbTextEditorNavigator >> privateNormalizePosition: aTextPosition [
	^ (aTextPosition max: 0) min: self text size
]

{ #category : #'private - registration' }
AlbTextEditorNavigator >> privateRegisterForMove: aCursor by: aDelta [

	nextPositions at: aCursor put: aCursor position + aDelta
]

{ #category : #'private - registration' }
AlbTextEditorNavigator >> privateRegisterForMove: aCursor to: aTextPosition [

	nextPositions at: aCursor put: aTextPosition
]

{ #category : #'cursor - management' }
AlbTextEditorNavigator >> removeAt: aTextPosition [
	"Remove the cursor at a given text position (used by the history)"

	self removeCursorAt: aTextPosition
]

{ #category : #'cursor - management' }
AlbTextEditorNavigator >> removeCursorAt: aTextPosition [
	"Remove the cursor at a given text position. The last remaining cursor is never removed"

	positionsToRemove add: aTextPosition
]

{ #category : #'cursor - management' }
AlbTextEditorNavigator >> removeSecondaryCursors [
	"Keep only the primary cursor"

	shouldRemoveSecondaries := true
]

{ #category : #'api - events' }
AlbTextEditorNavigator >> whenMoved: aBlock [
	"Subscribe to the cursor moved event and return an event handler"

	^ self when: AlbCursorMovedEvent do: aBlock
]

{ #category : #'api - events' }
AlbTextEditorNavigator >> whenReachedBoundary: aBlock [
	"Subscribe to the cursor reached boundary event and return an event handler"

	^ self when: AlbCursorReachedBoundaryEvent do: aBlock
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
