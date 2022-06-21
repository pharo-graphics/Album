Class {
	#name : #AlbTextEditorOperatorTest,
	#superclass : #TestCase,
	#category : #'Album-Tests-Operators'
}

{ #category : #'private - font metrics' }
AlbTextEditorOperatorTest >> ascent [
	^ -20 
]

{ #category : #'private - font metrics' }
AlbTextEditorOperatorTest >> descent [ 
	^ 20
]

{ #category : #'instance creation' }
AlbTextEditorOperatorTest >> editorFor: aText [
	
	| anEditor aRopedText |

	aRopedText := aText asRopedText lineSpacing: self lineSpacing; paragraphMargin: self paragraphMargin; wordPadding: self wordPadding.

	anEditor := AlbEditor new.
	anEditor padding: BlInsets empty.
	anEditor fitContent.
	anEditor text: aRopedText.
	
	BlDevCrossover on: anEditor.
	
	anEditor editor segmentBuilder
		wordStencil: [ :aTAlbTextEditorTextualPiece |
			| aTextElement |
			aTextElement := AlbTextEditableWordPieceStencilBuilder new
				segmentPiece: aTAlbTextEditorTextualPiece;
				asElement.
			aTextElement measurer: self fixedMeasurer.
			aTextElement measurer textOffset: aTAlbTextEditorTextualPiece textStart.
			aTextElement ].
	
	anEditor requestFocus.
	anEditor forceLayout.

	^ anEditor
]

{ #category : #'instance creation' }
AlbTextEditorOperatorTest >> fixedMeasurer [
	^ BlTextElementMockedMeasurer new
		ascent: self ascent;
		descent: self descent;
		glyphWidth: self glyphWidth;
		glyphHeight: self glyphHeight
]

{ #category : #'private - font metrics' }
AlbTextEditorOperatorTest >> glyphHeight [
	^ self ascent abs + self descent 
]

{ #category : #'private - font metrics' }
AlbTextEditorOperatorTest >> glyphWidth [
	^ 30 
]

{ #category : #'private - font metrics' }
AlbTextEditorOperatorTest >> lineSpacing [
	^ 5 
]

{ #category : #'instance creation' }
AlbTextEditorOperatorTest >> multilineText [
	
	
	^ 'A summer river being crossed
how pleasing
with sandals in my hands!

Light of the moon
Moves west, flowers'' shadows
Creep eastward.

In the moonlight,
The color and scent of the wisteria
Seems far away.' asRopedText
]

{ #category : #'private - font metrics' }
AlbTextEditorOperatorTest >> paragraphMargin [
	^ BlInsets all: 15 
]

{ #category : #'private - utility' }
AlbTextEditorOperatorTest >> piecesWithCursorIn: anEditorElement [
	^ anEditorElement withAllChildrenBreadthFirst 
		select: [ :eachChild | eachChild isKindOf: AlbCursorElement ]
		thenCollect: [ :eachCursor | eachCursor parent ]
]

{ #category : #'private - events' }
AlbTextEditorOperatorTest >> subscribe: anEventClass do: aBlock for: anElement [
	anElement when: anEventClass do: aBlock
]

{ #category : #'focus - examples' }
AlbTextEditorOperatorTest >> test_editorCreatesOneCursorOnFocus [
	
	| anEditor aSpace |
	
	anEditor := self test_editorHasNoFocusByDefault.
	
	aSpace := OBlSpace new.
	aSpace host: BlHeadlessHost new.
	aSpace addChild: anEditor.
	
	self assert: anEditor cursors isEmpty.
	
	anEditor requestFocus.
	aSpace pulse.
	
	self assert: anEditor isFocused.
	self assert: anEditor hasFocus.
	self assert: anEditor cursors allCursors equals: { AlbTextEditorSingleCursor new position: 0 }.
	
	aSpace removeChild: anEditor.
	
	^ anEditor
]

{ #category : #'focus - examples' }
AlbTextEditorOperatorTest >> test_editorHasNoFocusByDefault [
	
	| anEditor |
	
	anEditor := AlbEditor new.
	self assert: anEditor isFocused not.
	self assert: anEditor hasFocus not.
	
	^ anEditor
]

{ #category : #'instance creation' }
AlbTextEditorOperatorTest >> test_editorOnEmptyText [
	
	| anEditor anEditorElement |
	
	anEditorElement := self editorFor: '' asRopedText.
	anEditor := anEditorElement editor.
	
	self assert: anEditor cursors isEmpty.
	self assert: anEditor selection isEmpty.
	
	^ anEditorElement
]

{ #category : #'instance creation' }
AlbTextEditorOperatorTest >> test_editorOnMultilineText [
	
	| anEditor anEditorElement |
	
	anEditorElement := self editorFor: self multilineText.
	anEditor := anEditorElement editor.
	
	self assert: anEditor cursors isEmpty.
	self assert: anEditor selection isEmpty.
	
	^ anEditorElement
]

{ #category : #'utility - tests' }
AlbTextEditorOperatorTest >> test_findWhitespaceInEmptyAt_0 [
	
	| text editor whitespace |
	
	text := '' asRopedText.
	editor := AlbTextEditor new text: text.
	whitespace := editor inserter findWhitespaceOfLineBefore: 0.
	
	self assert: whitespace equals: ''.
	
	^ whitespace
]

{ #category : #'utility - tests' }
AlbTextEditorOperatorTest >> test_findWhitespaceIn_Hello_at_0 [
	
	| text editor whitespace |
	
	text := 'Hello' asRopedText.
	editor := AlbTextEditor new text: text.
	whitespace := editor inserter findWhitespaceOfLineBefore: 0.
	
	self assert: whitespace = ''.
	
	^ whitespace
]

{ #category : #'utility - tests' }
AlbTextEditorOperatorTest >> test_findWhitespaceIn_Hello_at_1 [
	
	| text editor whitespace |
	
	text := 'Hello' asRopedText.
	editor := AlbTextEditor new text: text.
	whitespace := editor inserter findWhitespaceOfLineBefore: 1.

	self assert: whitespace = ''.

	^ whitespace
]

{ #category : #'utility - tests' }
AlbTextEditorOperatorTest >> test_findWhitespaceIn_Hello_at_2 [
	
	| text editor whitespace |
	
	text := 'Hello' asRopedText.
	editor := AlbTextEditor new text: text.
	whitespace := editor inserter findWhitespaceOfLineBefore: 2.

	self assert: whitespace = ''.

	^ whitespace
]

{ #category : #'utility - tests' }
AlbTextEditorOperatorTest >> test_findWhitespaceIn_Hello_at_3 [
	
	| text editor whitespace |
	
	text := 'Hello' asRopedText.
	editor := AlbTextEditor new text: text.
	whitespace := editor inserter findWhitespaceOfLineBefore: 3.

	self assert: whitespace = ''.

	^ whitespace
]

{ #category : #'utility - tests' }
AlbTextEditorOperatorTest >> test_findWhitespaceIn_Hello_at_4 [
	
	| text editor whitespace |
	
	text := 'Hello' asRopedText.
	editor := AlbTextEditor new text: text.
	whitespace := editor inserter findWhitespaceOfLineBefore: 4.

	self assert: whitespace = ''.

	^ whitespace
]

{ #category : #'utility - tests' }
AlbTextEditorOperatorTest >> test_findWhitespaceIn_Hello_at_5 [
	
	| text editor whitespace |
	
	text := 'Hello' asRopedText.
	editor := AlbTextEditor new text: text.
	whitespace := editor inserter findWhitespaceOfLineBefore: 5.

	self assert: whitespace = ''.

	^ whitespace
]

{ #category : #'utility - tests' }
AlbTextEditorOperatorTest >> test_findWhitespaceIn_Hello_cr_World_at_6 [
	
	| text editor whitespace |
	
	text := ('Hello', String cr, 'World') asRopedText.
	editor := AlbTextEditor new text: text.
	whitespace := editor inserter findWhitespaceOfLineBefore: 6.
	
	self assert: whitespace = ''.
	
	^ whitespace
]

{ #category : #'utility - tests' }
AlbTextEditorOperatorTest >> test_findWhitespaceIn_Hello_cr_World_at_7 [
	
	| text editor whitespace |
	
	text := ('Hello', String cr, 'World') asRopedText.
	editor := AlbTextEditor new text: text.
	whitespace := editor inserter findWhitespaceOfLineBefore: 7.
	
	self assert: whitespace = ''.
	
	^ whitespace
]

{ #category : #'utility - tests' }
AlbTextEditorOperatorTest >> test_findWhitespaceIn_Hello_cr_World_at_8 [
	
	| text editor whitespace |
	
	text := ('Hello', String cr, 'World') asRopedText.
	editor := AlbTextEditor new text: text.
	whitespace := editor inserter findWhitespaceOfLineBefore: 8.
	
	self assert: whitespace = ''.
	
	^ whitespace
]

{ #category : #'utility - tests' }
AlbTextEditorOperatorTest >> test_findWhitespaceIn_Hello_cr_space_World_at_6 [
	
	| text editor whitespace |
	
	text := ('Hello', String cr, ' World') asRopedText.
	editor := AlbTextEditor new text: text.
	whitespace := editor inserter findWhitespaceOfLineBefore: 6.
	
	self assert: whitespace = ''.
	
	^ whitespace
]

{ #category : #'utility - tests' }
AlbTextEditorOperatorTest >> test_findWhitespaceIn_Hello_cr_space_World_at_7 [
	
	| text editor whitespace |
	
	text := ('Hello', String cr, ' World') asRopedText.
	editor := AlbTextEditor new text: text.
	whitespace := editor inserter findWhitespaceOfLineBefore: 7.
	
	self assert: whitespace = ' '.
	
	^ whitespace
]

{ #category : #'utility - tests' }
AlbTextEditorOperatorTest >> test_findWhitespaceIn_Hello_cr_space_World_at_8 [
	
	| text editor whitespace |
	
	text := ('Hello', String cr, ' World') asRopedText.
	editor := AlbTextEditor new text: text.
	whitespace := editor inserter findWhitespaceOfLineBefore: 8.
	
	self assert: whitespace = ' '.
	
	^ whitespace
]

{ #category : #'utility - tests' }
AlbTextEditorOperatorTest >> test_findWhitespaceIn_space_Hello_at_0 [
	
	| text editor whitespace |
	
	text := ' Hello' asRopedText.
	editor := AlbTextEditor new text: text.
	whitespace := editor inserter findWhitespaceOfLineBefore: 0.
	
	self assert: whitespace = ''.
	
	^ whitespace
]

{ #category : #'utility - tests' }
AlbTextEditorOperatorTest >> test_findWhitespaceIn_space_Hello_at_1 [
	
	| text editor whitespace |
	
	text := ' Hello' asRopedText.
	editor := AlbTextEditor new text: text.
	whitespace := editor inserter findWhitespaceOfLineBefore: 1.
	
	self assert: whitespace = ' '.
	
	^ whitespace
]

{ #category : #'utility - tests' }
AlbTextEditorOperatorTest >> test_findWhitespaceIn_space_Hello_at_2 [
	
	| text editor whitespace |
	
	text := ' Hello' asRopedText.
	editor := AlbTextEditor new text: text.
	whitespace := editor inserter findWhitespaceOfLineBefore: 2.
	
	self assert: whitespace = ' '.
	
	^ whitespace
]

{ #category : #'utility - tests' }
AlbTextEditorOperatorTest >> test_findWhitespaceIn_space_at_0 [
	
	| text editor whitespace |
	
	text := ' ' asRopedText.
	editor := AlbTextEditor new text: text.
	whitespace := editor inserter findWhitespaceOfLineBefore: 0.
	
	self assert: whitespace = ''.
	
	^ whitespace
]

{ #category : #'utility - tests' }
AlbTextEditorOperatorTest >> test_findWhitespaceIn_space_at_1 [
	
	| text editor whitespace |
	
	text := ' ' asRopedText.
	editor := AlbTextEditor new text: text.
	whitespace := editor inserter findWhitespaceOfLineBefore: 1.
	
	self assert: whitespace = ' '.
	
	^ whitespace
]

{ #category : #'utility - tests' }
AlbTextEditorOperatorTest >> test_findWhitespaceIn_space_space_at_0 [
	
	| text editor whitespace |
	
	text := '  ' asRopedText.
	editor := AlbTextEditor new text: text.
	whitespace := editor inserter findWhitespaceOfLineBefore: 0.
	
	self assert: whitespace = ''.
	
	^ whitespace
]

{ #category : #'utility - tests' }
AlbTextEditorOperatorTest >> test_findWhitespaceIn_space_space_at_1 [
	
	| text editor whitespace |
	
	text := '  ' asRopedText.
	editor := AlbTextEditor new text: text.
	whitespace := editor inserter findWhitespaceOfLineBefore: 1.
	
	self assert: whitespace = ' '.
	
	^ whitespace
]

{ #category : #'utility - tests' }
AlbTextEditorOperatorTest >> test_findWhitespaceIn_space_space_at_2 [
	
	| text editor whitespace |
	
	text := '  ' asRopedText.
	editor := AlbTextEditor new text: text.
	whitespace := editor inserter findWhitespaceOfLineBefore: 2.
	
	self assert: whitespace = '  '.
	
	^ whitespace
]

{ #category : #'utility - tests' }
AlbTextEditorOperatorTest >> test_findWhitespaceIn_space_tab_at_0 [
	
	| text editor whitespace |
	
	text := (' ', String tab) asRopedText.
	editor := AlbTextEditor new text: text.
	whitespace := editor inserter findWhitespaceOfLineBefore: 0.
	
	self assert: whitespace = ''.
	
	^ whitespace
]

{ #category : #'utility - tests' }
AlbTextEditorOperatorTest >> test_findWhitespaceIn_space_tab_at_1 [
	
	| text editor whitespace |
	
	text := (' ', String tab) asRopedText.
	editor := AlbTextEditor new text: text.
	whitespace := editor inserter findWhitespaceOfLineBefore: 1.
	
	self assert: whitespace = ' '.
	
	^ whitespace
]

{ #category : #'utility - tests' }
AlbTextEditorOperatorTest >> test_findWhitespaceIn_space_tab_at_2 [
	
	| text editor whitespace |
	
	text := (' ', String tab) asRopedText.
	editor := AlbTextEditor new text: text.
	whitespace := editor inserter findWhitespaceOfLineBefore: 2.
	
	self assert: whitespace = (' ', String tab).
	
	^ whitespace
]

{ #category : #'private - events' }
AlbTextEditorOperatorTest >> unsubscribe: anEventClass from: anElement [
	anElement removeEventHandlersSuchThat: [ :anEventHandler | (anEventHandler isKindOf: BlEventHandler) and: [ anEventHandler eventClass = anEventClass ] ]
]

{ #category : #'private - font metrics' }
AlbTextEditorOperatorTest >> wordPadding [  
	^ BlInsets top: 3 bottom: 3
]
