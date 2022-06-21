Class {
	#name : #AlbTextEditorSelecterTest,
	#superclass : #AlbTextEditorOperatorTest,
	#category : #'Album-Tests-Operators'
}

{ #category : #all }
AlbTextEditorSelecterTest >> test_select_all_in_empty [
	
	| anEditor |

	anEditor := self test_editorOnEmptyText.

	anEditor selecter all select.

	self assert: anEditor cursors isEmpty.
	self assert: anEditor selection isEmpty.

	^ anEditor
]

{ #category : #all }
AlbTextEditorSelecterTest >> test_select_all_in_empty_with_curor [
	
	| anEditor |

	anEditor := self test_editorOnEmptyText.

	anEditor navigator
		addAt: 0;
		apply.
	
	self assert: anEditor cursors isNotEmpty.
	self assert: anEditor cursors allCursors equals: { AlbTextEditorSingleCursor new position: 0 }.
	self assert: anEditor selection isEmpty.

	anEditor selecter all select.

	self assert: anEditor cursors isNotEmpty.
	self assert: anEditor cursors allCursors equals: { AlbTextEditorSingleCursor new position: 0 }.
	self assert: anEditor selection isEmpty.

	^ anEditor
]

{ #category : #all }
AlbTextEditorSelecterTest >> test_select_all_reduced [
	"There was a bug, that if a new text is smaller than the existing selection, then things can go wrong"
	
	| anEditor |

	anEditor := self test_editorOnMultilineText.
	anEditor selecter
		all
		select.

	self assert: anEditor selection equals: (BlCompositeSelection new select: 0 to: self multilineText size).
	self assert: anEditor cursors equals: (AlbTextEditorCursor atAll: { self multilineText size }).

	anEditor text: 'hello'.

	self assert: anEditor selection equals: (BlCompositeSelection new select: 0 to: 5).
	self assert: anEditor cursors equals: (AlbTextEditorCursor atAll: { 5 }).
	
	anEditor selecter
		all
		select.

	anEditor text: 'hi'.

	self assert: anEditor selection equals: (BlCompositeSelection new select: 0 to: 2).
	self assert: anEditor cursors equals: (AlbTextEditorCursor atAll: { 2 }).

	^ anEditor
]

{ #category : #'from to' }
AlbTextEditorSelecterTest >> test_select_from_0_to_5 [
	
	| anEditor |

	anEditor := self test_editorOnMultilineText.

	anEditor selecter
		from: 0 to: 5;
		select.
		
	self assert: anEditor selection equals: (BlCompositeSelection new select: 0 to: 5).
	self assert: anEditor cursors equals: (AlbTextEditorCursor atAll: #(5)).

	^ anEditor
]

{ #category : #'from to' }
AlbTextEditorSelecterTest >> test_select_from_0_to_5_in_steps [
	
	| anEditor |

	anEditor := self test_editorOnMultilineText.

	anEditor selecter
		from: 0 to: 1;
		select;
		from: 1 to: 2;
		select;
		from: 2 to: 3;
		select;
		from: 3 to: 4;
		select;
		from: 4 to: 5;
		select.

	self assert: anEditor selection equals: (BlCompositeSelection new select: 0 to: 5).
	self assert: anEditor cursors equals: (AlbTextEditorCursor atAll: #(5)).

	^ anEditor
]

{ #category : #move }
AlbTextEditorSelecterTest >> test_select_moveOneDown_at_6 [
	
	| anEditor |

	anEditor := self test_editorOnMultilineText.
	anEditor editor moveCursorTo: 6.
	
	anEditor selecter
		moveOneDown;
		select.
	
	self 
		assert: anEditor selection 
		equals: (BlCompositeSelection new select: 6 to: 35).
	
	self assert: anEditor cursors equals: (AlbTextEditorCursor atAll: #(35)).
	
	^ anEditor
]

{ #category : #move }
AlbTextEditorSelecterTest >> test_select_moveOneDown_at_6_thenUp [
	
	| anEditor |

	anEditor := self test_select_moveOneDown_at_6.
	
	anEditor selecter
		moveOneUp;
		select.
	
	self 
		assert: anEditor selection isEmpty.
	
	self assert: anEditor cursors equals: (AlbTextEditorCursor atAll: #(6)).
	
	^ anEditor
]

{ #category : #move }
AlbTextEditorSelecterTest >> test_select_moveOneLeft_at_0 [
	
	| anEditor |

	anEditor := self test_editorOnMultilineText.
	anEditor editor moveCursorTo: 0.
	anEditor selecter moveOneToLeft; select.
	self 
		assert: anEditor selection isEmpty.
	self 
		assert: anEditor editor selectedText asString 
		equals: ''.
	
	self assert: anEditor cursors equals: (AlbTextEditorCursor atAll: #(0)).
	^ anEditor
]

{ #category : #move }
AlbTextEditorSelecterTest >> test_select_moveOneLeft_at_4 [
	
	| anEditor |

	anEditor := self test_editorOnMultilineText.
	anEditor editor moveCursorTo: 4.
	
	anEditor selecter
		moveOneToLeft;
		select.
	
	self 
		assert: anEditor selection 
		equals: (BlCompositeSelection new select: 3 to: 4).
	self 
		assert: anEditor editor selectedText asString 
		equals: 'u'.
	self assert: anEditor cursors equals: (AlbTextEditorCursor atAll: #(3)).

	
	^ anEditor
]

{ #category : #move }
AlbTextEditorSelecterTest >> test_select_moveOneLeft_at_4_extendToNextWordEnd [
	
	| anEditor |
	anEditor := self test_select_moveOneLeft_at_4.

	anEditor selecter
		extendToNextWordEnd;
		select.

	self
		assert: anEditor selection 
		equals: (BlCompositeSelection new select: 4 to: 8).
	self 
		assert: anEditor editor selectedText asString 
		equals: 'mmer'.

	^ anEditor
]

{ #category : #move }
AlbTextEditorSelecterTest >> test_select_moveOneRight_at_6 [
	
	| anEditor |

	anEditor := self test_editorOnMultilineText.
	anEditor editor moveCursorTo: 6.
	
	anEditor selecter
		moveOneToRight;
		select.
	
	self 
		assert: anEditor selection 
		equals: (BlCompositeSelection new select: 6 to: 7).
	self 
		assert: anEditor editor selectedText asString 
		equals: 'e'.
	
	self assert: anEditor cursors equals: (AlbTextEditorCursor atAll: #(7)).
	
	^ anEditor
]

{ #category : #move }
AlbTextEditorSelecterTest >> test_select_moveOneRight_at_6_extendToNextWordEnd [
	
	| anEditor |

	anEditor := self test_select_moveOneRight_at_6.

	anEditor selecter
		extendToNextWordEnd;
		select.

	self 
		assert: anEditor selection 
		equals: (BlCompositeSelection new select: 6 to: 8).
	self 
		assert: anEditor editor selectedText asString 
		equals: 'er'.
	
	self assert: anEditor cursors equals: (AlbTextEditorCursor atAll: #(8)).

	^ anEditor
]

{ #category : #move }
AlbTextEditorSelecterTest >> test_select_moveOneRight_at_6_extendToNextWordEnd_twice [
	
	| anEditor |
	
	anEditor := self test_select_moveOneRight_at_6_extendToNextWordEnd.
	anEditor selecter
		extendToNextWordEnd;
		select.
	
	self 
		assert: anEditor selection 
		equals: (BlCompositeSelection new select: 6 to: 14).
	self 
		assert: anEditor editor selectedText asString 
		equals: 'er river'.
	
	self assert: anEditor cursors equals: (AlbTextEditorCursor atAll: #(14)).
	
	^ anEditor
]

{ #category : #move }
AlbTextEditorSelecterTest >> test_select_moveOneRight_at_6_extendToPreviousWordStart [
	
	| anEditor |
	
	anEditor := self test_select_moveOneRight_at_6.
	anEditor selecter
		extendToPreviousWordStart;
		select.
	
	self 
		assert: anEditor selection 
		equals: (BlCompositeSelection new select: 2 to: 6).
	self 
		assert: anEditor editor selectedText asString 
		equals: 'summ'.
	
	self assert: anEditor cursors equals: (AlbTextEditorCursor atAll: #(2)).
	
	^ anEditor
]

{ #category : #move }
AlbTextEditorSelecterTest >> test_select_moveOneRight_at_6_extendToPreviousWordStart_twice [
	
	| anEditor |
	
	anEditor := self test_select_moveOneRight_at_6_extendToPreviousWordStart.
	anEditor selecter
		extendToPreviousWordStart;
		select.
	
	self 
		assert: anEditor selection 
		equals: (BlCompositeSelection new select: 0 to: 6).
	self 
		assert: anEditor editor selectedText asString 
		equals: 'A summ'.
	
	self assert: anEditor cursors equals: (AlbTextEditorCursor atAll: #(0)).
	
	^ anEditor
]

{ #category : #move }
AlbTextEditorSelecterTest >> test_select_moveOneRight_at_End [
	
	| anEditor |

	anEditor := self test_editorOnMultilineText.
	anEditor editor moveCursorTo: anEditor text size.
	anEditor selecter moveOneToRight; select.
	self 
		assert: anEditor selection isEmpty.
	self 
		assert: anEditor editor selectedText asString 
		equals: ''.
	self assert: anEditor cursors equals: (AlbTextEditorCursor atAll: { anEditor text size }).

	^ anEditor
]

{ #category : #move }
AlbTextEditorSelecterTest >> test_select_moveOneUp_at_35 [
	
	| anEditor |

	anEditor := self test_editorOnMultilineText.
	anEditor editor moveCursorTo: 35.
	
	anEditor selecter
		moveOneUp;
		select.
	
	self 
		assert: anEditor selection 
		equals: (BlCompositeSelection new select: 6 to: 35).
	
	self assert: anEditor cursors equals: (AlbTextEditorCursor atAll: #(6)).
	
	^ anEditor
]

{ #category : #move }
AlbTextEditorSelecterTest >> test_select_moveOneUp_at_35_thenDown [
	
	| anEditor |

	anEditor := self test_select_moveOneUp_at_35.
	
	anEditor selecter
		moveOneDown;
		select.
	
	self 
		assert: anEditor selection  isEmpty.
	
	self assert: anEditor cursors equals: (AlbTextEditorCursor atAll: #(35)).
	
	^ anEditor
]

{ #category : #move }
AlbTextEditorSelecterTest >> test_select_moveTwiceLeft_at_1 [
	
	| anEditor |

	anEditor := self test_editorOnMultilineText.
	anEditor editor moveCursorTo: 1.
	
	anEditor selecter
		moveOneToLeft
		select.

	anEditor editor moveCursorTo: 0.
	
	anEditor selecter
		moveOneToLeft;
		select.
	
	self 
		assert: anEditor selection 
		equals: (BlCompositeSelection new select: 0 to: 1).
	self 
		assert: anEditor editor selectedText asString 
		equals: 'A'.
	self assert: anEditor cursors equals: (AlbTextEditorCursor atAll: #(0)).
	^ anEditor
]

{ #category : #move }
AlbTextEditorSelecterTest >> test_select_moveTwiceRight_at_End [
	
	| anEditor |

	anEditor := self test_editorOnMultilineText.
	anEditor editor moveCursorTo: anEditor text size - 1.
	anEditor selecter moveOneToRight; select.
	anEditor editor moveCursorTo: anEditor text size.
	
	anEditor selecter
		moveOneToRight;
		select.

	self 
		assert: anEditor selection 
		equals: (BlCompositeSelection new select: anEditor text size - 1 to: anEditor text size).
	self 
		assert: anEditor editor selectedText asString 
		equals: '.'.

	self assert: anEditor cursors equals: (AlbTextEditorCursor atAll: { anEditor text size }).

	^ anEditor
]

{ #category : #word }
AlbTextEditorSelecterTest >> test_select_word_at_0 [
	
	| anEditor |

	anEditor := self test_editorOnMultilineText.
	anEditor selecter
		wordAt: 0;
		select.

	self assert: anEditor selection equals: (BlCompositeSelection new select: 0 to: 1).
	self assert: anEditor editor selectedText asString equals: 'A'.

	self assert: anEditor cursors equals: (AlbTextEditorCursor atAll: #(1)).

	^ anEditor
]

{ #category : #word }
AlbTextEditorSelecterTest >> test_select_word_at_1 [
	
	| anEditor |

	anEditor := self test_editorOnMultilineText.
	anEditor selecter
		wordAt: 1;
		select.

	self assert: anEditor selection equals: (BlCompositeSelection new select: 0 to: 1).
	self assert: anEditor editor selectedText asString equals: 'A'.

	self assert: anEditor cursors equals: (AlbTextEditorCursor atAll: #(1)).

	^ anEditor
]

{ #category : #word }
AlbTextEditorSelecterTest >> test_select_word_at_2 [
	
	| anEditor |

	anEditor := self test_editorOnMultilineText.
	anEditor selecter
		wordAt: 2;
		select.

	self assert: anEditor selection equals: (BlCompositeSelection new select: 2 to: 8).
	self assert: anEditor editor selectedText asString equals: 'summer'.

	self assert: anEditor cursors equals: (AlbTextEditorCursor atAll: #(8)).

	^ anEditor
]

{ #category : #word }
AlbTextEditorSelecterTest >> test_select_word_at_2_and_10 [
	
	| anEditor |

	anEditor := self test_editorOnMultilineText.
	anEditor selecter
		wordAt: 2;
		wordAt: 10;
		select.

	self assert: anEditor selection equals: (BlCompositeSelection new select: 2 to: 8; select: 9 to: 14).
	self assert: anEditor editor selectedText asString equals: 'summer river'.

	self assert: anEditor cursors equals: (AlbTextEditorCursor atAll: #(8 14)).

	^ anEditor
]
