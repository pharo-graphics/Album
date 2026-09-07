Class {
	#name : #AlbTextEditorDeleterTest,
	#superclass : #AlbTextEditorOperatorTest,
	#category : #'Album-Tests-Operators'
}

{ #category : #deletion }
AlbTextEditorDeleterTest >> test_delete_0_to_0_cursorAt_0_selection_0_to_0 [
	
	| anEditor anEditorElement |
	
	anEditorElement := self newEditorElementWithMultilineText.
	anEditor := anEditorElement editor.
	space deferAndSettle: [
		anEditor moveCursorTo: 0.
		anEditor select: 0 to: 0.
		anEditor deleter
			from: 0 to: 0;
			delete ].

	self assert: anEditor text asString equals: (self multilineText asString).
	self assert: anEditor cursor position equals: 0.
	self assert: anEditor selection isEmpty
]

{ #category : #deletion }
AlbTextEditorDeleterTest >> test_delete_0_to_0_cursorAt_0_selection_0_to_10 [
	
	| anEditor anEditorElement |
	
	anEditorElement := self newEditorElementWithMultilineText.
	anEditor := anEditorElement editor.
	space deferAndSettle: [
		anEditor moveCursorTo: 0.
		anEditor select: 0 to: 10.
		anEditor deleter
			from: 0 to: 0;
			delete ].

	self assert: anEditor text asString equals: (self multilineText asString).
	self assert: anEditor cursor position equals: 0.
	self assert: anEditor selection equals: (BlCompositeSelection new select: 0 to: 10)
]

{ #category : #deletion }
AlbTextEditorDeleterTest >> test_delete_0_to_1_cursorAt_0_selection_0_to_10 [
	
	| anEditor anEditorElement |
	
	anEditorElement := self newEditorElementWithMultilineText.
	anEditor := anEditorElement editor.
	space deferAndSettle: [
		anEditor moveCursorTo: 0.
		anEditor select: 0 to: 10.
		anEditor deleter
			from: 0 to: 1;
			delete ].

	self assert: anEditor text asString equals: (self multilineText from: 2 to: self multilineText size) asString.
	self assert: anEditor cursor position equals: 0.
	self assert: anEditor selection equals: (BlCompositeSelection new select: 0 to: 9)
]

{ #category : #deletion }
AlbTextEditorDeleterTest >> test_delete_0_to_28_cursorAt_0_selection_0_to_10 [
	
	| anEditor anEditorElement |
	
	anEditorElement := self newEditorElementWithMultilineText.
	anEditor := anEditorElement editor.
	space deferAndSettle: [
		anEditor moveCursorTo: 0.
		anEditor select: 0 to: 10.
		anEditor deleter
			from: 0 to: 28;
			delete ].
	
	self assert: anEditor text asString equals: (self multilineText from: 29 to: self multilineText size) asString.
	self assert: anEditor cursor position equals: 0.
	self assert: anEditor selection isEmpty
]

{ #category : #deletion }
AlbTextEditorDeleterTest >> test_delete_0_to_28_cursorAt_0_selection_0_to_28 [
	
	| anEditor anEditorElement |
	
	anEditorElement := self newEditorElementWithMultilineText.
	anEditor := anEditorElement editor.
	space deferAndSettle: [
		anEditor moveCursorTo: 0.
		anEditor select: 0 to: 28.
		anEditor deleter
			from: 0 to: 28;
			delete ].
	
	self assert: anEditor text asString equals: (self multilineText from: 29 to: self multilineText size) asString.
	self assert: anEditor cursor position equals: 0.
	self assert: anEditor selection isEmpty
]

{ #category : #deletion }
AlbTextEditorDeleterTest >> test_delete_0_to_28_cursorAt_0_selection_0_to_29 [
	
	| anEditor anEditorElement |
	
	anEditorElement := self newEditorElementWithMultilineText.
	anEditor := anEditorElement editor.
	space deferAndSettle: [
		anEditor moveCursorTo: 0.
		anEditor select: 0 to: 29.
		anEditor deleter
			from: 0 to: 28;
			delete ].
	
	self assert: anEditor text asString equals: (self multilineText from: 29 to: self multilineText size) asString.
	self assert: anEditor cursor position equals: 0.
	self assert: anEditor selection equals: (BlCompositeSelection new select: 0 to: 1)
]

{ #category : #deletion }
AlbTextEditorDeleterTest >> test_delete_0_to_28_cursorAt_0_selection_0_to_38 [
	
	| anEditor anEditorElement |

	anEditorElement := self newEditorElementWithMultilineText.
	anEditor := anEditorElement editor.
	space deferAndSettle: [
		anEditor moveCursorTo: 0.
		anEditor select: 0 to: 38.
		anEditor deleter
			from: 0 to: 28;
			delete ].

	self assert: anEditor text asString equals: (self multilineText from: 29 to: self multilineText size) asString.
	self assert: anEditor cursor position equals: 0.
	self assert: anEditor selection equals: (BlCompositeSelection new select: 0 to: 10)
]

{ #category : #deletion }
AlbTextEditorDeleterTest >> test_delete_0_to_28_cursorAt_0_selection_0_to_38_and_48_to_50 [
	
	| anEditor anEditorElement |

	anEditorElement := self newEditorElementWithMultilineText.
	anEditor := anEditorElement editor.
	space deferAndSettle: [
		anEditor moveCursorTo: 0.
		anEditor select: 0 to: 38.
		anEditor select: 48 to: 50.
		anEditor deleter
			from: 0 to: 28;
			delete ].

	self assert: anEditor text asString equals: (self multilineText from: 29 to: self multilineText size) asString.
	self assert: anEditor cursor position equals: 0.
	self assert: anEditor selection equals: (BlCompositeSelection new select: 0 to: 10; select: 20 to: 22)
]

{ #category : #deletion }
AlbTextEditorDeleterTest >> test_delete_0_to_28_cursorAt_10_selection_0_to_10 [
	
	| anEditor anEditorElement |
	
	anEditorElement := self newEditorElementWithMultilineText.
	anEditor := anEditorElement editor.
	space deferAndSettle: [
		anEditor moveCursorTo: 10.
		anEditor select: 0 to: 10.
		anEditor deleter
			from: 0 to: 28;
			delete ].
	
	self assert: anEditor text asString equals: (self multilineText from: 29 to: self multilineText size) asString.
	self assert: anEditor cursor position equals: 0.
	self assert: anEditor selection isEmpty
]

{ #category : #deletion }
AlbTextEditorDeleterTest >> test_delete_0_to_28_cursorAt_28_selection_0_to_10 [
	
	| anEditor anEditorElement |
	
	anEditorElement := self newEditorElementWithMultilineText.
	anEditor := anEditorElement editor.
	space deferAndSettle: [
		anEditor moveCursorTo: 28.
		anEditor select: 0 to: 10.
		anEditor deleter
			from: 0 to: 28;
			delete ].
	
	self assert: anEditor text asString equals: (self multilineText from: 29 to: self multilineText size) asString.
	self assert: anEditor cursor position equals: 0.
	self assert: anEditor selection isEmpty
]

{ #category : #deletion }
AlbTextEditorDeleterTest >> test_delete_0_to_28_cursorAt_29_selection_0_to_10 [
	
	| anEditor anEditorElement |
	
	anEditorElement := self newEditorElementWithMultilineText.
	anEditor := anEditorElement editor.
	space deferAndSettle: [
		anEditor moveCursorTo: 29.
		anEditor select: 0 to: 10.
		anEditor deleter
			from: 0 to: 28;
			delete ].
	
	self assert: anEditor text asString equals: (self multilineText from: 29 to: self multilineText size) asString.
	self assert: anEditor cursor position equals: 1.
	self assert: anEditor selection isEmpty
]

{ #category : #deletion }
AlbTextEditorDeleterTest >> test_delete_0_to_28_cursorAt_38_selection_0_to_10 [
	
	| anEditor anEditorElement |
	
	anEditorElement := self newEditorElementWithMultilineText.
	anEditor := anEditorElement editor.
	space deferAndSettle: [
		anEditor moveCursorTo: 38.
		anEditor select: 0 to: 10.
		anEditor deleter
			from: 0 to: 28;
			delete ].
	
	self assert: anEditor text asString equals: (self multilineText from: 29 to: self multilineText size) asString.
	self assert: anEditor cursor position equals: 10.
	self assert: anEditor selection isEmpty
]

{ #category : #'deletion special' }
AlbTextEditorDeleterTest >> test_delete_0_to_5_from_HelloCr [
	
	| anEditor |
	
	anEditor := self newEditorElement: 'hello', String cr.
	space deferAndSettle: [
		anEditor deleter
			from: 0 to: 5;
			delete ].

	self assert: anEditor text asString equals: String cr.
]

{ #category : #'deletion special' }
AlbTextEditorDeleterTest >> test_surroundings_delete_at_0_from_parenthesis_open_close [
	
	| anEditor |
	
	anEditor := self newEditorElement: '()'.
	space deferAndSettle: [
		anEditor navigator
			moveTo: 0;
			apply.
		anEditor deleter
			surroundings: { '(' -> ')' };
			delete ].

	self assert: anEditor text asString equals: '()'.
	self assert: anEditor cursor position equals: 0
]

{ #category : #'deletion special' }
AlbTextEditorDeleterTest >> test_surroundings_delete_at_1_from_parenthesis_open_close [
	
	| anEditor |
	
	anEditor := self newEditorElement: '()'.
	space deferAndSettle: [
		anEditor navigator
			moveTo: 1;
			apply.
		anEditor deleter
			surroundings: { '(' -> ')' };
			delete ].

	self assert: anEditor text asString equals: ''.
	self assert: anEditor cursor position equals: 0
]

{ #category : #'deletion special' }
AlbTextEditorDeleterTest >> test_surroundings_delete_at_1_from_parenthesis_open_close_close [
	
	| anEditor |
	
	anEditor := self newEditorElement: '())'.
	space deferAndSettle: [
		anEditor navigator
			moveTo: 1;
			apply.
		anEditor deleter
			surroundings: { '(' -> ')' };
			delete ].

	self assert: anEditor text asString equals: ')'.
	self assert: anEditor cursor position equals: 0
]

{ #category : #'deletion special' }
AlbTextEditorDeleterTest >> test_surroundings_delete_at_2_from_parenthesis_open_close [
	
	| anEditor |
	
	anEditor := self newEditorElement: '()'.
	space deferAndSettle: [
		anEditor navigator
			moveTo: 2;
			apply.
		anEditor deleter
			surroundings: { '(' -> ')' };
			delete ].

	self assert: anEditor text asString equals: '()'.
	self assert: anEditor cursor position equals: 2
]

{ #category : #'deletion special' }
AlbTextEditorDeleterTest >> test_surroundings_delete_at_2_from_parenthesis_open_close_selected_1_to_2 [
	
	| anEditor |
	
	anEditor := self newEditorElement: '()'.
	space deferAndSettle: [
		anEditor selecter
			from: 1 to: 2;
			select.
		anEditor navigator
			moveTo: 2;
			apply.
		anEditor deleter
			surroundings: { '(' -> ')' };
			delete ].

	self assert: anEditor text asString equals: '()'.
	self assert: anEditor cursor position equals: 2
]

{ #category : #'deletion special' }
AlbTextEditorDeleterTest >> test_surroundings_delete_at_2_from_parenthesis_open_open_close [
	
	| anEditor |
	
	anEditor := self newEditorElement: '(()'.
	space deferAndSettle: [
		anEditor navigator
			moveTo: 2;
			apply.
		anEditor deleter
			surroundings: { '(' -> ')' };
			delete ].

	self assert: anEditor text asString equals: '('.
	self assert: anEditor cursor position equals: 1
]
