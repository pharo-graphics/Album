Class {
	#name : #AlbTextEditorOperatorExamples,
	#superclass : #Object,
	#traits : 'TAlbTextEditorFixedMeasurerExamples',
	#classTraits : 'TAlbTextEditorFixedMeasurerExamples classTrait',
	#category : #'Album-Examples-Operators'
}

{ #category : #'focus - examples' }
AlbTextEditorOperatorExamples >> editorCreatesOneCursorOnFocus [
	<gtExample>
	| anEditor aSpace |
	
	anEditor := self editorHasNoFocusByDefault.
	
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

{ #category : #'instance creation' }
AlbTextEditorOperatorExamples >> editorFor: aText [
	<return: #AlbEditor>
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

{ #category : #'focus - examples' }
AlbTextEditorOperatorExamples >> editorHasNoFocusByDefault [
	<gtExample>
	| anEditor |
	
	anEditor := AlbEditor new.
	self assert: anEditor isFocused not.
	self assert: anEditor hasFocus not.
	
	^ anEditor
]

{ #category : #'instance creation' }
AlbTextEditorOperatorExamples >> editorOnEmptyText [
	<gtExample>
	| anEditor anEditorElement |
	
	anEditorElement := self editorFor: '' asRopedText.
	anEditor := anEditorElement editor.
	
	self assert: anEditor cursors isEmpty.
	self assert: anEditor selection isEmpty.
	
	^ anEditorElement
]

{ #category : #'instance creation' }
AlbTextEditorOperatorExamples >> editorOnMultilineText [
	<gtExample>
	| anEditor anEditorElement |
	
	anEditorElement := self editorFor: self multilineText.
	anEditor := anEditorElement editor.
	
	self assert: anEditor cursors isEmpty.
	self assert: anEditor selection isEmpty.
	
	^ anEditorElement
]

{ #category : #'examples - showroom' }
AlbTextEditorOperatorExamples >> editorOnSomeThing [

	^ self editorFor: 'SomeThing'
]

{ #category : #'utility - examples' }
AlbTextEditorOperatorExamples >> findWhitespaceInEmptyAt_0 [
	<gtExample>
	| text editor whitespace |
	
	text := '' asRopedText.
	editor := AlbTextEditor new text: text.
	whitespace := editor inserter findWhitespaceOfLineBefore: 0.
	
	self assert: whitespace = ''.
	
	^ whitespace
]

{ #category : #'utility - examples' }
AlbTextEditorOperatorExamples >> findWhitespaceIn_Hello_at_0 [
	<gtExample>
	| text editor whitespace |
	
	text := 'Hello' asRopedText.
	editor := AlbTextEditor new text: text.
	whitespace := editor inserter findWhitespaceOfLineBefore: 0.
	
	self assert: whitespace = ''.
	
	^ whitespace
]

{ #category : #'utility - examples' }
AlbTextEditorOperatorExamples >> findWhitespaceIn_Hello_at_1 [
	<gtExample>
	| text editor whitespace |
	
	text := 'Hello' asRopedText.
	editor := AlbTextEditor new text: text.
	whitespace := editor inserter findWhitespaceOfLineBefore: 1.

	self assert: whitespace = ''.

	^ whitespace
]

{ #category : #'utility - examples' }
AlbTextEditorOperatorExamples >> findWhitespaceIn_Hello_at_2 [
	<gtExample>
	| text editor whitespace |
	
	text := 'Hello' asRopedText.
	editor := AlbTextEditor new text: text.
	whitespace := editor inserter findWhitespaceOfLineBefore: 2.

	self assert: whitespace = ''.

	^ whitespace
]

{ #category : #'utility - examples' }
AlbTextEditorOperatorExamples >> findWhitespaceIn_Hello_at_3 [
	<gtExample>
	| text editor whitespace |
	
	text := 'Hello' asRopedText.
	editor := AlbTextEditor new text: text.
	whitespace := editor inserter findWhitespaceOfLineBefore: 3.

	self assert: whitespace = ''.

	^ whitespace
]

{ #category : #'utility - examples' }
AlbTextEditorOperatorExamples >> findWhitespaceIn_Hello_at_4 [
	<gtExample>
	| text editor whitespace |
	
	text := 'Hello' asRopedText.
	editor := AlbTextEditor new text: text.
	whitespace := editor inserter findWhitespaceOfLineBefore: 4.

	self assert: whitespace = ''.

	^ whitespace
]

{ #category : #'utility - examples' }
AlbTextEditorOperatorExamples >> findWhitespaceIn_Hello_at_5 [
	<gtExample>
	| text editor whitespace |
	
	text := 'Hello' asRopedText.
	editor := AlbTextEditor new text: text.
	whitespace := editor inserter findWhitespaceOfLineBefore: 5.

	self assert: whitespace = ''.

	^ whitespace
]

{ #category : #'utility - examples' }
AlbTextEditorOperatorExamples >> findWhitespaceIn_Hello_cr_World_at_6 [
	<gtExample>
	| text editor whitespace |
	
	text := ('Hello', String cr, 'World') asRopedText.
	editor := AlbTextEditor new text: text.
	whitespace := editor inserter findWhitespaceOfLineBefore: 6.
	
	self assert: whitespace = ''.
	
	^ whitespace
]

{ #category : #'utility - examples' }
AlbTextEditorOperatorExamples >> findWhitespaceIn_Hello_cr_World_at_7 [
	<gtExample>
	| text editor whitespace |
	
	text := ('Hello', String cr, 'World') asRopedText.
	editor := AlbTextEditor new text: text.
	whitespace := editor inserter findWhitespaceOfLineBefore: 7.
	
	self assert: whitespace = ''.
	
	^ whitespace
]

{ #category : #'utility - examples' }
AlbTextEditorOperatorExamples >> findWhitespaceIn_Hello_cr_World_at_8 [
	<gtExample>
	| text editor whitespace |
	
	text := ('Hello', String cr, 'World') asRopedText.
	editor := AlbTextEditor new text: text.
	whitespace := editor inserter findWhitespaceOfLineBefore: 8.
	
	self assert: whitespace = ''.
	
	^ whitespace
]

{ #category : #'utility - examples' }
AlbTextEditorOperatorExamples >> findWhitespaceIn_Hello_cr_space_World_at_6 [
	<gtExample>
	| text editor whitespace |
	
	text := ('Hello', String cr, ' World') asRopedText.
	editor := AlbTextEditor new text: text.
	whitespace := editor inserter findWhitespaceOfLineBefore: 6.
	
	self assert: whitespace = ''.
	
	^ whitespace
]

{ #category : #'utility - examples' }
AlbTextEditorOperatorExamples >> findWhitespaceIn_Hello_cr_space_World_at_7 [
	<gtExample>
	| text editor whitespace |
	
	text := ('Hello', String cr, ' World') asRopedText.
	editor := AlbTextEditor new text: text.
	whitespace := editor inserter findWhitespaceOfLineBefore: 7.
	
	self assert: whitespace = ' '.
	
	^ whitespace
]

{ #category : #'utility - examples' }
AlbTextEditorOperatorExamples >> findWhitespaceIn_Hello_cr_space_World_at_8 [
	<gtExample>
	| text editor whitespace |
	
	text := ('Hello', String cr, ' World') asRopedText.
	editor := AlbTextEditor new text: text.
	whitespace := editor inserter findWhitespaceOfLineBefore: 8.
	
	self assert: whitespace = ' '.
	
	^ whitespace
]

{ #category : #'utility - examples' }
AlbTextEditorOperatorExamples >> findWhitespaceIn_space_Hello_at_0 [
	<gtExample>
	| text editor whitespace |
	
	text := ' Hello' asRopedText.
	editor := AlbTextEditor new text: text.
	whitespace := editor inserter findWhitespaceOfLineBefore: 0.
	
	self assert: whitespace = ''.
	
	^ whitespace
]

{ #category : #'utility - examples' }
AlbTextEditorOperatorExamples >> findWhitespaceIn_space_Hello_at_1 [
	<gtExample>
	| text editor whitespace |
	
	text := ' Hello' asRopedText.
	editor := AlbTextEditor new text: text.
	whitespace := editor inserter findWhitespaceOfLineBefore: 1.
	
	self assert: whitespace = ' '.
	
	^ whitespace
]

{ #category : #'utility - examples' }
AlbTextEditorOperatorExamples >> findWhitespaceIn_space_Hello_at_2 [
	<gtExample>
	| text editor whitespace |
	
	text := ' Hello' asRopedText.
	editor := AlbTextEditor new text: text.
	whitespace := editor inserter findWhitespaceOfLineBefore: 2.
	
	self assert: whitespace = ' '.
	
	^ whitespace
]

{ #category : #'utility - examples' }
AlbTextEditorOperatorExamples >> findWhitespaceIn_space_at_0 [
	<gtExample>
	| text editor whitespace |
	
	text := ' ' asRopedText.
	editor := AlbTextEditor new text: text.
	whitespace := editor inserter findWhitespaceOfLineBefore: 0.
	
	self assert: whitespace = ''.
	
	^ whitespace
]

{ #category : #'utility - examples' }
AlbTextEditorOperatorExamples >> findWhitespaceIn_space_at_1 [
	<gtExample>
	| text editor whitespace |
	
	text := ' ' asRopedText.
	editor := AlbTextEditor new text: text.
	whitespace := editor inserter findWhitespaceOfLineBefore: 1.
	
	self assert: whitespace = ' '.
	
	^ whitespace
]

{ #category : #'utility - examples' }
AlbTextEditorOperatorExamples >> findWhitespaceIn_space_space_at_0 [
	<gtExample>
	| text editor whitespace |
	
	text := '  ' asRopedText.
	editor := AlbTextEditor new text: text.
	whitespace := editor inserter findWhitespaceOfLineBefore: 0.
	
	self assert: whitespace = ''.
	
	^ whitespace
]

{ #category : #'utility - examples' }
AlbTextEditorOperatorExamples >> findWhitespaceIn_space_space_at_1 [
	<gtExample>
	| text editor whitespace |
	
	text := '  ' asRopedText.
	editor := AlbTextEditor new text: text.
	whitespace := editor inserter findWhitespaceOfLineBefore: 1.
	
	self assert: whitespace = ' '.
	
	^ whitespace
]

{ #category : #'utility - examples' }
AlbTextEditorOperatorExamples >> findWhitespaceIn_space_space_at_2 [
	<gtExample>
	| text editor whitespace |
	
	text := '  ' asRopedText.
	editor := AlbTextEditor new text: text.
	whitespace := editor inserter findWhitespaceOfLineBefore: 2.
	
	self assert: whitespace = '  '.
	
	^ whitespace
]

{ #category : #'utility - examples' }
AlbTextEditorOperatorExamples >> findWhitespaceIn_space_tab_at_0 [
	<gtExample>
	| text editor whitespace |
	
	text := (' ', String tab) asRopedText.
	editor := AlbTextEditor new text: text.
	whitespace := editor inserter findWhitespaceOfLineBefore: 0.
	
	self assert: whitespace = ''.
	
	^ whitespace
]

{ #category : #'utility - examples' }
AlbTextEditorOperatorExamples >> findWhitespaceIn_space_tab_at_1 [
	<gtExample>
	| text editor whitespace |
	
	text := (' ', String tab) asRopedText.
	editor := AlbTextEditor new text: text.
	whitespace := editor inserter findWhitespaceOfLineBefore: 1.
	
	self assert: whitespace = ' '.
	
	^ whitespace
]

{ #category : #'utility - examples' }
AlbTextEditorOperatorExamples >> findWhitespaceIn_space_tab_at_2 [
	<gtExample>
	| text editor whitespace |
	
	text := (' ', String tab) asRopedText.
	editor := AlbTextEditor new text: text.
	whitespace := editor inserter findWhitespaceOfLineBefore: 2.
	
	self assert: whitespace = (' ', String tab).
	
	^ whitespace
]

{ #category : #'instance creation' }
AlbTextEditorOperatorExamples >> multilineText [
	<gtExample>
	
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

{ #category : #'private - utility' }
AlbTextEditorOperatorExamples >> piecesWithCursorIn: anEditorElement [
	^ anEditorElement withAllChildrenAlbeadthFirst
		select: [ :eachChild | eachChild isKindOf: AlbCursorElement ]
		thenCollect: [ :eachCursor | eachCursor parent ]
]

{ #category : #'private - events' }
AlbTextEditorOperatorExamples >> subscribe: anEventClass do: aBlock for: anElement [
	anElement when: anEventClass do: aBlock
]

{ #category : #'private - events' }
AlbTextEditorOperatorExamples >> unsubscribe: anEventClass from: anElement [
	anElement removeEventHandlersSuchThat: [ :anEventHandler | (anEventHandler isKindOf: BlEventHandler) and: [ anEventHandler eventClass = anEventClass ] ]
]
