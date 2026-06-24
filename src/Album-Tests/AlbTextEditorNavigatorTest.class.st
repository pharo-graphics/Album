Class {
	#name : #AlbTextEditorNavigatorTest,
	#superclass : #AlbTextEditorOperatorTest,
	#category : #'Album-Tests-Operators'
}

{ #category : #'move to line end' }
AlbTextEditorNavigatorTest >> cursor_moveToNextWord_in_cursors_at_0 [

	| anEditor theMovedEvents |
	
	anEditor := self test_cursor_add_at_0_in_multi_lines.
	anEditor openInSpace.
	true ifTrue: [ ^self ].
	theMovedEvents := OrderedCollection new.

	anEditor navigator
		whenMoved: [ :anEvent | theMovedEvents add: anEvent ];
		moveToEndNextWord;
		apply;
		unsubscribe.
		
	self assert: anEditor cursor position equals: 8.
	
	self assert: theMovedEvents size equals: 1.
	self assert: theMovedEvents first cursor equals: (AlbTextEditorSingleCursor new position: 8).
	self assert: theMovedEvents first oldIndex equals: 0.
	self assert: theMovedEvents first newIndex equals: 8.
	
	^ anEditor
]

{ #category : #showroom }
AlbTextEditorNavigatorTest >> editorOnSomeThing [

	^ self editorFor: 'SomeThing todo here'
]

{ #category : #showroom }
AlbTextEditorNavigatorTest >> test_cursor_addAt0_moveNextWord_in_something [

	
	| anEditor |
	anEditor := self editorOnSomeThing.
	anEditor navigator
		moveTo: 0;
		apply.

	self assert: anEditor cursor equals: ( AlbTextEditorSingleCursor new position: 0 ).

	anEditor navigator
		moveToEndNextWord;
		apply.

	self assert: anEditor cursor equals: ( AlbTextEditorSingleCursor new position: 9 ).
	^ anEditor
]

{ #category : #showroom }
AlbTextEditorNavigatorTest >> test_cursor_addAt0_moveNextWord_twice_in_something [
	
	| anEditor |
	anEditor := self test_cursor_addAt0_moveNextWord_in_something.
		
	anEditor navigator
		moveToEndNextWord;
		apply.

	self assert: anEditor cursor equals: ( AlbTextEditorSingleCursor new position: 14 ).
		
	^ anEditor
]

{ #category : #showroom }
AlbTextEditorNavigatorTest >> test_cursor_addAt9_movePreviousWord_in_something [

	
	| anEditor |
	anEditor := self editorOnSomeThing.
	anEditor navigator
		moveTo: 9;
		apply.

	self assert: anEditor cursor equals: ( AlbTextEditorSingleCursor new position: 9 ).

	anEditor navigator
		moveToStartPreviousWord;
		apply.

	self assert: anEditor cursor equals: ( AlbTextEditorSingleCursor new position: 0 ).
	^ anEditor
]

{ #category : #showroom }
AlbTextEditorNavigatorTest >> test_cursor_addAt9_movePreviousWord_twice_in_something [

	
	| anEditor |
	anEditor := self test_cursor_addAt9_movePreviousWord_in_something.

	anEditor navigator
		moveToStartPreviousWord;
		apply.

	self assert: anEditor cursor equals: ( AlbTextEditorSingleCursor new position: 0 ).
	^ anEditor
]

{ #category : #add }
AlbTextEditorNavigatorTest >> test_cursor_add_at_0_in_multi_lines [
	
	| anEditor theMovedEvents anEditorElement |
	
	anEditorElement := self newEditorElementWithMultilineText.
	anEditor := anEditorElement editor.
	
	theMovedEvents := OrderedCollection new.

	anEditor navigator
		whenMoved: [ :anEvent | theMovedEvents add: anEvent ];
		moveTo: 0;
		apply;
		unsubscribe.
		
	anEditorElement forceLayout.

	self assert: anEditor cursor position equals: 0.
	
	self assert: theMovedEvents isEmpty.
	
	^ anEditor
]

{ #category : #performance }
AlbTextEditorNavigatorTest >> test_cursor_add_at_1_does_not_rebuild_editor [
	
	| anEditor thePreviousSegments theNewSegments thePreviousTextPieces theNewTextPieces anEditorElement |
	anEditorElement := self newEditorElementWithMultilineText.
	anEditor := anEditorElement editor.

	thePreviousSegments := anEditorElement infinite children
		select: [ :eachChild | eachChild isKindOf: AlbTextEditorSegmentElement ].	
	self assert: thePreviousSegments size equals: 11.
	
	thePreviousTextPieces := thePreviousSegments flatCollect: [ :eachSegment | eachSegment children asArray ].
	self assert: thePreviousTextPieces size equals: 63.

	anEditor navigator
		moveTo: 1;
		apply.

	anEditorElement forceLayout.

	self assert: anEditor cursor position equals: 1.
	
	theNewSegments := anEditorElement infinite children
		select: [ :eachChild | eachChild isKindOf: AlbTextEditorSegmentElement ].	
	self assert: theNewSegments size equals: 11.
	
	theNewTextPieces := theNewSegments flatCollect: [ :eachSegment | eachSegment children asArray ].
	self assert: theNewTextPieces size equals: 63.
	
	self assert: thePreviousSegments equals: theNewSegments.
	self assert: thePreviousTextPieces equals: theNewTextPieces.
	
	^ anEditorElement
]

{ #category : #add }
AlbTextEditorNavigatorTest >> test_cursor_add_at_1_in_AA [
	
	| anEditor theMovedEvents |
	
	anEditor := self test_editorOnAA.

	theMovedEvents := OrderedCollection new.
	anEditor navigator
		whenMoved: [ :anEvent | theMovedEvents add: anEvent ];
		moveTo: 1;
		apply;
		unsubscribe.

	anEditor forceLayout.

	self assert: anEditor cursor position equals: 1.
	
	self assert: theMovedEvents size equals: 1.
	self assert: (theMovedEvents collect: #cursor) asArray equals: {
		AlbTextEditorSingleCursor new position: 1.
	}.	
	^ anEditor
]

{ #category : #add }
AlbTextEditorNavigatorTest >> test_cursor_add_at_1_in_AA_CR_BB [
	
	| anEditor theMovedEvents  |
	
	anEditor := self test_editorOnAA_CR_BB.

	theMovedEvents := OrderedCollection new.
	anEditor navigator
		whenMoved: [ :anEvent | theMovedEvents add: anEvent ];
		moveTo: 1;
		apply;
		unsubscribe.

	anEditor forceLayout.

	self assert: anEditor cursor position equals: 1.
	
	self assert: theMovedEvents size equals: 1.
	self assert: (theMovedEvents collect: #cursor) asArray equals: {
		AlbTextEditorSingleCursor new position: 1.
	}.	
	^ anEditor
]

{ #category : #add }
AlbTextEditorNavigatorTest >> test_cursor_add_at_1_in_multiline [
	
	| anEditor theMovedEvents anEditorElement |
	
	anEditorElement := self newEditorElementWithMultilineText.
	anEditor := anEditorElement editor.

	theMovedEvents := OrderedCollection new.

	anEditor navigator
		whenMoved: [ :anEvent | theMovedEvents add: anEvent ];
		moveTo: 1;
		apply;
		unsubscribe.

	anEditorElement forceLayout.

	self assert: anEditor cursor position equals: 1.
	
	self assert: theMovedEvents size equals: 1.
	self assert: (theMovedEvents collect: #cursor) asArray equals: {
		AlbTextEditorSingleCursor new position: 1.
	}.
	
	^ anEditor
]

{ #category : #add }
AlbTextEditorNavigatorTest >> test_cursor_add_at_2_in_multiline [
	
	| anEditor theMovedEvents anEditorElement |
	
	anEditorElement := self newEditorElementWithMultilineText.
	anEditor := anEditorElement editor.

	theMovedEvents := OrderedCollection new.

	anEditor navigator
		whenMoved: [ :anEvent | theMovedEvents add: anEvent ];
		addAt: 2;
		apply;
		unsubscribe.

	anEditorElement forceLayout.

	self assert: anEditor cursor position equals: 2.
	
	self assert: theMovedEvents size equals: 1.
	self assert: (theMovedEvents collect: #cursor) asArray equals: {
		AlbTextEditorSingleCursor new position: 2.
	}.
	
	^ anEditor
]

{ #category : #add }
AlbTextEditorNavigatorTest >> test_cursor_add_at_68_in_multiline [
	
	| anEditor  theMovedEvents anEditorElement |
	anEditorElement := self newEditorElementWithMultilineText.
	anEditor := anEditorElement editor.
	
	theMovedEvents := OrderedCollection new.
	anEditor navigator
		whenMoved: [ :anEvent | theMovedEvents add: anEvent ];
		moveTo: 68;
		apply;
		unsubscribe.
		
	anEditorElement forceLayout.
		
	self assert: anEditor cursor position equals: 68.
	
	self assert: theMovedEvents size equals: 1.
	self assert: (theMovedEvents collect: #cursor) asArray equals: {
		AlbTextEditorSingleCursor new position: 68.
	}.
	
	^ anEditorElement
]

{ #category : #add }
AlbTextEditorNavigatorTest >> test_cursor_add_at_8_in_multiline [
	
	| anEditor theMovedEvents anEditorElement |
	
	anEditorElement := self newEditorElementWithMultilineText.
	anEditor := anEditorElement editor..
	
	theMovedEvents := OrderedCollection new.

	anEditor navigator
		whenMoved: [ :anEvent | theMovedEvents add: anEvent ];
		moveTo: 8;
		apply;
		unsubscribe.

	self assert: anEditor cursors equals: {
		AlbTextEditorSingleCursor new position: 8.
	}.
	
	self assert: theMovedEvents size = 1.

	^ anEditor
]

{ #category : #'no duplication' }
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

{ #category : #'no duplication' }
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

{ #category : #accessing }
AlbTextEditorNavigatorTest >> test_cursor_is_not_on_last_line [
	
	| anEditor aNavigator anEditorElement |
	anEditorElement := self newEditorElementWithMultilineText.
	anEditor := anEditorElement editor.
	aNavigator := anEditor navigator 
		moveTo: 186; 
		apply;
		unsubscribe.
	self assert: (aNavigator isCursorOnTheLastLine: anEditor cursor) not.
	^ anEditor
]

{ #category : #accessing }
AlbTextEditorNavigatorTest >> test_cursor_is_on_last_line_when_at_the_end [
	
	| anEditor aNavigator anEditorElement |
	anEditorElement := self newEditorElementWithMultilineText.
	anEditor := anEditorElement editor.
	aNavigator := anEditor navigator 
		moveTo: 202; 
		apply;
		unsubscribe.
	self assert: (aNavigator isCursorOnTheLastLine: anEditor cursor ).
	^ anEditor
]

{ #category : #accessing }
AlbTextEditorNavigatorTest >> test_cursor_is_on_last_line_when_before_the_first_character [
	
	| anEditor aNavigator anEditorElement |
	anEditorElement := self newEditorElementWithMultilineText.
	anEditor := anEditorElement editor.
	aNavigator := anEditor navigator 
		moveTo: 187; 
		apply;
		unsubscribe.
	self assert: (aNavigator isCursorOnTheLastLine: anEditor cursor ).
	^ anEditor
]

{ #category : #'move down' }
AlbTextEditorNavigatorTest >> test_cursor_moveDown_in_cursors_at_190 [
	
	| anEditor theMovedEvents theReachBoudnaryEvents |
	
	anEditor := self test_cursor_moveTo_190_in_multiline.
	
	theMovedEvents := OrderedCollection new.
	theReachBoudnaryEvents := OrderedCollection new.

	anEditor navigator
		whenMoved: [ :anEvent | theMovedEvents add: anEvent ];
		whenReachedBoundary: [ :anEvent | theReachBoudnaryEvents add: anEvent ];
		moveDown;
		apply;
		unsubscribe.

	self assert: anEditor cursor position equals: 202.
	
	self assert: theMovedEvents size equals: 1.
	self assert: theMovedEvents first cursor equals: (AlbTextEditorSingleCursor new position: 202).
	self assert: theMovedEvents first oldIndex equals: 190.
	self assert: theMovedEvents first newIndex equals: 202.
	self assert: theReachBoudnaryEvents size equals: 1.
	self assert: theReachBoudnaryEvents first cursor equals: (AlbTextEditorSingleCursor new position: 202).
	self assert: theReachBoudnaryEvents first isBottom.
	
	^ anEditor
]

{ #category : #'move to line end' }
AlbTextEditorNavigatorTest >> test_cursor_moveToLineEnd_in_cursors_at_0 [
	
	| anEditor theMovedEvents anEditorElement |
	
	anEditorElement := self newEditorElementWithMultilineText.
	anEditor := anEditorElement editor.
	
	theMovedEvents := OrderedCollection new.

	anEditor navigator
		whenMoved: [ :anEvent | theMovedEvents add: anEvent ];
		moveToLineEnd;
		apply;
		unsubscribe.
		
	self assert: anEditor cursor position equals: 28.
	
	self assert: theMovedEvents size equals: 1.
	self assert: theMovedEvents first cursor equals: (AlbTextEditorSingleCursor new position: 28).
	self assert: theMovedEvents first oldIndex equals: 0.
	self assert: theMovedEvents first newIndex equals: 28.
	
	^ anEditor
]

{ #category : #'move to line end' }
AlbTextEditorNavigatorTest >> test_cursor_moveToLineEnd_in_cursors_at_1 [
	
	| anEditor theMovedEvents anEditorElement |
	
	anEditorElement := self newEditorElementWithMultilineText.
	anEditor := anEditorElement editor.
	anEditor navigator
		moveTo: 1;
		apply.
	
	theMovedEvents := OrderedCollection new.

	anEditor navigator
		whenMoved: [ :anEvent | theMovedEvents add: anEvent ];
		moveToLineEnd;
		apply;
		unsubscribe.
		
	self assert: anEditor cursor position equals: 28.
	
	self assert: theMovedEvents size equals: 1.
	self assert: theMovedEvents first cursor equals: (AlbTextEditorSingleCursor new position: 28).
	self assert: theMovedEvents first oldIndex equals: 1.
	self assert: theMovedEvents first newIndex equals: 28.
	
	^ anEditor
]

{ #category : #'move to line end' }
AlbTextEditorNavigatorTest >> test_cursor_moveToLineEnd_in_cursors_at_201 [
	
	| anEditor  theMovedEvents anEditorElement |
	
	anEditorElement := self newEditorElementWithMultilineText.
	anEditor := anEditorElement editor.
	anEditor navigator
		moveTo: 201;
		apply.
	
	theMovedEvents := OrderedCollection new.

	anEditor navigator
		whenMoved: [ :anEvent | theMovedEvents add: anEvent ];
		moveToLineEnd;
		apply;
		unsubscribe.
		
	self assert: anEditor cursor position equals: 202.
	
	self assert: theMovedEvents size equals: 1.
	self assert: theMovedEvents first cursor equals: (AlbTextEditorSingleCursor new position: 202).
	self assert: theMovedEvents first oldIndex equals: 201.
	self assert: theMovedEvents first newIndex equals: 202.
	
	^ anEditor
]

{ #category : #'move to line end' }
AlbTextEditorNavigatorTest >> test_cursor_moveToLineEnd_in_cursors_at_28 [
	
	| anEditor theMovedEvents |
	
	anEditor := self test_cursor_add_at_0_in_multi_lines.
	anEditor navigator
		moveTo: 28;
		apply.
	
	theMovedEvents := OrderedCollection new.

	anEditor navigator
		whenMoved: [ :anEvent | theMovedEvents add: anEvent ];
		moveToLineEnd;
		apply;
		unsubscribe.
		
	self assert: anEditor cursor position equals: 28.
	
	self assert: theMovedEvents isEmpty.
	
	^ anEditor
]

{ #category : #'move to line end' }
AlbTextEditorNavigatorTest >> test_cursor_moveToLineEnd_in_multiline [
	
	| anEditor theMovedEvents anEditorElement |
	
	anEditorElement := self newEditorElementWithMultilineText.
	anEditor := anEditorElement editor.
	
	theMovedEvents := OrderedCollection new.

	anEditor navigator
		whenMoved: [ :anEvent | theMovedEvents add: anEvent ];
		moveToLineEnd;
		apply;
		unsubscribe.
			
	self assert: theMovedEvents notEmpty.
	
	^ anEditor
]

{ #category : #'move to line start' }
AlbTextEditorNavigatorTest >> test_cursor_moveToLineStart_in_cursors_at_0 [
	
	| anEditor theMovedEvents |
	
	anEditor := self test_cursor_add_at_0_in_multi_lines.
	
	theMovedEvents := OrderedCollection new.

	anEditor navigator
		whenMoved: [ :anEvent | theMovedEvents add: anEvent ];
		moveToLineStart;
		apply;
		unsubscribe.
		
	self assert: anEditor cursor position equals: 0.
	
	self assert: theMovedEvents isEmpty.
	
	^ anEditor
]

{ #category : #'move to line start' }
AlbTextEditorNavigatorTest >> test_cursor_moveToLineStart_in_cursors_at_1 [
	
	| anEditor theMovedEvents |
	
	anEditor := self test_cursor_moveTo_1_in_cursors_at_0.
	
	theMovedEvents := OrderedCollection new.

	anEditor navigator
		whenMoved: [ :anEvent | theMovedEvents add: anEvent ];
		moveToLineStart;
		apply;
		unsubscribe.
		
	self assert: anEditor cursor position equals: 0.
	
	self assert: theMovedEvents size equals: 1.
	self assert: theMovedEvents first cursor equals: (AlbTextEditorSingleCursor new position: 0).
	self assert: theMovedEvents first oldIndex equals: 1.
	self assert: theMovedEvents first newIndex equals: 0.
	
	^ anEditor
]

{ #category : #'move to line start' }
AlbTextEditorNavigatorTest >> test_cursor_moveToLineStart_in_cursors_at_27 [
	
	| anEditor theMovedEvents |
	
	anEditor := self test_cursor_add_at_0_in_multi_lines.
	anEditor navigator
		moveTo: 27;
		apply.
	
	theMovedEvents := OrderedCollection new.

	anEditor navigator
		whenMoved: [ :anEvent | theMovedEvents add: anEvent ];
		moveToLineStart;
		apply;
		unsubscribe.
		
	self assert: anEditor cursor position equals: 0.
	
	self assert: theMovedEvents size equals: 1.
	self assert: theMovedEvents first cursor equals: (AlbTextEditorSingleCursor new position: 0).
	self assert: theMovedEvents first oldIndex equals: 27.
	self assert: theMovedEvents first newIndex equals: 0.
	
	^ anEditor
]

{ #category : #'move to line start' }
AlbTextEditorNavigatorTest >> test_cursor_moveToLineStart_in_cursors_at_28 [
	
	| anEditor theMovedEvents |
	
	anEditor := self test_cursor_add_at_0_in_multi_lines.
	anEditor navigator
		moveTo: 28;
		apply.
	
	theMovedEvents := OrderedCollection new.

	anEditor navigator
		whenMoved: [ :anEvent | theMovedEvents add: anEvent ];
		moveToLineStart;
		apply;
		unsubscribe.
		
	self assert: anEditor cursor position equals: 0.
	
	self assert: theMovedEvents size equals: 1.
	self assert: theMovedEvents first cursor equals: (AlbTextEditorSingleCursor new position: 0).
	self assert: theMovedEvents first oldIndex equals: 28.
	self assert: theMovedEvents first newIndex equals: 0.
	
	^ anEditor
]

{ #category : #'move to line start' }
AlbTextEditorNavigatorTest >> test_cursor_moveToLineStart_in_cursors_at_29 [
	
	| anEditor theMovedEvents |
	
	anEditor := self test_cursor_add_at_0_in_multi_lines.
	anEditor navigator
		moveTo: 29;
		apply.
	
	theMovedEvents := OrderedCollection new.

	anEditor navigator
		whenMoved: [ :anEvent | theMovedEvents add: anEvent ];
		moveToLineStart;
		apply;
		unsubscribe.
		
	self assert: anEditor cursor position equals: 29.

	self assert: theMovedEvents isEmpty.
	
	^ anEditor
]

{ #category : #'move to line start' }
AlbTextEditorNavigatorTest >> test_cursor_moveToLineStart_in_cursors_at_30 [
	
	| anEditor theMovedEvents |
	
	anEditor := self test_cursor_add_at_0_in_multi_lines.
	anEditor navigator
		moveTo: 30;
		apply.
	
	theMovedEvents := OrderedCollection new.

	anEditor navigator
		whenMoved: [ :anEvent | theMovedEvents add: anEvent ];
		moveToLineStart;
		apply;
		unsubscribe.
		
	self assert: anEditor cursor position equals: 29.

	self assert: theMovedEvents size equals: 1.
	self assert: theMovedEvents first cursor equals: (AlbTextEditorSingleCursor new position: 29).
	self assert: theMovedEvents first oldIndex equals: 30.
	self assert: theMovedEvents first newIndex equals: 29.
	
	^ anEditor
]

{ #category : #'move to line start' }
AlbTextEditorNavigatorTest >> test_cursor_moveToLineStart_in_cursors_at_40 [
	
	| anEditor theMovedEvents |
	
	anEditor := self test_cursor_add_at_0_in_multi_lines.
	anEditor navigator
		moveTo: 40;
		apply.
	
	theMovedEvents := OrderedCollection new.

	anEditor navigator
		whenMoved: [ :anEvent | theMovedEvents add: anEvent ];
		moveToLineStart;
		apply;
		unsubscribe.
		
	self assert: anEditor cursor position equals: 29.

	self assert: theMovedEvents size equals: 1.
	self assert: theMovedEvents first cursor equals: (AlbTextEditorSingleCursor new position: 29).
	self assert: theMovedEvents first oldIndex equals: 40.
	self assert: theMovedEvents first newIndex equals: 29.
	
	^ anEditor
]

{ #category : #'move to line start' }
AlbTextEditorNavigatorTest >> test_cursor_moveToLineStart_in_cursors_at_41 [
	
	| anEditor theMovedEvents |
	
	anEditor := self test_cursor_add_at_0_in_multi_lines.
	anEditor navigator
		moveTo: 41;
		apply.
	
	theMovedEvents := OrderedCollection new.

	anEditor navigator
		whenMoved: [ :anEvent | theMovedEvents add: anEvent ];
		moveToLineStart;
		apply;
		unsubscribe.
		
	self assert: anEditor cursor position equals: 29.

	self assert: theMovedEvents size equals: 1.
	self assert: theMovedEvents first cursor equals: (AlbTextEditorSingleCursor new position: 29).
	self assert: theMovedEvents first oldIndex equals: 41.
	self assert: theMovedEvents first newIndex equals: 29.
	
	^ anEditor
]

{ #category : #'move to line start' }
AlbTextEditorNavigatorTest >> test_cursor_moveToLineStart_in_multiline [
	
	| anEditor theMovedEvents anEditorElement |
	
	anEditorElement := self newEditorElementWithMultilineText.
	anEditor := anEditorElement editor.
	
	theMovedEvents := OrderedCollection new.

	anEditor navigator
		whenMoved: [ :anEvent | theMovedEvents add: anEvent ];
		moveToLineStart;
		apply;
		unsubscribe.
		
	
	self assert: theMovedEvents isEmpty.
	
	^ anEditor
]

{ #category : #'move to line end' }
AlbTextEditorNavigatorTest >> test_cursor_moveToNextWord_in_cursors_at_0 [
	
	"Differs from Brick version but : this nextWord behavior seems ok and its implementation remains simple, so keep it"
	| anEditor theMovedEvents |
	
	anEditor := self test_cursor_add_at_0_in_multi_lines.
	
	theMovedEvents := OrderedCollection new.

	anEditor navigator
		whenMoved: [ :anEvent | theMovedEvents add: anEvent ];
		moveToEndNextWord;
		apply;
		unsubscribe.
		
	self assert: anEditor cursor position equals: 1.
	
	self assert: theMovedEvents size equals: 1.
	self assert: theMovedEvents first cursor equals: (AlbTextEditorSingleCursor new position: 1).
	self assert: theMovedEvents first oldIndex equals: 0.
	self assert: theMovedEvents first newIndex equals: 1.
	
	^ anEditor
]

{ #category : #'move to line end' }
AlbTextEditorNavigatorTest >> test_cursor_moveToNextWord_in_cursors_at_1 [
	
	| anEditor theMovedEvents |
	
	anEditor := self test_cursor_add_at_1_in_multiline.
	
	theMovedEvents := OrderedCollection new.

	anEditor navigator
		whenMoved: [ :anEvent | theMovedEvents add: anEvent ];
		moveToEndNextWord;
		apply;
		unsubscribe.
		
	self assert: anEditor cursor position equals: 8.
	
	self assert: theMovedEvents size equals: 1.
	self assert: theMovedEvents first cursor equals: (AlbTextEditorSingleCursor new position: 8).
	self assert: theMovedEvents first oldIndex equals: 1.
	self assert: theMovedEvents first newIndex equals: 8.
	
	^ anEditor
]

{ #category : #'move to line end' }
AlbTextEditorNavigatorTest >> test_cursor_moveToPreviousWord_in_cursors_at_1 [
	
	| anEditor theMovedEvents |
	
	anEditor := self test_cursor_add_at_1_in_multiline.
	
	theMovedEvents := OrderedCollection new.

	anEditor navigator
		whenMoved: [ :anEvent | theMovedEvents add: anEvent ];
		moveToStartPreviousWord;
		apply;
		unsubscribe.
		
	self assert: anEditor cursor position equals: 0.
	
	self assert: theMovedEvents size equals: 1.
	self assert: theMovedEvents first cursor equals: (AlbTextEditorSingleCursor new position: 0).
	self assert: theMovedEvents first oldIndex equals: 1.
	self assert: theMovedEvents first newIndex equals: 0.
	
	^ anEditor
]

{ #category : #'move to line end' }
AlbTextEditorNavigatorTest >> test_cursor_moveToPreviousWord_in_cursors_at_2 [
	
	| anEditor theMovedEvents |
	
	anEditor := self test_cursor_add_at_2_in_multiline.
	
	theMovedEvents := OrderedCollection new.

	anEditor navigator
		whenMoved: [ :anEvent | theMovedEvents add: anEvent ];
		moveToStartPreviousWord;
		apply;
		unsubscribe.
		
	self assert: anEditor cursor position equals: 0.
	
	self assert: theMovedEvents size equals: 1.
	self assert: theMovedEvents first cursor equals: (AlbTextEditorSingleCursor new position: 0).
	self assert: theMovedEvents first oldIndex equals: 2.
	self assert: theMovedEvents first newIndex equals: 0.
	
	^ anEditor
]

{ #category : #'move to line end' }
AlbTextEditorNavigatorTest >> test_cursor_moveToPreviousWord_in_cursors_at_8 [
	
	| anEditor theMovedEvents |
	
	anEditor := self test_cursor_add_at_8_in_multiline.
	
	theMovedEvents := OrderedCollection new.

	anEditor navigator
		whenMoved: [ :anEvent | theMovedEvents add: anEvent ];
		moveToStartPreviousWord;
		apply;
		unsubscribe.
		
	self assert: (anEditor cursors 
			includes: (AlbTextEditorSingleCursor new position: 2 )).
	
	self assert: theMovedEvents size equals: 1.
	self assert: theMovedEvents first cursor equals: (AlbTextEditorSingleCursor new position: 2).
	self assert: theMovedEvents first oldIndex equals: 8.
	self assert: theMovedEvents first newIndex equals: 2.
	
	^ anEditor
]

{ #category : #'move to screen' }
AlbTextEditorNavigatorTest >> test_cursor_moveToScreen_1_left_half_in_multiline [
	
	| anEditor theMovedEvents anEditorElement |

	anEditorElement := self newEditorElementWithMultilineText.
	anEditor := anEditorElement editor.

	theMovedEvents := OrderedCollection new.

	anEditor navigator
		whenMoved: [ :anEvent | theMovedEvents add: anEvent ];
		moveToScreenPosition: (self paragraphMargin left + (self glyphWidth / 2.0) - 1) @ (self paragraphMargin top + (self glyphHeight / 2.0));
		apply;
		unsubscribe.

	self assert: anEditor cursor equals: (AlbTextEditorCursor at: 0).

	self assert: theMovedEvents isEmpty.
	
	^ anEditor
]

{ #category : #'move to screen' }
AlbTextEditorNavigatorTest >> test_cursor_moveToScreen_1_left_in_multiline [
	
	| anEditor theMovedEvents anEditorElement |
	
	anEditorElement := self newEditorElementWithMultilineText.
	anEditor := anEditorElement editor.
	
	theMovedEvents := OrderedCollection new.

	anEditor navigator
		whenMoved: [ :anEvent | theMovedEvents add: anEvent ];
		moveToScreenPosition: (self paragraphMargin left / 2.0) @ (self paragraphMargin top + (self glyphHeight / 2.0));
		apply;
		unsubscribe.

	self assert: anEditor cursor equals: (AlbTextEditorCursor at: 0).
	
	self assert: theMovedEvents isEmpty.
	
	^ anEditor
]

{ #category : #'move to screen' }
AlbTextEditorNavigatorTest >> test_cursor_moveToScreen_1_middle_in_multiline [
	
	| anEditor theMovedEvents anEditorElement |
	
	anEditorElement := self newEditorElementWithMultilineText.
	anEditor := anEditorElement editor.
	
	theMovedEvents := OrderedCollection new.

	anEditor navigator
		whenMoved: [ :anEvent | theMovedEvents add: anEvent ];
		moveToScreenPosition: (self paragraphMargin left + (self glyphWidth / 2.0)) @ (self paragraphMargin top + (self glyphHeight / 2.0));
		apply;
		unsubscribe.
		
	self assert: anEditor cursor equals: (AlbTextEditorCursor at: 0).
	
	self assert: theMovedEvents isEmpty.
	
	^ anEditor
]

{ #category : #'move to screen' }
AlbTextEditorNavigatorTest >> test_cursor_moveToScreen_1_right_half_in_multiline [

	| anEditor theMovedEvents anEditorElement |
	anEditorElement := self newEditorElementWithMultilineText.
	anEditor := anEditorElement editor.

	theMovedEvents := OrderedCollection new.

	anEditor navigator
		whenMoved: [ :anEvent | theMovedEvents add: anEvent ];
		moveToScreenPosition:
			self paragraphMargin left + (self glyphWidth / 2.0) + 1
			@ (self paragraphMargin top + (self glyphHeight / 2.0));
		apply;
		unsubscribe.

	self assert: anEditor cursor equals: (AlbTextEditorCursor at: 1).

	self assert: theMovedEvents size equals: 1.
	self assert: theMovedEvents first cursor equals: (AlbTextEditorSingleCursor new position: 1).
	self assert: theMovedEvents first oldIndex equals: 0.
	self assert: theMovedEvents first newIndex equals: 1.

	^ anEditor
]

{ #category : #'move to screen' }
AlbTextEditorNavigatorTest >> test_cursor_moveToScreen_41_right_in_multiline [
	
	| anEditor theMovedEvents anEditorElement |

	anEditorElement := self newEditorElementWithMultilineText.
	anEditor := anEditorElement editor.

	theMovedEvents := OrderedCollection new.

	anEditor navigator
		whenMoved: [ :anEvent | theMovedEvents add: anEvent ];
		moveToScreenPosition: (400@100);
		apply;
		unsubscribe.

	self assert: anEditor cursor equals: (AlbTextEditorCursor at: 41).

	self assert: theMovedEvents size equals: 1.
	self assert: theMovedEvents first cursor equals: (AlbTextEditorSingleCursor new position: 41).
	self assert: theMovedEvents first oldIndex equals: 0.
	self assert: theMovedEvents first newIndex equals: 41.
	
	^ anEditor
]

{ #category : #'move to' }
AlbTextEditorNavigatorTest >> test_cursor_moveTo_0_in_multiline [
	
	| anEditor theMovedEvents anEditorElement |
	
	anEditorElement := self newEditorElementWithMultilineText.
	anEditor := anEditorElement editor.
	
	theMovedEvents := OrderedCollection new.

	anEditor navigator
		whenMoved: [ :anEvent | theMovedEvents add: anEvent ];
		moveTo: 0;
		apply;
		unsubscribe.
		
	self assert: anEditor cursor position equals: 0.
	
	self assert: theMovedEvents isEmpty.
	
	^ anEditor
]

{ #category : #'move to' }
AlbTextEditorNavigatorTest >> test_cursor_moveTo_190_in_multiline [
	
	| anEditor theMovedEvents anEditorElement |
	
	anEditorElement := self newEditorElementWithMultilineText.
	anEditor := anEditorElement editor.
	
	theMovedEvents := OrderedCollection new.

	anEditor navigator
		whenMoved: [ :anEvent | theMovedEvents add: anEvent ];
		moveTo: 190;
		apply;
		unsubscribe.
		
	self assert: anEditor cursor position equals: 190.
	
	self assert: theMovedEvents size equals: 1.
	self assert: (theMovedEvents collect: #cursor) asArray equals: {
		AlbTextEditorSingleCursor new position: 190.
	}.
	
	^ anEditor
]

{ #category : #'move to' }
AlbTextEditorNavigatorTest >> test_cursor_moveTo_1_in_cursors_at_0 [
	
	| anEditor theMovedEvents |
	
	anEditor := self test_cursor_add_at_0_in_multi_lines.
	
	theMovedEvents := OrderedCollection new.

	anEditor navigator
		whenMoved: [ :anEvent | theMovedEvents add: anEvent ];
		moveTo: 1;
		apply;
		unsubscribe.

	self assert: anEditor cursor position equals: 1.
	
	self assert: theMovedEvents size equals: 1.
	self assert: theMovedEvents first cursor equals: (AlbTextEditorSingleCursor new position: 1).
	self assert: theMovedEvents first oldIndex equals: 0.
	self assert: theMovedEvents first newIndex equals: 1.
	
	^ anEditor
]

{ #category : #'move to' }
AlbTextEditorNavigatorTest >> test_cursor_moveTo_67_in_cursors_at_68 [
	
	| anEditorElement theMovedEvents |
	anEditorElement := self test_cursor_add_at_68_in_multiline.
	
	theMovedEvents := OrderedCollection new.

	anEditorElement navigator
		whenMoved: [ :anEvent | theMovedEvents add: anEvent ];
		moveTo: 67;
		apply;
		unsubscribe.
	
	anEditorElement forceLayout.
	
	self assert: anEditorElement cursor position equals: 67.
	
	self assert: theMovedEvents size equals: 1.
	self assert: theMovedEvents first cursor equals: (AlbTextEditorSingleCursor new position: 67).
	self assert: theMovedEvents first oldIndex equals: 68.
	self assert: theMovedEvents first newIndex equals: 67.
		
	^ anEditorElement
]

{ #category : #'move up' }
AlbTextEditorNavigatorTest >> test_cursor_moveUp_in_cursors_at_1 [
	
	| anEditor theMovedEvents theReachBoudnaryEvents |
	
	anEditor := self test_cursor_add_at_1_in_AA.
	
	theMovedEvents := OrderedCollection new.
	theReachBoudnaryEvents := OrderedCollection new.

	anEditor navigator
		whenMoved: [ :anEvent | theMovedEvents add: anEvent ];
		whenReachedBoundary: [ :anEvent | theReachBoudnaryEvents add: anEvent ];
		moveUp;
		apply;
		unsubscribe.

	self assert: anEditor cursor position equals: 0.
	
	self assert: theMovedEvents size equals: 1.
	self assert: theMovedEvents first cursor equals: (AlbTextEditorSingleCursor new position: 0).
	self assert: theMovedEvents first oldIndex equals: 1.
	self assert: theMovedEvents first newIndex equals: 0.
	self assert: theReachBoudnaryEvents size equals: 1.
	self assert: theReachBoudnaryEvents first cursor equals: (AlbTextEditorSingleCursor new position: 0).
	self assert: theReachBoudnaryEvents first isTop.
	
	^ anEditor
]

{ #category : #performance }
AlbTextEditorNavigatorTest >> test_cursor_move_from_1_to_2_does_not_rebuild_editor [
	
	| anEditorElement anEditor thePreviousSegments theNewSegments thePreviousTextPieces theNewTextPieces |

	anEditorElement := self test_cursor_add_at_1_does_not_rebuild_editor.
	anEditor := anEditorElement editor.

	thePreviousSegments := anEditorElement infinite children
		select: [ :eachChild | eachChild isKindOf: AlbTextEditorSegmentElement ].	
	self assert: thePreviousSegments size equals: 11.

	thePreviousTextPieces := thePreviousSegments
		flatCollect: [ :eachSegment | eachSegment children asArray ].
	self assert: thePreviousTextPieces size equals: 63.

	anEditor navigator
		moveTo: 2;
		apply.

	anEditorElement forceLayout.

	self assert: anEditor cursor position equals: 2.
	
	theNewSegments := anEditorElement infinite children
		select: [ :eachChild | eachChild isKindOf: AlbTextEditorSegmentElement ].	
	self assert: theNewSegments size equals: 11.
	
	theNewTextPieces := theNewSegments flatCollect: [ :eachSegment | eachSegment children asArray ].
	self assert: theNewTextPieces size equals: 63.
	
	self assert: thePreviousSegments equals: theNewSegments.
	self assert: thePreviousTextPieces equals: theNewTextPieces
]
