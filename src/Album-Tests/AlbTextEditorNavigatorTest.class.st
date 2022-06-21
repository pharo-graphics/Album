Class {
	#name : #AlbTextEditorNavigatorTest,
	#superclass : #AlbTextEditorOperatorTest,
	#category : #'Album-Tests-Operators'
}

{ #category : #'examples - move to line end' }
AlbTextEditorNavigatorTest >> cursor_moveToNextWord_in_cursors_at_0 [

	<label: 'Cursor before the first character of the line should move to the end'>
	| anEditor theAddedEvents theMovedEvents theRemovedEvents |
	
	anEditor := self test_cursor_add_at_0_in_empty.
	anEditor openInOBlSpace.
	true ifTrue: [ ^self ].
	theAddedEvents := OrderedCollection new.
	theMovedEvents := OrderedCollection new.
	theRemovedEvents := OrderedCollection new.

	anEditor navigator
		whenAdded: [ :anEvent | theAddedEvents add: anEvent ];
		whenMoved: [ :anEvent | theMovedEvents add: anEvent ];
		whenRemoved: [ :anEvent | theRemovedEvents add: anEvent ];
		moveToEndNextWord;
		apply;
		unsubscribe.
		
	self assert: anEditor cursors isNotEmpty.
	self assert: anEditor cursors allCursors equals: { AlbTextEditorSingleCursor new position: 8 }.
	
	self assert: theAddedEvents isEmpty.
	self assert: theMovedEvents size equals: 1.
	self assert: theMovedEvents first cursor equals: (AlbTextEditorSingleCursor new position: 8).
	self assert: theMovedEvents first oldIndex equals: 0.
	self assert: theMovedEvents first newIndex equals: 8.
	self assert: theRemovedEvents isEmpty.
	
	^ anEditor
]

{ #category : #'examples - showroom' }
AlbTextEditorNavigatorTest >> editorOnSomeThing [

	^ self editorFor: 'SomeThing todo here'
]

{ #category : #'examples - showroom' }
AlbTextEditorNavigatorTest >> test_cursor_addAt0_moveNextWord_in_something [

	
	| anEditor |
	anEditor := self editorOnSomeThing.
	anEditor navigator
		moveTo: 0;
		apply.

	self
		assert: anEditor cursors allCursors
		equals: { (AlbTextEditorSingleCursor new position: 0) }.

	anEditor navigator
		moveToEndNextWord;
		apply.

	self
		assert: anEditor cursors allCursors
		equals: { (AlbTextEditorSingleCursor new position: 9) }.
	^ anEditor
]

{ #category : #'examples - showroom' }
AlbTextEditorNavigatorTest >> test_cursor_addAt0_moveNextWord_twice_in_something [
	
	| anEditor |
	anEditor := self test_cursor_addAt0_moveNextWord_in_something.
		
	anEditor navigator
		moveToEndNextWord;
		apply.

	self
		assert: anEditor cursors allCursors
		equals: { (AlbTextEditorSingleCursor new position: 14) }.
		
	^ anEditor
]

{ #category : #'examples - showroom' }
AlbTextEditorNavigatorTest >> test_cursor_addAt9_movePreviousWord_in_something [

	
	| anEditor |
	anEditor := self editorOnSomeThing.
	anEditor navigator
		moveTo: 9;
		apply.

	self
		assert: anEditor cursors allCursors
		equals: { (AlbTextEditorSingleCursor new position: 9) }.

	anEditor navigator
		moveToStartPreviousWord;
		apply.

	self
		assert: anEditor cursors allCursors
		equals: { (AlbTextEditorSingleCursor new position: 0) }.
	^ anEditor
]

{ #category : #'examples - showroom' }
AlbTextEditorNavigatorTest >> test_cursor_addAt9_movePreviousWord_twice_in_something [

	
	| anEditor |
	anEditor := self test_cursor_addAt9_movePreviousWord_in_something.

	anEditor navigator
		moveToStartPreviousWord;
		apply.

	self
		assert: anEditor cursors allCursors
		equals: { (AlbTextEditorSingleCursor new position: 0) }.
	^ anEditor
]

{ #category : #'examples - add' }
AlbTextEditorNavigatorTest >> test_cursor_add_at_0_and_0_in_empty [
	
	| anEditor theAddedEvents theMovedEvents theRemovedEvents |
	
	anEditor := self test_editorOnMultilineText.
	
	theAddedEvents := OrderedCollection new.
	theMovedEvents := OrderedCollection new.
	theRemovedEvents := OrderedCollection new.

	anEditor navigator
		whenAdded: [ :anEvent | theAddedEvents add: anEvent ];
		whenMoved: [ :anEvent | theMovedEvents add: anEvent ];
		whenRemoved: [ :anEvent | theRemovedEvents add: anEvent ];
		addAt: 0;
		addAt: 0;
		apply;
		unsubscribe.

	self assert: anEditor cursors isNotEmpty.
	self assert: anEditor cursors allCursors equals: { AlbTextEditorSingleCursor new position: 0 }.

	self assert: theAddedEvents size equals: 1.
	self assert: (theAddedEvents collect: #cursor) asArray equals: {
		AlbTextEditorSingleCursor new position: 0
	}.
	self assert: theMovedEvents isEmpty.
	self assert: theRemovedEvents isEmpty.

	^ anEditor
]

{ #category : #'examples - add' }
AlbTextEditorNavigatorTest >> test_cursor_add_at_0_and_1_in_empty [
	
	| anEditor theAddedEvents theMovedEvents theRemovedEvents |
	
	anEditor := self test_editorOnMultilineText.
	
	theAddedEvents := OrderedCollection new.
	theMovedEvents := OrderedCollection new.
	theRemovedEvents := OrderedCollection new.

	anEditor navigator
		whenAdded: [ :anEvent | theAddedEvents add: anEvent ];
		whenMoved: [ :anEvent | theMovedEvents add: anEvent ];
		whenRemoved: [ :anEvent | theRemovedEvents add: anEvent ];
		addAt: 0;
		addAt: 1;
		apply;
		unsubscribe.

	self assert: anEditor cursors isNotEmpty.
	self assert: anEditor cursors allCursors equals: {
		AlbTextEditorSingleCursor new position: 0.
		AlbTextEditorSingleCursor new position: 1 }.
		
	self assert: theAddedEvents size equals: 2.
	self assert: (theAddedEvents collect: #cursor) asArray equals: {
		AlbTextEditorSingleCursor new position: 0.
		AlbTextEditorSingleCursor new position: 1
	}.
	self assert: theMovedEvents isEmpty.
	self assert: theRemovedEvents isEmpty.
	
	^ anEditor
]

{ #category : #'examples - add' }
AlbTextEditorNavigatorTest >> test_cursor_add_at_0_in_empty [
	
	| anEditor theAddedEvents theMovedEvents theRemovedEvents addedCursorElements removedCursorElements |
	
	anEditor := self test_editorOnMultilineText.
	
	theAddedEvents := OrderedCollection new.
	theMovedEvents := OrderedCollection new.
	theRemovedEvents := OrderedCollection new.
	addedCursorElements := OrderedCollection new.
	removedCursorElements := OrderedCollection new.
	
	self subscribe: AlbTextEditorCursorElementAddedEvent do: [ :anEvent | addedCursorElements add: anEvent cursorElement ] for: anEditor.
	self subscribe: AlbTextEditorCursorElementRemovedEvent do: [ :anEvent | removedCursorElements add: anEvent cursorElement ] for: anEditor.

	anEditor navigator
		whenAdded: [ :anEvent | theAddedEvents add: anEvent ];
		whenMoved: [ :anEvent | theMovedEvents add: anEvent ];
		whenRemoved: [ :anEvent | theRemovedEvents add: anEvent ];
		addAt: 0;
		apply;
		unsubscribe.
		
	anEditor forceLayout.
		
	self unsubscribe: AlbTextEditorCursorElementAddedEvent from: anEditor.
	self unsubscribe: AlbTextEditorCursorElementRemovedEvent from: anEditor.

	self assert: anEditor cursors isNotEmpty.
	self assert: anEditor cursors allCursors equals: { AlbTextEditorSingleCursor new position: 0 }.
	
	self assert: theAddedEvents size equals: 1.
	self assert: (theAddedEvents collect: #cursor) asArray equals: {
		AlbTextEditorSingleCursor new position: 0.
	}.
	self assert: theMovedEvents isEmpty.
	self assert: theRemovedEvents isEmpty.
	self assert: addedCursorElements size equals: 1.
	self assert: addedCursorElements first textPosition equals: 0.
	self assert: removedCursorElements isEmpty.
	
	^ anEditor
]

{ #category : #'examples - add' }
AlbTextEditorNavigatorTest >> test_cursor_add_at_1_and_0_in_empty [
	
	| anEditor theAddedEvents theMovedEvents theRemovedEvents |

	anEditor := self test_editorOnMultilineText.

	theAddedEvents := OrderedCollection new.
	theMovedEvents := OrderedCollection new.
	theRemovedEvents := OrderedCollection new.

	anEditor navigator
		whenAdded: [ :anEvent | theAddedEvents add: anEvent ];
		whenMoved: [ :anEvent | theMovedEvents add: anEvent ];
		whenRemoved: [ :anEvent | theRemovedEvents add: anEvent ];
		addAt: 1;
		addAt: 0;
		apply;
		unsubscribe.

	self assert: anEditor cursors isNotEmpty.
	self assert: anEditor cursors allCursors equals: {
		AlbTextEditorSingleCursor new position: 0.
		AlbTextEditorSingleCursor new position: 1 }.

	self assert: theAddedEvents size equals: 2.
	self assert: (theAddedEvents collect: #cursor) asArray equals: {
		AlbTextEditorSingleCursor new position: 0.
		AlbTextEditorSingleCursor new position: 1
	}.
	self assert: theMovedEvents isEmpty.
	self assert: theRemovedEvents isEmpty.

	^ anEditor
]

{ #category : #'examples - performance' }
AlbTextEditorNavigatorTest >> test_cursor_add_at_1_does_not_rebuild_editor [
	
	| anEditor thePreviousSegments theNewSegments thePreviousTextPieces theNewTextPieces |
	
	anEditor := self test_editorOnMultilineText.

	thePreviousSegments := anEditor children
		select: [ :eachChild | eachChild isKindOf: AlbTextEditorSegmentElement ].	
	self assert: thePreviousSegments size equals: 11.
	
	thePreviousTextPieces := thePreviousSegments flatCollect: [ :eachSegment | eachSegment children asArray ].
	self assert: thePreviousTextPieces size equals: 63.

	anEditor navigator
		addAt: 1;
		apply.

	anEditor forceLayout.

	self assert: anEditor cursors allCursors equals: { AlbTextEditorSingleCursor new position: 1 }.
	
	theNewSegments := anEditor children
		select: [ :eachChild | eachChild isKindOf: AlbTextEditorSegmentElement ].	
	self assert: theNewSegments size equals: 11.
	
	theNewTextPieces := theNewSegments flatCollect: [ :eachSegment | eachSegment children asArray ].
	self assert: theNewTextPieces size equals: 63.
	
	self assert: thePreviousSegments equals: theNewSegments.
	self assert: thePreviousTextPieces equals: theNewTextPieces.
	
	^ anEditor
]

{ #category : #'examples - add' }
AlbTextEditorNavigatorTest >> test_cursor_add_at_1_in_cursors_at_0 [
	
	| anEditor theAddedEvents theMovedEvents theRemovedEvents |
	
	anEditor := self test_cursor_add_at_0_in_empty.
	
	theAddedEvents := OrderedCollection new.
	theMovedEvents := OrderedCollection new.
	theRemovedEvents := OrderedCollection new.

	anEditor navigator
		whenAdded: [ :anEvent | theAddedEvents add: anEvent ];
		whenMoved: [ :anEvent | theMovedEvents add: anEvent ];
		whenRemoved: [ :anEvent | theRemovedEvents add: anEvent ];
		addAt: 1;
		apply;
		unsubscribe.

	self assert: anEditor cursors isNotEmpty.
	self assert: anEditor cursors allCursors equals: {
		AlbTextEditorSingleCursor new position: 0.
		AlbTextEditorSingleCursor new position: 1.
	}.
	
	self assert: theAddedEvents size equals: 1.
	self assert: (theAddedEvents collect: #cursor) asArray equals: {
		AlbTextEditorSingleCursor new position: 1
	}.
	self assert: theMovedEvents isEmpty.
	self assert: theRemovedEvents isEmpty.

	^ anEditor
]

{ #category : #'examples - add' }
AlbTextEditorNavigatorTest >> test_cursor_add_at_1_in_empty [
	
	| anEditor theAddedEvents theMovedEvents theRemovedEvents addedCursorElements removedCursorElements |
	
	anEditor := self test_editorOnMultilineText.

	theAddedEvents := OrderedCollection new.
	theMovedEvents := OrderedCollection new.
	theRemovedEvents := OrderedCollection new.
	addedCursorElements := OrderedCollection new.
	removedCursorElements := OrderedCollection new.

	self subscribe: AlbTextEditorCursorElementAddedEvent do: [ :anEvent | addedCursorElements add: anEvent cursorElement ] for: anEditor.
	self subscribe: AlbTextEditorCursorElementRemovedEvent do: [ :anEvent | removedCursorElements add: anEvent cursorElement ] for: anEditor.

	anEditor navigator
		whenAdded: [ :anEvent | theAddedEvents add: anEvent ];
		whenMoved: [ :anEvent | theMovedEvents add: anEvent ];
		whenRemoved: [ :anEvent | theRemovedEvents add: anEvent ];
		addAt: 1;
		apply;
		unsubscribe.

	anEditor forceLayout.

	self unsubscribe: AlbTextEditorCursorElementAddedEvent from: anEditor.
	self unsubscribe: AlbTextEditorCursorElementRemovedEvent from: anEditor.

	self assert: anEditor cursors isNotEmpty.
	self assert: anEditor cursors allCursors equals: { AlbTextEditorSingleCursor new position: 1 }.
	
	self assert: theAddedEvents size equals: 1.
	self assert: (theAddedEvents collect: #cursor) asArray equals: {
		AlbTextEditorSingleCursor new position: 1.
	}.
	self assert: theMovedEvents isEmpty.
	self assert: theRemovedEvents isEmpty.
	self assert: addedCursorElements size equals: 1.
	self assert: addedCursorElements first textPosition equals: 0.
	self assert: removedCursorElements isEmpty.
	
	^ anEditor
]

{ #category : #'examples - add' }
AlbTextEditorNavigatorTest >> test_cursor_add_at_2_in_empty [
	
	| anEditor theAddedEvents theMovedEvents theRemovedEvents addedCursorElements removedCursorElements |
	
	anEditor := self test_editorOnMultilineText.

	theAddedEvents := OrderedCollection new.
	theMovedEvents := OrderedCollection new.
	theRemovedEvents := OrderedCollection new.
	addedCursorElements := OrderedCollection new.
	removedCursorElements := OrderedCollection new.

	self subscribe: AlbTextEditorCursorElementAddedEvent do: [ :anEvent | addedCursorElements add: anEvent cursorElement ] for: anEditor.
	self subscribe: AlbTextEditorCursorElementRemovedEvent do: [ :anEvent | removedCursorElements add: anEvent cursorElement ] for: anEditor.

	anEditor navigator
		whenAdded: [ :anEvent | theAddedEvents add: anEvent ];
		whenMoved: [ :anEvent | theMovedEvents add: anEvent ];
		whenRemoved: [ :anEvent | theRemovedEvents add: anEvent ];
		addAt: 2;
		apply;
		unsubscribe.

	anEditor forceLayout.

	self unsubscribe: AlbTextEditorCursorElementAddedEvent from: anEditor.
	self unsubscribe: AlbTextEditorCursorElementRemovedEvent from: anEditor.

	self assert: anEditor cursors isNotEmpty.
	self assert: anEditor cursors allCursors equals: { AlbTextEditorSingleCursor new position: 2 }.
	
	self assert: theAddedEvents size equals: 1.
	self assert: (theAddedEvents collect: #cursor) asArray equals: {
		AlbTextEditorSingleCursor new position: 2.
	}.
	self assert: theMovedEvents isEmpty.
	self assert: theRemovedEvents isEmpty.
	self assert: addedCursorElements size equals: 1.
	self assert: addedCursorElements first textPosition equals: 0.
	self assert: removedCursorElements isEmpty.
	
	^ anEditor
]

{ #category : #'examples - add' }
AlbTextEditorNavigatorTest >> test_cursor_add_at_68_in_empty [
	
	| anEditor theAddedEvents theMovedEvents theRemovedEvents addedCursorElements removedCursorElements |
	
	anEditor := self test_editorOnMultilineText.
	
	theAddedEvents := OrderedCollection new.
	theMovedEvents := OrderedCollection new.
	theRemovedEvents := OrderedCollection new.
	addedCursorElements := OrderedCollection new.
	removedCursorElements := OrderedCollection new.
	
	self subscribe: AlbTextEditorCursorElementAddedEvent do: [ :anEvent | addedCursorElements add: anEvent cursorElement ] for: anEditor.
	self subscribe: AlbTextEditorCursorElementRemovedEvent do: [ :anEvent | removedCursorElements add: anEvent cursorElement ] for: anEditor.

	anEditor navigator
		whenAdded: [ :anEvent | theAddedEvents add: anEvent ];
		whenMoved: [ :anEvent | theMovedEvents add: anEvent ];
		whenRemoved: [ :anEvent | theRemovedEvents add: anEvent ];
		addAt: 68;
		apply;
		unsubscribe.
		
	anEditor forceLayout.
		
	self unsubscribe: AlbTextEditorCursorElementAddedEvent from: anEditor.
	self unsubscribe: AlbTextEditorCursorElementRemovedEvent from: anEditor.

	self assert: anEditor cursors isNotEmpty.
	self assert: anEditor cursors allCursors equals: { AlbTextEditorSingleCursor new position: 68 }.
	
	self assert: theAddedEvents size equals: 1.
	self assert: (theAddedEvents collect: #cursor) asArray equals: {
		AlbTextEditorSingleCursor new position: 68.
	}.
	self assert: theMovedEvents isEmpty.
	self assert: theRemovedEvents isEmpty.
	self assert: addedCursorElements size equals: 1.
	self assert: addedCursorElements first textPosition equals: 0.
	self assert: removedCursorElements isEmpty.
	
	^ anEditor
]

{ #category : #'examples - add' }
AlbTextEditorNavigatorTest >> test_cursor_add_at_8_in_empty [
	
	| anEditor theAddedEvents theMovedEvents theRemovedEvents |
	
	anEditor := self test_cursor_add_at_0_in_empty.
	
	theAddedEvents := OrderedCollection new.
	theMovedEvents := OrderedCollection new.
	theRemovedEvents := OrderedCollection new.

	anEditor navigator
		whenAdded: [ :anEvent | theAddedEvents add: anEvent ];
		whenMoved: [ :anEvent | theMovedEvents add: anEvent ];
		whenRemoved: [ :anEvent | theRemovedEvents add: anEvent ];
		addAt: 8;
		apply;
		unsubscribe.

	self assert: anEditor cursors isNotEmpty.
	self assert: anEditor cursors allCursors equals: {
		AlbTextEditorSingleCursor new position: 0.
		AlbTextEditorSingleCursor new position: 8.
	}.
	
	self assert: theAddedEvents size equals: 1.
	self assert: (theAddedEvents collect: #cursor) asArray equals: {
		AlbTextEditorSingleCursor new position: 8
	}.
	self assert: theMovedEvents isEmpty.
	self assert: theRemovedEvents isEmpty.

	^ anEditor
]

{ #category : #'examples - no duplication' }
AlbTextEditorNavigatorTest >> test_cursor_is_not_duplicated [
	
	| anEditor thePiecesWithCursor |
	
	anEditor := self editorFor: 'Hello World'.
	
	anEditor navigator
		moveTo: 5;
		apply.
	anEditor forceLayout.
	
	thePiecesWithCursor := self piecesWithCursorIn: anEditor.
	self assert: thePiecesWithCursor size equals: 1.
	self assert: thePiecesWithCursor first text asString equals: ' '.
	
	anEditor deleter
		oneBeforeCursor;
		delete.		
	anEditor forceLayout.
	
	thePiecesWithCursor := self piecesWithCursorIn: anEditor.
	self assert: thePiecesWithCursor size equals: 1.
	self assert: thePiecesWithCursor first text asString equals: ' '.
	
	anEditor inserter
		atCursor;
		string: 'O';
		insert.
	anEditor forceLayout.
	
	thePiecesWithCursor := self piecesWithCursorIn: anEditor.
	self assert: thePiecesWithCursor size equals: 1.
	self assert: thePiecesWithCursor first text asString equals: ' '.
	
	^ anEditor
]

{ #category : #'examples - no duplication' }
AlbTextEditorNavigatorTest >> test_cursor_is_not_duplicated_bulk [
	
	| anEditor thePiecesWithCursor |
	
	anEditor := self editorFor: 'Hello World'.
	
	anEditor navigator
		moveTo: 5;
		apply.
	
	anEditor deleter
		oneBeforeCursor;
		delete.		
	anEditor forceLayout.
	
	thePiecesWithCursor := self piecesWithCursorIn: anEditor.
	self assert: thePiecesWithCursor size equals: 1.
	self assert: thePiecesWithCursor first text asString equals: ' '.
	
	anEditor inserter
		atCursor;
		string: 'O';
		insert.
	anEditor forceLayout.
	
	thePiecesWithCursor := self piecesWithCursorIn: anEditor.
	self assert: thePiecesWithCursor size equals: 1.
	self assert: thePiecesWithCursor first text asString equals: ' '.
	
	^ anEditor
]

{ #category : #'examples - no duplication' }
AlbTextEditorNavigatorTest >> test_cursor_is_not_duplicated_bulk_full [
	
	| anEditor thePiecesWithCursor |
	
	anEditor := self editorFor: 'Hello World'.
	
	anEditor navigator
		moveTo: 5;
		apply.
	
	anEditor deleter
		oneBeforeCursor;
		delete.		

	anEditor inserter
		atCursor;
		string: 'O';
		insert.
	anEditor forceLayout.
	
	thePiecesWithCursor := self piecesWithCursorIn: anEditor.
	self assert: thePiecesWithCursor size equals: 1.
	self assert: thePiecesWithCursor first text asString equals: ' '.
	
	^ anEditor
]

{ #category : #accessing }
AlbTextEditorNavigatorTest >> test_cursor_is_not_on_last_line [
	
	| anEditor aNavigator |
	anEditor := self test_editorOnMultilineText.
	aNavigator := anEditor editor navigator 
		moveTo: 186; 
		apply;
		unsubscribe.
	self assert: (aNavigator isCursorOnTheLastLine: anEditor editor cursors cursors anyOne) not.
	^ anEditor
]

{ #category : #accessing }
AlbTextEditorNavigatorTest >> test_cursor_is_on_last_line_when_at_the_end [
	
	| anEditor aNavigator |
	anEditor := self test_editorOnMultilineText.
	aNavigator := anEditor editor navigator 
		moveTo: 202; 
		apply;
		unsubscribe.
	self assert: (aNavigator isCursorOnTheLastLine: anEditor editor cursors cursors anyOne).
	^ anEditor
]

{ #category : #accessing }
AlbTextEditorNavigatorTest >> test_cursor_is_on_last_line_when_before_the_first_character [
	
	| anEditor aNavigator |
	anEditor := self test_editorOnMultilineText.
	aNavigator := anEditor editor navigator 
		moveTo: 187; 
		apply;
		unsubscribe.
	self assert: (aNavigator isCursorOnTheLastLine: anEditor editor cursors cursors anyOne).
	^ anEditor
]

{ #category : #'examples - move down' }
AlbTextEditorNavigatorTest >> test_cursor_moveDown_in_cursors_at_190 [
	
	| anEditor theAddedEvents theMovedEvents theRemovedEvents theReachBoudnaryEvents |
	
	anEditor := self test_cursor_moveTo_190_in_empty.
	
	theAddedEvents := OrderedCollection new.
	theMovedEvents := OrderedCollection new.
	theRemovedEvents := OrderedCollection new.
	theReachBoudnaryEvents := OrderedCollection new.

	anEditor navigator
		whenAdded: [ :anEvent | theAddedEvents add: anEvent ];
		whenMoved: [ :anEvent | theMovedEvents add: anEvent ];
		whenRemoved: [ :anEvent | theRemovedEvents add: anEvent ];
		whenReachedBoundary: [ :anEvent | theReachBoudnaryEvents add: anEvent ];
		moveDown;
		apply;
		unsubscribe.

	self assert: anEditor cursors isNotEmpty.
	self assert: anEditor cursors allCursors equals: { AlbTextEditorSingleCursor new position: 202 }.
	
	self assert: theAddedEvents isEmpty.
	self assert: theMovedEvents size equals: 1.
	self assert: theMovedEvents first cursor equals: (AlbTextEditorSingleCursor new position: 202).
	self assert: theMovedEvents first oldIndex equals: 190.
	self assert: theMovedEvents first newIndex equals: 202.
	self assert: theRemovedEvents isEmpty.
	self assert: theReachBoudnaryEvents size equals: 1.
	self assert: theReachBoudnaryEvents first cursor equals: (AlbTextEditorSingleCursor new position: 202).
	self assert: theReachBoudnaryEvents first isBottom.
	
	^ anEditor
]

{ #category : #'examples - move to line end' }
AlbTextEditorNavigatorTest >> test_cursor_moveToLineEnd_in_cursors_at_0 [
	
	<label: 'Cursor before the first character of the line should move to the end'>
	| anEditor theAddedEvents theMovedEvents theRemovedEvents |
	
	anEditor := self test_cursor_add_at_0_in_empty.
	
	theAddedEvents := OrderedCollection new.
	theMovedEvents := OrderedCollection new.
	theRemovedEvents := OrderedCollection new.

	anEditor navigator
		whenAdded: [ :anEvent | theAddedEvents add: anEvent ];
		whenMoved: [ :anEvent | theMovedEvents add: anEvent ];
		whenRemoved: [ :anEvent | theRemovedEvents add: anEvent ];
		moveToLineEnd;
		apply;
		unsubscribe.
		
	self assert: anEditor cursors isNotEmpty.
	self assert: anEditor cursors allCursors equals: { AlbTextEditorSingleCursor new position: 28 }.
	
	self assert: theAddedEvents isEmpty.
	self assert: theMovedEvents size equals: 1.
	self assert: theMovedEvents first cursor equals: (AlbTextEditorSingleCursor new position: 28).
	self assert: theMovedEvents first oldIndex equals: 0.
	self assert: theMovedEvents first newIndex equals: 28.
	self assert: theRemovedEvents isEmpty.
	
	^ anEditor
]

{ #category : #'examples - move to line end' }
AlbTextEditorNavigatorTest >> test_cursor_moveToLineEnd_in_cursors_at_1 [
	
	<label: 'Cursor after the first character of the line should move to the end'>
	| anEditor theAddedEvents theMovedEvents theRemovedEvents |
	
	anEditor := self test_cursor_add_at_0_in_empty.
	anEditor navigator
		moveTo: 1;
		apply.
	
	theAddedEvents := OrderedCollection new.
	theMovedEvents := OrderedCollection new.
	theRemovedEvents := OrderedCollection new.

	anEditor navigator
		whenAdded: [ :anEvent | theAddedEvents add: anEvent ];
		whenMoved: [ :anEvent | theMovedEvents add: anEvent ];
		whenRemoved: [ :anEvent | theRemovedEvents add: anEvent ];
		moveToLineEnd;
		apply;
		unsubscribe.
		
	self assert: anEditor cursors isNotEmpty.
	self assert: anEditor cursors allCursors equals: { AlbTextEditorSingleCursor new position: 28 }.
	
	self assert: theAddedEvents isEmpty.
	self assert: theMovedEvents size equals: 1.
	self assert: theMovedEvents first cursor equals: (AlbTextEditorSingleCursor new position: 28).
	self assert: theMovedEvents first oldIndex equals: 1.
	self assert: theMovedEvents first newIndex equals: 28.
	self assert: theRemovedEvents isEmpty.
	
	^ anEditor
]

{ #category : #'examples - move to line end' }
AlbTextEditorNavigatorTest >> test_cursor_moveToLineEnd_in_cursors_at_201 [
	
	<label: 'Cursor before the last character of the whole text should not move'>
	| anEditor theAddedEvents theMovedEvents theRemovedEvents |
	
	anEditor := self test_cursor_add_at_0_in_empty.
	anEditor navigator
		moveTo: 201;
		apply.
	
	theAddedEvents := OrderedCollection new.
	theMovedEvents := OrderedCollection new.
	theRemovedEvents := OrderedCollection new.

	anEditor navigator
		whenAdded: [ :anEvent | theAddedEvents add: anEvent ];
		whenMoved: [ :anEvent | theMovedEvents add: anEvent ];
		whenRemoved: [ :anEvent | theRemovedEvents add: anEvent ];
		moveToLineEnd;
		apply;
		unsubscribe.
		
	self assert: anEditor cursors isNotEmpty.
	self assert: anEditor cursors allCursors equals: { AlbTextEditorSingleCursor new position: 202 }.
	
	self assert: theAddedEvents isEmpty.
	self assert: theMovedEvents size equals: 1.
	self assert: theMovedEvents first cursor equals: (AlbTextEditorSingleCursor new position: 202).
	self assert: theMovedEvents first oldIndex equals: 201.
	self assert: theMovedEvents first newIndex equals: 202.
	self assert: theRemovedEvents isEmpty.
	
	^ anEditor
]

{ #category : #'examples - move to line end' }
AlbTextEditorNavigatorTest >> test_cursor_moveToLineEnd_in_cursors_at_202 [
	
	<label: 'Cursor after the last character of the whole text should not move'>
	| anEditor theAddedEvents theMovedEvents theRemovedEvents |
	
	anEditor := self test_cursor_add_at_0_in_empty.
	anEditor navigator
		moveTo: 202;
		apply.
	
	theAddedEvents := OrderedCollection new.
	theMovedEvents := OrderedCollection new.
	theRemovedEvents := OrderedCollection new.

	anEditor navigator
		whenAdded: [ :anEvent | theAddedEvents add: anEvent ];
		whenMoved: [ :anEvent | theMovedEvents add: anEvent ];
		whenRemoved: [ :anEvent | theRemovedEvents add: anEvent ];
		moveToLineEnd;
		apply;
		unsubscribe.
		
	self assert: anEditor cursors isNotEmpty.
	self assert: anEditor cursors allCursors equals: { AlbTextEditorSingleCursor new position: 202 }.
	
	self assert: theAddedEvents isEmpty.
	self assert: theMovedEvents isEmpty.
	self assert: theRemovedEvents isEmpty.
	
	^ anEditor
]

{ #category : #'examples - move to line end' }
AlbTextEditorNavigatorTest >> test_cursor_moveToLineEnd_in_cursors_at_27 [
	
	<label: 'Cursor before the last character of the line should move to the end'>
	| anEditor theAddedEvents theMovedEvents theRemovedEvents |
	
	anEditor := self test_cursor_add_at_0_in_empty.
	anEditor navigator
		moveTo: 27;
		apply.
	
	theAddedEvents := OrderedCollection new.
	theMovedEvents := OrderedCollection new.
	theRemovedEvents := OrderedCollection new.

	anEditor navigator
		whenAdded: [ :anEvent | theAddedEvents add: anEvent ];
		whenMoved: [ :anEvent | theMovedEvents add: anEvent ];
		whenRemoved: [ :anEvent | theRemovedEvents add: anEvent ];
		moveToLineEnd;
		apply;
		unsubscribe.
		
	self assert: anEditor cursors isNotEmpty.
	self assert: anEditor cursors allCursors equals: { AlbTextEditorSingleCursor new position: 28 }.
	
	self assert: theAddedEvents isEmpty.
	self assert: theMovedEvents size equals: 1.
	self assert: theMovedEvents first cursor equals: (AlbTextEditorSingleCursor new position: 28).
	self assert: theMovedEvents first oldIndex equals: 27.
	self assert: theMovedEvents first newIndex equals: 28.
	self assert: theRemovedEvents isEmpty.
	
	^ anEditor
]

{ #category : #'examples - move to line end' }
AlbTextEditorNavigatorTest >> test_cursor_moveToLineEnd_in_cursors_at_28 [
	
	<label: 'Cursor after the last character of the line should not move'>
	| anEditor theAddedEvents theMovedEvents theRemovedEvents |
	
	anEditor := self test_cursor_add_at_0_in_empty.
	anEditor navigator
		moveTo: 28;
		apply.
	
	theAddedEvents := OrderedCollection new.
	theMovedEvents := OrderedCollection new.
	theRemovedEvents := OrderedCollection new.

	anEditor navigator
		whenAdded: [ :anEvent | theAddedEvents add: anEvent ];
		whenMoved: [ :anEvent | theMovedEvents add: anEvent ];
		whenRemoved: [ :anEvent | theRemovedEvents add: anEvent ];
		moveToLineEnd;
		apply;
		unsubscribe.
		
	self assert: anEditor cursors isNotEmpty.
	self assert: anEditor cursors allCursors equals: { AlbTextEditorSingleCursor new position: 28 }.
	
	self assert: theAddedEvents isEmpty.
	self assert: theMovedEvents isEmpty.
	self assert: theRemovedEvents isEmpty.
	
	^ anEditor
]

{ #category : #'examples - move to line end' }
AlbTextEditorNavigatorTest >> test_cursor_moveToLineEnd_in_empty [
	
	| anEditor theAddedEvents theMovedEvents theRemovedEvents |
	
	anEditor := self test_editorOnMultilineText.
	
	theAddedEvents := OrderedCollection new.
	theMovedEvents := OrderedCollection new.
	theRemovedEvents := OrderedCollection new.

	anEditor navigator
		whenAdded: [ :anEvent | theAddedEvents add: anEvent ];
		whenMoved: [ :anEvent | theMovedEvents add: anEvent ];
		whenRemoved: [ :anEvent | theRemovedEvents add: anEvent ];
		moveToLineEnd;
		apply;
		unsubscribe.
		
	self assert: anEditor cursors isEmpty.
	
	self assert: theAddedEvents isEmpty.
	self assert: theMovedEvents isEmpty.
	self assert: theRemovedEvents isEmpty.
	
	^ anEditor
]

{ #category : #'examples - move to line start' }
AlbTextEditorNavigatorTest >> test_cursor_moveToLineStart_in_cursors_at_0 [
	
	<label: 'Cursor before the first character should not be moved'>
	| anEditor theAddedEvents theMovedEvents theRemovedEvents |
	
	anEditor := self test_cursor_add_at_0_in_empty.
	
	theAddedEvents := OrderedCollection new.
	theMovedEvents := OrderedCollection new.
	theRemovedEvents := OrderedCollection new.

	anEditor navigator
		whenAdded: [ :anEvent | theAddedEvents add: anEvent ];
		whenMoved: [ :anEvent | theMovedEvents add: anEvent ];
		whenRemoved: [ :anEvent | theRemovedEvents add: anEvent ];
		moveToLineStart;
		apply;
		unsubscribe.
		
	self assert: anEditor cursors isNotEmpty.
	self assert: anEditor cursors allCursors equals: { AlbTextEditorSingleCursor new position: 0 }.
	
	self assert: theAddedEvents isEmpty.
	self assert: theMovedEvents isEmpty.
	self assert: theRemovedEvents isEmpty.
	
	^ anEditor
]

{ #category : #'examples - move to line start' }
AlbTextEditorNavigatorTest >> test_cursor_moveToLineStart_in_cursors_at_1 [
	
	<label: 'Cursor after the first character moves before the start of the text'>
	| anEditor theAddedEvents theMovedEvents theRemovedEvents |
	
	anEditor := self test_cursor_moveTo_1_in_cursors_at_0.
	
	theAddedEvents := OrderedCollection new.
	theMovedEvents := OrderedCollection new.
	theRemovedEvents := OrderedCollection new.

	anEditor navigator
		whenAdded: [ :anEvent | theAddedEvents add: anEvent ];
		whenMoved: [ :anEvent | theMovedEvents add: anEvent ];
		whenRemoved: [ :anEvent | theRemovedEvents add: anEvent ];
		moveToLineStart;
		apply;
		unsubscribe.
		
	self assert: anEditor cursors isNotEmpty.
	self assert: anEditor cursors allCursors equals: { AlbTextEditorSingleCursor new position: 0 }.
	
	self assert: theAddedEvents isEmpty.
	self assert: theMovedEvents size equals: 1.
	self assert: theMovedEvents first cursor equals: (AlbTextEditorSingleCursor new position: 0).
	self assert: theMovedEvents first oldIndex equals: 1.
	self assert: theMovedEvents first newIndex equals: 0.
	self assert: theRemovedEvents isEmpty.
	
	^ anEditor
]

{ #category : #'examples - move to line start' }
AlbTextEditorNavigatorTest >> test_cursor_moveToLineStart_in_cursors_at_27 [
	
	<label: 'Cursor before the last character of the line should move to the start'>
	| anEditor theAddedEvents theMovedEvents theRemovedEvents |
	
	anEditor := self test_cursor_add_at_0_in_empty.
	anEditor navigator
		moveTo: 27;
		apply.
	
	theAddedEvents := OrderedCollection new.
	theMovedEvents := OrderedCollection new.
	theRemovedEvents := OrderedCollection new.

	anEditor navigator
		whenAdded: [ :anEvent | theAddedEvents add: anEvent ];
		whenMoved: [ :anEvent | theMovedEvents add: anEvent ];
		whenRemoved: [ :anEvent | theRemovedEvents add: anEvent ];
		moveToLineStart;
		apply;
		unsubscribe.
		
	self assert: anEditor cursors isNotEmpty.
	self assert: anEditor cursors allCursors equals: { AlbTextEditorSingleCursor new position: 0 }.
	
	self assert: theAddedEvents isEmpty.
	self assert: theMovedEvents size equals: 1.
	self assert: theMovedEvents first cursor equals: (AlbTextEditorSingleCursor new position: 0).
	self assert: theMovedEvents first oldIndex equals: 27.
	self assert: theMovedEvents first newIndex equals: 0.
	self assert: theRemovedEvents isEmpty.
	
	^ anEditor
]

{ #category : #'examples - move to line start' }
AlbTextEditorNavigatorTest >> test_cursor_moveToLineStart_in_cursors_at_28 [
	
	<label: 'Cursor after the last character of the line should move to to the start'>
	| anEditor theAddedEvents theMovedEvents theRemovedEvents |
	
	anEditor := self test_cursor_add_at_0_in_empty.
	anEditor navigator
		moveTo: 28;
		apply.
	
	theAddedEvents := OrderedCollection new.
	theMovedEvents := OrderedCollection new.
	theRemovedEvents := OrderedCollection new.

	anEditor navigator
		whenAdded: [ :anEvent | theAddedEvents add: anEvent ];
		whenMoved: [ :anEvent | theMovedEvents add: anEvent ];
		whenRemoved: [ :anEvent | theRemovedEvents add: anEvent ];
		moveToLineStart;
		apply;
		unsubscribe.
		
	self assert: anEditor cursors isNotEmpty.
	self assert: anEditor cursors allCursors equals: { AlbTextEditorSingleCursor new position: 0 }.
	
	self assert: theAddedEvents isEmpty.
	self assert: theMovedEvents size equals: 1.
	self assert: theMovedEvents first cursor equals: (AlbTextEditorSingleCursor new position: 0).
	self assert: theMovedEvents first oldIndex equals: 28.
	self assert: theMovedEvents first newIndex equals: 0.
	self assert: theRemovedEvents isEmpty.
	
	^ anEditor
]

{ #category : #'examples - move to line start' }
AlbTextEditorNavigatorTest >> test_cursor_moveToLineStart_in_cursors_at_29 [
	
	<label: 'Cursor before the first character of the line should not move'>
	| anEditor theAddedEvents theMovedEvents theRemovedEvents |
	
	anEditor := self test_cursor_add_at_0_in_empty.
	anEditor navigator
		moveTo: 29;
		apply.
	
	theAddedEvents := OrderedCollection new.
	theMovedEvents := OrderedCollection new.
	theRemovedEvents := OrderedCollection new.

	anEditor navigator
		whenAdded: [ :anEvent | theAddedEvents add: anEvent ];
		whenMoved: [ :anEvent | theMovedEvents add: anEvent ];
		whenRemoved: [ :anEvent | theRemovedEvents add: anEvent ];
		moveToLineStart;
		apply;
		unsubscribe.
		
	self assert: anEditor cursors isNotEmpty.
	self assert: anEditor cursors allCursors equals: { AlbTextEditorSingleCursor new position: 29 }.

	self assert: theAddedEvents isEmpty.
	self assert: theMovedEvents isEmpty.
	self assert: theRemovedEvents isEmpty.
	
	^ anEditor
]

{ #category : #'examples - move to line start' }
AlbTextEditorNavigatorTest >> test_cursor_moveToLineStart_in_cursors_at_30 [
	
	<label: 'Cursor after the first character of the line should move to the start of that line'>
	| anEditor theAddedEvents theMovedEvents theRemovedEvents |
	
	anEditor := self test_cursor_add_at_0_in_empty.
	anEditor navigator
		moveTo: 30;
		apply.
	
	theAddedEvents := OrderedCollection new.
	theMovedEvents := OrderedCollection new.
	theRemovedEvents := OrderedCollection new.

	anEditor navigator
		whenAdded: [ :anEvent | theAddedEvents add: anEvent ];
		whenMoved: [ :anEvent | theMovedEvents add: anEvent ];
		whenRemoved: [ :anEvent | theRemovedEvents add: anEvent ];
		moveToLineStart;
		apply;
		unsubscribe.
		
	self assert: anEditor cursors isNotEmpty.
	self assert: anEditor cursors allCursors equals: { AlbTextEditorSingleCursor new position: 29 }.

	self assert: theAddedEvents isEmpty.
	self assert: theMovedEvents size equals: 1.
	self assert: theMovedEvents first cursor equals: (AlbTextEditorSingleCursor new position: 29).
	self assert: theMovedEvents first oldIndex equals: 30.
	self assert: theMovedEvents first newIndex equals: 29.
	self assert: theRemovedEvents isEmpty.
	
	^ anEditor
]

{ #category : #'examples - move to line start' }
AlbTextEditorNavigatorTest >> test_cursor_moveToLineStart_in_cursors_at_40 [
	
	<label: 'Cursor before the last character of the line should move to the start of that line'>
	| anEditor theAddedEvents theMovedEvents theRemovedEvents |
	
	anEditor := self test_cursor_add_at_0_in_empty.
	anEditor navigator
		moveTo: 40;
		apply.
	
	theAddedEvents := OrderedCollection new.
	theMovedEvents := OrderedCollection new.
	theRemovedEvents := OrderedCollection new.

	anEditor navigator
		whenAdded: [ :anEvent | theAddedEvents add: anEvent ];
		whenMoved: [ :anEvent | theMovedEvents add: anEvent ];
		whenRemoved: [ :anEvent | theRemovedEvents add: anEvent ];
		moveToLineStart;
		apply;
		unsubscribe.
		
	self assert: anEditor cursors isNotEmpty.
	self assert: anEditor cursors allCursors equals: { AlbTextEditorSingleCursor new position: 29 }.

	self assert: theAddedEvents isEmpty.
	self assert: theMovedEvents size equals: 1.
	self assert: theMovedEvents first cursor equals: (AlbTextEditorSingleCursor new position: 29).
	self assert: theMovedEvents first oldIndex equals: 40.
	self assert: theMovedEvents first newIndex equals: 29.
	self assert: theRemovedEvents isEmpty.
	
	^ anEditor
]

{ #category : #'examples - move to line start' }
AlbTextEditorNavigatorTest >> test_cursor_moveToLineStart_in_cursors_at_41 [
	
	<label: 'Cursor after the last character of the line should move to the start of that line'>
	| anEditor theAddedEvents theMovedEvents theRemovedEvents |
	
	anEditor := self test_cursor_add_at_0_in_empty.
	anEditor navigator
		moveTo: 41;
		apply.
	
	theAddedEvents := OrderedCollection new.
	theMovedEvents := OrderedCollection new.
	theRemovedEvents := OrderedCollection new.

	anEditor navigator
		whenAdded: [ :anEvent | theAddedEvents add: anEvent ];
		whenMoved: [ :anEvent | theMovedEvents add: anEvent ];
		whenRemoved: [ :anEvent | theRemovedEvents add: anEvent ];
		moveToLineStart;
		apply;
		unsubscribe.
		
	self assert: anEditor cursors isNotEmpty.
	self assert: anEditor cursors allCursors equals: { AlbTextEditorSingleCursor new position: 29 }.

	self assert: theAddedEvents isEmpty.
	self assert: theMovedEvents size equals: 1.
	self assert: theMovedEvents first cursor equals: (AlbTextEditorSingleCursor new position: 29).
	self assert: theMovedEvents first oldIndex equals: 41.
	self assert: theMovedEvents first newIndex equals: 29.
	self assert: theRemovedEvents isEmpty.
	
	^ anEditor
]

{ #category : #'examples - move to line start' }
AlbTextEditorNavigatorTest >> test_cursor_moveToLineStart_in_empty [
	
	| anEditor theAddedEvents theMovedEvents theRemovedEvents |
	
	anEditor := self test_editorOnMultilineText.
	
	theAddedEvents := OrderedCollection new.
	theMovedEvents := OrderedCollection new.
	theRemovedEvents := OrderedCollection new.

	anEditor navigator
		whenAdded: [ :anEvent | theAddedEvents add: anEvent ];
		whenMoved: [ :anEvent | theMovedEvents add: anEvent ];
		whenRemoved: [ :anEvent | theRemovedEvents add: anEvent ];
		moveToLineStart;
		apply;
		unsubscribe.
		
	self assert: anEditor cursors isEmpty.
	
	self assert: theAddedEvents isEmpty.
	self assert: theMovedEvents isEmpty.
	self assert: theRemovedEvents isEmpty.
	
	^ anEditor
]

{ #category : #'examples - move to line end' }
AlbTextEditorNavigatorTest >> test_cursor_moveToNextWord_in_cursors_at_0 [
	
	"Differs from Brick version but : this nextWord behavior seems ok and its implementation remains simple, so keep it"
	| anEditor theAddedEvents theMovedEvents theRemovedEvents |
	
	anEditor := self test_cursor_add_at_0_in_empty.
	
	theAddedEvents := OrderedCollection new.
	theMovedEvents := OrderedCollection new.
	theRemovedEvents := OrderedCollection new.

	anEditor navigator
		whenAdded: [ :anEvent | theAddedEvents add: anEvent ];
		whenMoved: [ :anEvent | theMovedEvents add: anEvent ];
		whenRemoved: [ :anEvent | theRemovedEvents add: anEvent ];
		moveToEndNextWord;
		apply;
		unsubscribe.
		
	self assert: anEditor cursors isNotEmpty.
	self assert: anEditor cursors allCursors equals: { AlbTextEditorSingleCursor new position: 1 }.
	
	self assert: theAddedEvents isEmpty.
	self assert: theMovedEvents size equals: 1.
	self assert: theMovedEvents first cursor equals: (AlbTextEditorSingleCursor new position: 1).
	self assert: theMovedEvents first oldIndex equals: 0.
	self assert: theMovedEvents first newIndex equals: 1.
	self assert: theRemovedEvents isEmpty.
	
	^ anEditor
]

{ #category : #'examples - move to line end' }
AlbTextEditorNavigatorTest >> test_cursor_moveToNextWord_in_cursors_at_1 [
	
	<label: 'Cursor before the first character of the line should move to the end'>
	| anEditor theAddedEvents theMovedEvents theRemovedEvents |
	
	anEditor := self test_cursor_add_at_1_in_empty.
	
	theAddedEvents := OrderedCollection new.
	theMovedEvents := OrderedCollection new.
	theRemovedEvents := OrderedCollection new.

	anEditor navigator
		whenAdded: [ :anEvent | theAddedEvents add: anEvent ];
		whenMoved: [ :anEvent | theMovedEvents add: anEvent ];
		whenRemoved: [ :anEvent | theRemovedEvents add: anEvent ];
		moveToEndNextWord;
		apply;
		unsubscribe.
		
	self assert: anEditor cursors isNotEmpty.
	self assert: anEditor cursors allCursors equals: { AlbTextEditorSingleCursor new position: 8 }.
	
	self assert: theAddedEvents isEmpty.
	self assert: theMovedEvents size equals: 1.
	self assert: theMovedEvents first cursor equals: (AlbTextEditorSingleCursor new position: 8).
	self assert: theMovedEvents first oldIndex equals: 1.
	self assert: theMovedEvents first newIndex equals: 8.
	self assert: theRemovedEvents isEmpty.
	
	^ anEditor
]

{ #category : #'examples - move to line end' }
AlbTextEditorNavigatorTest >> test_cursor_moveToPreviousWord_in_cursors_at_1 [
	
	<label: 'Cursor before the first character of the line should move to the end'>
	| anEditor theAddedEvents theMovedEvents theRemovedEvents |
	
	anEditor := self test_cursor_add_at_1_in_empty.
	
	theAddedEvents := OrderedCollection new.
	theMovedEvents := OrderedCollection new.
	theRemovedEvents := OrderedCollection new.

	anEditor navigator
		whenAdded: [ :anEvent | theAddedEvents add: anEvent ];
		whenMoved: [ :anEvent | theMovedEvents add: anEvent ];
		whenRemoved: [ :anEvent | theRemovedEvents add: anEvent ];
		moveToStartPreviousWord;
		apply;
		unsubscribe.
		
	self assert: anEditor cursors isNotEmpty.
	self assert: anEditor cursors allCursors equals: { AlbTextEditorSingleCursor new position: 0 }.
	
	self assert: theAddedEvents isEmpty.
	self assert: theMovedEvents size equals: 1.
	self assert: theMovedEvents first cursor equals: (AlbTextEditorSingleCursor new position: 0).
	self assert: theMovedEvents first oldIndex equals: 1.
	self assert: theMovedEvents first newIndex equals: 0.
	self assert: theRemovedEvents isEmpty.
	
	^ anEditor
]

{ #category : #'examples - move to line end' }
AlbTextEditorNavigatorTest >> test_cursor_moveToPreviousWord_in_cursors_at_2 [
	
	<label: 'Cursor before the first character of the line should move to the end'>
	| anEditor theAddedEvents theMovedEvents theRemovedEvents |
	
	anEditor := self test_cursor_add_at_2_in_empty.
	
	theAddedEvents := OrderedCollection new.
	theMovedEvents := OrderedCollection new.
	theRemovedEvents := OrderedCollection new.

	anEditor navigator
		whenAdded: [ :anEvent | theAddedEvents add: anEvent ];
		whenMoved: [ :anEvent | theMovedEvents add: anEvent ];
		whenRemoved: [ :anEvent | theRemovedEvents add: anEvent ];
		moveToStartPreviousWord;
		apply;
		unsubscribe.
		
	self assert: anEditor cursors isNotEmpty.
	self assert: anEditor cursors allCursors equals: { AlbTextEditorSingleCursor new position: 0 }.
	
	self assert: theAddedEvents isEmpty.
	self assert: theMovedEvents size equals: 1.
	self assert: theMovedEvents first cursor equals: (AlbTextEditorSingleCursor new position: 0).
	self assert: theMovedEvents first oldIndex equals: 2.
	self assert: theMovedEvents first newIndex equals: 0.
	self assert: theRemovedEvents isEmpty.
	
	^ anEditor
]

{ #category : #'examples - move to line end' }
AlbTextEditorNavigatorTest >> test_cursor_moveToPreviousWord_in_cursors_at_8 [
	
	<label: 'Cursor before the first character of the line should move to the end'>
	| anEditor theAddedEvents theMovedEvents theRemovedEvents |
	
	anEditor := self test_cursor_add_at_8_in_empty.
	
	theAddedEvents := OrderedCollection new.
	theMovedEvents := OrderedCollection new.
	theRemovedEvents := OrderedCollection new.

	anEditor navigator
		whenAdded: [ :anEvent | theAddedEvents add: anEvent ];
		whenMoved: [ :anEvent | theMovedEvents add: anEvent ];
		whenRemoved: [ :anEvent | theRemovedEvents add: anEvent ];
		moveToStartPreviousWord;
		apply;
		unsubscribe.
		
	self assert: anEditor cursors isNotEmpty.
	self assert: (anEditor cursors allCursors 
			includes: (AlbTextEditorSingleCursor new position: 0 )).
	self assert: (anEditor cursors allCursors 
			includes: (AlbTextEditorSingleCursor new position: 2 )).
	
	self assert: theAddedEvents isEmpty.
	self assert: theMovedEvents size equals: 1.
	self assert: theMovedEvents first cursor equals: (AlbTextEditorSingleCursor new position: 2).
	self assert: theMovedEvents first oldIndex equals: 8.
	self assert: theMovedEvents first newIndex equals: 2.
	self assert: theRemovedEvents isEmpty.
	
	^ anEditor
]

{ #category : #'examples - move to screen' }
AlbTextEditorNavigatorTest >> test_cursor_moveToScreen_1_left_half_in_empty [
	
	<label: 'Click on the left half of the first character'>
	| anEditor theAddedEvents theMovedEvents theRemovedEvents |

	anEditor := self test_editorOnMultilineText.

	theAddedEvents := OrderedCollection new.
	theMovedEvents := OrderedCollection new.
	theRemovedEvents := OrderedCollection new.

	anEditor navigator
		whenAdded: [ :anEvent | theAddedEvents add: anEvent ];
		whenMoved: [ :anEvent | theMovedEvents add: anEvent ];
		whenRemoved: [ :anEvent | theRemovedEvents add: anEvent ];
		moveToScreenPosition: (self paragraphMargin left + (self glyphWidth / 2.0) - 1) @ (self paragraphMargin top + (self glyphHeight / 2.0));
		apply;
		unsubscribe.

	self assert: anEditor cursors isNotEmpty.
	self assert: anEditor cursors equals: (AlbTextEditorCursor atAll: #(0)).

	self assert: theAddedEvents size equals: 1.
	self assert: (theAddedEvents collect: #cursor) asArray equals: (AlbTextEditorCursor atAll: #(0)) allCursors.
	self assert: theMovedEvents isEmpty.
	self assert: theRemovedEvents isEmpty.
	
	^ anEditor
]

{ #category : #'examples - move to screen' }
AlbTextEditorNavigatorTest >> test_cursor_moveToScreen_1_left_in_empty [
	
	<label: 'Click on a whitespace to the left from the first character'>
	| anEditor theAddedEvents theMovedEvents theRemovedEvents |
	
	anEditor := self test_editorOnMultilineText.
	
	theAddedEvents := OrderedCollection new.
	theMovedEvents := OrderedCollection new.
	theRemovedEvents := OrderedCollection new.

	anEditor navigator
		whenAdded: [ :anEvent | theAddedEvents add: anEvent ];
		whenMoved: [ :anEvent | theMovedEvents add: anEvent ];
		whenRemoved: [ :anEvent | theRemovedEvents add: anEvent ];
		moveToScreenPosition: (self paragraphMargin left / 2.0) @ (self paragraphMargin top + (self glyphHeight / 2.0));
		apply;
		unsubscribe.

	self assert: anEditor cursors isNotEmpty.
	self assert: anEditor cursors equals: (AlbTextEditorCursor atAll: #(0)).
	
	self assert: theAddedEvents size equals: 1.
	self assert: (theAddedEvents collect: #cursor) asArray equals: (AlbTextEditorCursor atAll: #(0)) allCursors.
	self assert: theMovedEvents isEmpty.
	self assert: theRemovedEvents isEmpty.
	
	^ anEditor
]

{ #category : #'examples - move to screen' }
AlbTextEditorNavigatorTest >> test_cursor_moveToScreen_1_middle_in_empty [
	
	<label: 'Click right in the middle of the first character'>
	| anEditor theAddedEvents theMovedEvents theRemovedEvents |
	
	anEditor := self test_editorOnMultilineText.
	
	theAddedEvents := OrderedCollection new.
	theMovedEvents := OrderedCollection new.
	theRemovedEvents := OrderedCollection new.

	anEditor navigator
		whenAdded: [ :anEvent | theAddedEvents add: anEvent ];
		whenMoved: [ :anEvent | theMovedEvents add: anEvent ];
		whenRemoved: [ :anEvent | theRemovedEvents add: anEvent ];
		moveToScreenPosition: (self paragraphMargin left + (self glyphWidth / 2.0)) @ (self paragraphMargin top + (self glyphHeight / 2.0));
		apply;
		unsubscribe.
		
	self assert: anEditor cursors isNotEmpty.
	self assert: anEditor cursors equals: (AlbTextEditorCursor atAll: #(0)).
	
	self assert: theAddedEvents size equals: 1.
	self assert: (theAddedEvents collect: #cursor) asArray equals: (AlbTextEditorCursor atAll: #(0)) allCursors.
	self assert: theMovedEvents isEmpty.
	self assert: theRemovedEvents isEmpty.
	
	^ anEditor
]

{ #category : #'examples - move to screen' }
AlbTextEditorNavigatorTest >> test_cursor_moveToScreen_1_right_half_in_empty [
	
	<label: 'Click on the right half of the first character'>
	| anEditor theAddedEvents theMovedEvents theRemovedEvents |
	
	anEditor := self test_editorOnMultilineText.
	
	theAddedEvents := OrderedCollection new.
	theMovedEvents := OrderedCollection new.
	theRemovedEvents := OrderedCollection new.

	anEditor navigator
		whenAdded: [ :anEvent | theAddedEvents add: anEvent ];
		whenMoved: [ :anEvent | theMovedEvents add: anEvent ];
		whenRemoved: [ :anEvent | theRemovedEvents add: anEvent ];
		moveToScreenPosition: (self paragraphMargin left + (self glyphWidth / 2.0) + 1) @ (self paragraphMargin top + (self glyphHeight / 2.0));
		apply;
		unsubscribe.
		
	self assert: anEditor cursors isNotEmpty.
	self assert: anEditor cursors equals: (AlbTextEditorCursor atAll: #(1)).
	
	self assert: theAddedEvents size equals: 1.
	self assert: (theAddedEvents collect: #cursor) asArray equals: (AlbTextEditorCursor atAll: #(1)) allCursors.
	self assert: theMovedEvents isEmpty.
	self assert: theRemovedEvents isEmpty.
	
	^ anEditor
]

{ #category : #'examples - move to screen' }
AlbTextEditorNavigatorTest >> test_cursor_moveToScreen_41_right_in_empty [
	
	<label: 'Click on the right half of the 41th character'>
	| anEditor theAddedEvents theMovedEvents theRemovedEvents |

	anEditor := self test_editorOnMultilineText.

	theAddedEvents := OrderedCollection new.
	theMovedEvents := OrderedCollection new.
	theRemovedEvents := OrderedCollection new.

	anEditor navigator
		whenAdded: [ :anEvent | theAddedEvents add: anEvent ];
		whenMoved: [ :anEvent | theMovedEvents add: anEvent ];
		whenRemoved: [ :anEvent | theRemovedEvents add: anEvent ];
		moveToScreenPosition: (400@100);
		apply;
		unsubscribe.

	self assert: anEditor cursors isNotEmpty.
	self assert: anEditor cursors equals: (AlbTextEditorCursor atAll: #(41)).

	self assert: theAddedEvents size equals: 1.
	self assert: (theAddedEvents collect: #cursor) asArray equals: (AlbTextEditorCursor atAll: #(41)) allCursors.
	self assert: theMovedEvents isEmpty.
	self assert: theRemovedEvents isEmpty.
	
	^ anEditor
]

{ #category : #'examples - move to' }
AlbTextEditorNavigatorTest >> test_cursor_moveTo_0_in_cursors_at_0_and_1 [
	
	| anEditor theAddedEvents theMovedEvents theRemovedEvents |
	
	anEditor := self test_cursor_add_at_0_and_1_in_empty.
	
	theAddedEvents := OrderedCollection new.
	theMovedEvents := OrderedCollection new.
	theRemovedEvents := OrderedCollection new.

	anEditor navigator
		whenAdded: [ :anEvent | theAddedEvents add: anEvent ];
		whenMoved: [ :anEvent | theMovedEvents add: anEvent ];
		whenRemoved: [ :anEvent | theRemovedEvents add: anEvent ];
		"even though it is a move event, what actually happens is we need to delete one cursor at (1) because the other one is already at the target position"
		moveTo: 0;
		apply;
		unsubscribe.

	self assert: anEditor cursors isNotEmpty.
	self assert: anEditor cursors allCursors equals: { AlbTextEditorSingleCursor new position: 0 }.
	
	self assert: theAddedEvents isEmpty.
	self assert: theMovedEvents isEmpty.
	self assert: theRemovedEvents size equals: 1.
	self assert: (theRemovedEvents collect: #cursor) asArray equals: {
		AlbTextEditorSingleCursor new position: 1
	}.
	
	^ anEditor
]

{ #category : #'examples - move to' }
AlbTextEditorNavigatorTest >> test_cursor_moveTo_0_in_empty [
	
	| anEditor theAddedEvents theMovedEvents theRemovedEvents |
	
	anEditor := self test_editorOnMultilineText.
	
	theAddedEvents := OrderedCollection new.
	theMovedEvents := OrderedCollection new.
	theRemovedEvents := OrderedCollection new.

	anEditor navigator
		whenAdded: [ :anEvent | theAddedEvents add: anEvent ];
		whenMoved: [ :anEvent | theMovedEvents add: anEvent ];
		whenRemoved: [ :anEvent | theRemovedEvents add: anEvent ];
		moveTo: 0;
		apply;
		unsubscribe.
		
	self assert: anEditor cursors isNotEmpty.
	self assert: anEditor cursors allCursors equals: { AlbTextEditorSingleCursor new position: 0 }.
	
	self assert: theAddedEvents size equals: 1.
	self assert: (theAddedEvents collect: #cursor) asArray equals: {
		AlbTextEditorSingleCursor new position: 0.
	}.
	self assert: theMovedEvents isEmpty.
	self assert: theRemovedEvents isEmpty.
	
	^ anEditor
]

{ #category : #'examples - move to' }
AlbTextEditorNavigatorTest >> test_cursor_moveTo_190_in_empty [
	
	| anEditor theAddedEvents theMovedEvents theRemovedEvents |
	
	anEditor := self test_editorOnMultilineText.
	
	theAddedEvents := OrderedCollection new.
	theMovedEvents := OrderedCollection new.
	theRemovedEvents := OrderedCollection new.

	anEditor navigator
		whenAdded: [ :anEvent | theAddedEvents add: anEvent ];
		whenMoved: [ :anEvent | theMovedEvents add: anEvent ];
		whenRemoved: [ :anEvent | theRemovedEvents add: anEvent ];
		moveTo: 190;
		apply;
		unsubscribe.
		
	self assert: anEditor cursors isNotEmpty.
	self assert: anEditor cursors allCursors equals: { AlbTextEditorSingleCursor new position: 190 }.
	
	self assert: theAddedEvents size equals: 1.
	self assert: (theAddedEvents collect: #cursor) asArray equals: {
		AlbTextEditorSingleCursor new position: 190.
	}.
	self assert: theMovedEvents isEmpty.
	self assert: theRemovedEvents isEmpty.
	
	^ anEditor
]

{ #category : #'examples - move to' }
AlbTextEditorNavigatorTest >> test_cursor_moveTo_1_in_cursors_at_0 [
	
	| anEditor theAddedEvents theMovedEvents theRemovedEvents |
	
	anEditor := self test_cursor_add_at_0_in_empty.
	
	theAddedEvents := OrderedCollection new.
	theMovedEvents := OrderedCollection new.
	theRemovedEvents := OrderedCollection new.

	anEditor navigator
		whenAdded: [ :anEvent | theAddedEvents add: anEvent ];
		whenMoved: [ :anEvent | theMovedEvents add: anEvent ];
		whenRemoved: [ :anEvent | theRemovedEvents add: anEvent ];
		moveTo: 1;
		apply;
		unsubscribe.

	self assert: anEditor cursors isNotEmpty.
	self assert: anEditor cursors allCursors equals: { AlbTextEditorSingleCursor new position: 1 }.
	
	self assert: theAddedEvents isEmpty.
	self assert: theMovedEvents size equals: 1.
	self assert: theMovedEvents first cursor equals: (AlbTextEditorSingleCursor new position: 1).
	self assert: theMovedEvents first oldIndex equals: 0.
	self assert: theMovedEvents first newIndex equals: 1.
	self assert: theRemovedEvents isEmpty.
	
	^ anEditor
]

{ #category : #'examples - move to' }
AlbTextEditorNavigatorTest >> test_cursor_moveTo_2_in_cursors_at_0_and_1 [
	
	| anEditor theAddedEvents theMovedEvents theRemovedEvents |

	anEditor := self test_cursor_add_at_0_and_1_in_empty.

	theAddedEvents := OrderedCollection new.
	theMovedEvents := OrderedCollection new.
	theRemovedEvents := OrderedCollection new.

	anEditor navigator
		whenAdded: [ :anEvent | theAddedEvents add: anEvent ];
		whenMoved: [ :anEvent | theMovedEvents add: anEvent ];
		whenRemoved: [ :anEvent | theRemovedEvents add: anEvent ];
		moveTo: 2;
		apply;
		unsubscribe.

	self assert: anEditor cursors isNotEmpty.
	self assert: anEditor cursors allCursors equals: { AlbTextEditorSingleCursor new position: 2 }.

	self assert: theAddedEvents isEmpty.
	self assert: theMovedEvents size equals: 1.
	self assert: theMovedEvents first cursor equals: (AlbTextEditorSingleCursor new position: 2).
	self assert: theMovedEvents first oldIndex equals: 0.
	self assert: theMovedEvents first newIndex equals: 2.
	self assert: theRemovedEvents size equals: 1.
	self assert: (theRemovedEvents collect: #cursor) asArray equals: {
		AlbTextEditorSingleCursor new position: 1
	}.

	^ anEditor
]

{ #category : #'examples - move to' }
AlbTextEditorNavigatorTest >> test_cursor_moveTo_67_in_cursors_at_68 [
	
	| anEditor theAddedEvents theMovedEvents theRemovedEvents addedCursorElements removedCursorElements |
	
	anEditor := self test_cursor_add_at_68_in_empty.
	
	theAddedEvents := OrderedCollection new.
	theMovedEvents := OrderedCollection new.
	theRemovedEvents := OrderedCollection new.
	addedCursorElements := OrderedCollection new.
	removedCursorElements := OrderedCollection new.
	
	self subscribe: AlbTextEditorCursorElementAddedEvent do: [ :anEvent | addedCursorElements add: anEvent cursorElement ] for: anEditor.
	self subscribe: AlbTextEditorCursorElementRemovedEvent do: [ :anEvent | removedCursorElements add: anEvent cursorElement ] for: anEditor.

	anEditor navigator
		whenAdded: [ :anEvent | theAddedEvents add: anEvent ];
		whenMoved: [ :anEvent | theMovedEvents add: anEvent ];
		whenRemoved: [ :anEvent | theRemovedEvents add: anEvent ];
		moveTo: 67;
		apply;
		unsubscribe.
	
	anEditor forceLayout.

	self unsubscribe: AlbTextEditorCursorElementAddedEvent from: anEditor.
	self unsubscribe: AlbTextEditorCursorElementRemovedEvent from: anEditor.
	
	self assert: anEditor cursors isNotEmpty.
	self assert: anEditor cursors allCursors equals: { AlbTextEditorSingleCursor new position: 67 }.
	
	self assert: theAddedEvents isEmpty.
	self assert: theMovedEvents size equals: 1.
	self assert: theMovedEvents first cursor equals: (AlbTextEditorSingleCursor new position: 67).
	self assert: theMovedEvents first oldIndex equals: 68.
	self assert: theMovedEvents first newIndex equals: 67.
	self assert: theRemovedEvents isEmpty.
	
	self assert: addedCursorElements size equals: 1.
	self assert: addedCursorElements first textPosition equals: 6.
	self assert: removedCursorElements size equals: 1.
	self assert: removedCursorElements first textPosition equals: 0.
	
	^ anEditor
]

{ #category : #'examples - move up' }
AlbTextEditorNavigatorTest >> test_cursor_moveUp_in_cursors_at_1 [
	
	| anEditor theAddedEvents theMovedEvents theRemovedEvents theReachBoudnaryEvents |
	
	anEditor := self test_cursor_add_at_1_in_empty.
	
	theAddedEvents := OrderedCollection new.
	theMovedEvents := OrderedCollection new.
	theRemovedEvents := OrderedCollection new.
	theReachBoudnaryEvents := OrderedCollection new.

	anEditor navigator
		whenAdded: [ :anEvent | theAddedEvents add: anEvent ];
		whenMoved: [ :anEvent | theMovedEvents add: anEvent ];
		whenRemoved: [ :anEvent | theRemovedEvents add: anEvent ];
		whenReachedBoundary: [ :anEvent | theReachBoudnaryEvents add: anEvent ];
		moveUp;
		apply;
		unsubscribe.

	self assert: anEditor cursors isNotEmpty.
	self assert: anEditor cursors allCursors equals: { AlbTextEditorSingleCursor new position: 0 }.
	
	self assert: theAddedEvents isEmpty.
	self assert: theMovedEvents size equals: 1.
	self assert: theMovedEvents first cursor equals: (AlbTextEditorSingleCursor new position: 0).
	self assert: theMovedEvents first oldIndex equals: 1.
	self assert: theMovedEvents first newIndex equals: 0.
	self assert: theRemovedEvents isEmpty.
	self assert: theReachBoudnaryEvents size equals: 1.
	self assert: theReachBoudnaryEvents first cursor equals: (AlbTextEditorSingleCursor new position: 0).
	self assert: theReachBoudnaryEvents first isTop.
	
	^ anEditor
]

{ #category : #'examples - performance' }
AlbTextEditorNavigatorTest >> test_cursor_move_from_1_to_2_does_not_rebuild_editor [
	
	| anEditor thePreviousSegments theNewSegments thePreviousTextPieces theNewTextPieces |

	anEditor := self test_cursor_add_at_1_does_not_rebuild_editor.

	thePreviousSegments := anEditor children
		select: [ :eachChild | eachChild isKindOf: AlbTextEditorSegmentElement ].	
	self assert: thePreviousSegments size equals: 11.

	thePreviousTextPieces := thePreviousSegments flatCollect: [ :eachSegment | eachSegment children asArray ].
	self assert: thePreviousTextPieces size equals: 63.

	anEditor navigator
		moveTo: 2;
		apply.

	anEditor forceLayout.

	self assert: anEditor cursors allCursors equals: { AlbTextEditorSingleCursor new position: 2 }.
	
	theNewSegments := anEditor children
		select: [ :eachChild | eachChild isKindOf: AlbTextEditorSegmentElement ].	
	self assert: theNewSegments size equals: 11.
	
	theNewTextPieces := theNewSegments flatCollect: [ :eachSegment | eachSegment children asArray ].
	self assert: theNewTextPieces size equals: 63.
	
	self assert: thePreviousSegments equals: theNewSegments.
	self assert: thePreviousTextPieces equals: theNewTextPieces.
	
	^ anEditor
]

{ #category : #'examples - remove' }
AlbTextEditorNavigatorTest >> test_cursor_removeAll_in_cursors_at_0_and_1 [
	
	| anEditor theAddedEvents theMovedEvents theRemovedEvents |
	
	anEditor := self test_cursor_add_at_0_and_1_in_empty.

	theAddedEvents := OrderedCollection new.
	theMovedEvents := OrderedCollection new.
	theRemovedEvents := OrderedCollection new.

	anEditor navigator
		whenAdded: [ :anEvent | theAddedEvents add: anEvent ];
		whenMoved: [ :anEvent | theMovedEvents add: anEvent ];
		whenRemoved: [ :anEvent | theRemovedEvents add: anEvent ];
		removeAll;
		apply;
		unsubscribe.

	self assert: anEditor cursors isEmpty.
	
	self assert: theAddedEvents isEmpty.
	self assert: theMovedEvents isEmpty.
	self assert: theRemovedEvents size equals: 2.
	self assert: (theRemovedEvents collect: #cursor) asArray equals: {
		AlbTextEditorSingleCursor new position: 0.
		AlbTextEditorSingleCursor new position: 1
	}.
	
	^ anEditor
]

{ #category : #'examples - remove' }
AlbTextEditorNavigatorTest >> test_cursor_remove_at_0_in_cursors_at_0 [
	
	| anEditor theAddedEvents theMovedEvents theRemovedEvents |
	
	anEditor := self test_cursor_add_at_0_in_empty.
	
	theAddedEvents := OrderedCollection new.
	theMovedEvents := OrderedCollection new.
	theRemovedEvents := OrderedCollection new.

	anEditor navigator
		whenAdded: [ :anEvent | theAddedEvents add: anEvent ];
		whenMoved: [ :anEvent | theMovedEvents add: anEvent ];
		whenRemoved: [ :anEvent | theRemovedEvents add: anEvent ];
		removeAt: 0;
		apply;
		unsubscribe.

	self assert: anEditor cursors isEmpty.

	self assert: theAddedEvents isEmpty.
	self assert: theMovedEvents isEmpty.
	self assert: theRemovedEvents size equals: 1.
	self assert: (theRemovedEvents collect: #cursor) asArray equals: {
		AlbTextEditorSingleCursor new position: 0.
	}.

	^ anEditor
]

{ #category : #'examples - remove' }
AlbTextEditorNavigatorTest >> test_cursor_remove_at_1_and_0_in_cursors_at_0_and_1 [
	
	| anEditor theAddedEvents theMovedEvents theRemovedEvents |
	
	anEditor := self test_cursor_add_at_0_and_1_in_empty.

	theAddedEvents := OrderedCollection new.
	theMovedEvents := OrderedCollection new.
	theRemovedEvents := OrderedCollection new.

	anEditor navigator
		whenAdded: [ :anEvent | theAddedEvents add: anEvent ];
		whenMoved: [ :anEvent | theMovedEvents add: anEvent ];
		whenRemoved: [ :anEvent | theRemovedEvents add: anEvent ];
		removeAt: 0;
		removeAt: 1;
		apply;
		unsubscribe.

	self assert: anEditor cursors isEmpty.
	
	self assert: theAddedEvents isEmpty.
	self assert: theMovedEvents isEmpty.
	self assert: theRemovedEvents size equals: 2.
	self assert: (theRemovedEvents collect: #cursor) asArray equals: {
		AlbTextEditorSingleCursor new position: 0.
		AlbTextEditorSingleCursor new position: 1
	}.

	^ anEditor
]

{ #category : #'examples - remove' }
AlbTextEditorNavigatorTest >> test_cursor_remove_at_1_in_cursors_at_0_and_1 [
	
	| anEditor theAddedEvents theMovedEvents theRemovedEvents |
	
	anEditor := self test_cursor_add_at_0_and_1_in_empty.

	theAddedEvents := OrderedCollection new.
	theMovedEvents := OrderedCollection new.
	theRemovedEvents := OrderedCollection new.

	anEditor navigator
		whenAdded: [ :anEvent | theAddedEvents add: anEvent ];
		whenMoved: [ :anEvent | theMovedEvents add: anEvent ];
		whenRemoved: [ :anEvent | theRemovedEvents add: anEvent ];
		removeAt: 1;
		apply;
		unsubscribe.

	self assert: anEditor cursors isNotEmpty.
	self assert: anEditor cursors allCursors equals: { AlbTextEditorSingleCursor new position: 0 }.
	
	self assert: theAddedEvents isEmpty.
	self assert: theMovedEvents isEmpty.
	self assert: theRemovedEvents size equals: 1.
	self assert: (theRemovedEvents collect: #cursor) asArray equals: {
		AlbTextEditorSingleCursor new position: 1.
	}.
	
	^ anEditor
]
