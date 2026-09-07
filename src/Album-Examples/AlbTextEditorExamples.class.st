"
# Today we will learn how to compose an editor

##It is as simple as computing a factorial, a piece of cake!

```
	10 factorial
```

### First create the text 

`AlbTextEditorExamples>>#newText`

### Next, we build the editor

`AlbTextEditorExamples>>#newEditor`

### Then, we attach text to the editor.

`AlbTextEditorExamples>>#editor:text:`

### Next, we create an editor element.

`AlbTextEditorExamples>>#newElement`

### And finally, build everything together

`AlbTextEditorExamples>>#element:editorText:`

# Done 

"
Class {
	#name : #AlbTextEditorExamples,
	#superclass : #Object,
	#classInstVars : [
		'loremIpsum'
	],
	#category : #'Album-Examples-Editor'
}

{ #category : #examples }
AlbTextEditorExamples class >> editorWithAdormentDynamicAttribute [
	<sampleInstance>

	| text |
	text := self newThreeLineText.
	text
		attributes: { 
			AlbTextAdornmentDynamicAttribute new 
				stencil: [ 
					BlElement new 
						extent: 70 @ 50; 
						margin: (BlInsets all: 5);
						background: Color red ] }
		from: 1
		to: text size.

	^ self newElement text: text; yourself
]

{ #category : #examples }
AlbTextEditorExamples class >> editorWithAdormentDynamicAttributeReturningEmptyCollection [
	<sampleInstance>

	| text |
	text := self newThreeLineText.
	text
		attributes: { 
			AlbTextAdornmentDynamicAttribute new 
				stencil: [ #() ] }
		from: 1
		to: text size.

	^ self newElement text: text; yourself
]

{ #category : #examples }
AlbTextEditorExamples class >> editorWithAdormentDynamicAttributeReturningTwoElements [
	<sampleInstance>

	| text |
	text := self newThreeLineText.
	text
		attributes: { 
			AlbTextAdornmentDynamicAttribute new 
				stencil: [ 
					{ BlElement new 
						extent: 70 @ 50; 
						margin: (BlInsets all: 5);
						background: Color red.
					BlElement new 
						extent: 70 @ 50; 
						margin: (BlInsets all: 5);
						background: Color green } ] }
		from: 1
		to: 2.

	^ self newElement text: text; yourself
]

{ #category : #'examples - editing' }
AlbTextEditorExamples class >> editorWithAlbumText [
	<sampleInstance>

	^ self newElement
		text: self simpleString asRopedText;
		yourself
]

{ #category : #'examples - editing' }
AlbTextEditorExamples class >> editorWithLastHiddenCharacter [
	<gtExample>
	| anEditor |
	anEditor := self editorWithAlbumText.
	(anEditor text from: anEditor text size to: anEditor text size)
		attribute: self newBeReplaceTextAttribute.
	self assert: anEditor text asString equals: self simpleString.
	^ anEditor
]

{ #category : #'examples - editing' }
AlbTextEditorExamples class >> editorWithSecondHiddenCharacter [
	<gtExample>
	| anEditor |
	anEditor := self editorWithAlbumText.
	(anEditor text from: 2 to: 2)
		attribute: self newBeReplaceTextAttribute.
	self assert: anEditor text asString equals: self simpleString.
	^ anEditor
]

{ #category : #'examples - comparison' }
AlbTextEditorExamples class >> exampleLoremIpsum [

	| space editorElement text |
	editorElement := AlbEditorElement new.
	editorElement
		constraintsDo:
			[ :c | 
			c horizontal matchParent.
			c vertical matchParent ].
	text := self loremIpsum asRopedText.
	editorElement text: text.

	space := BlSpace new.
	space extent: self extent.
	space root addChild: editorElement.
	space show
]

{ #category : #examples }
AlbTextEditorExamples class >> exampleMethodTextOpenEmbedElement [
	<script>

	| space editorElement |
	editorElement := self newElement.

	editorElement editor text
		attributes: { BlFontSizeAttribute size: 18 }.

	editorElement editor text
		attributes: {
			AlbTextAdornmentDynamicAttribute new
				stencil: [
					BlElement new
						extent: 70 @ 50;
						background: Color red;
						yourself ];
				yourself
		} from: 30 to: 30.

	editorElement constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical matchParent ].

	space := BlSpace new.
	space extent: 800@400.
	space root addChild: editorElement.
	space show
]

{ #category : #examples }
AlbTextEditorExamples class >> exampleTextOpen [
	<script>

	| space editorElement |
	editorElement := self newElement.
	editorElement editor text attributes: {
			(BlFontSizeAttribute size: 18).
			(BlFontFamilyAttribute named: 'Helvetica Neue') }.
	editorElement constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical matchParent ].

	space := BlSpace new.
	space root addChild: editorElement.
	space root addEventHandler: (BlEventHandler
			 on: BlDoubleClickEvent
			 do: [ :evt | BlElementSelection on: evt target ]).
	space show
]

{ #category : #'examples - comparison' }
AlbTextEditorExamples class >> extent [

	^ 600 @ 400
]

{ #category : #'examples - editing' }
AlbTextEditorExamples class >> insertAStringAfterLastHiddenCharacter [
	<gtExample>
	| anEditor |
	anEditor := self editorWithLastHiddenCharacter.
	anEditor insertString: '_' at: anEditor text size.
	self assert: anEditor text asString equals: self simpleString, '_'.
	^ anEditor
]

{ #category : #'examples - editing' }
AlbTextEditorExamples class >> insertAStringAfterSecondHiddenCharacter [
	<gtExample>
	| anEditor |
	anEditor := self editorWithSecondHiddenCharacter.
	anEditor insertString: '_' at: 2.
	self assert: anEditor text asString equals: 'Alb_ick'.
	^ anEditor
]

{ #category : #'examples - editing' }
AlbTextEditorExamples class >> insertLineFeedString [
	<gtExample>
	| anEditor |
	anEditor := self editorWithAlbumText.
	anEditor insertString: String lf at: anEditor text size.
	self assert: anEditor text asString equals: self simpleString, String lf.
	^ anEditor
]

{ #category : #'examples - editing' }
AlbTextEditorExamples class >> insertLineFeedStringAfterLastHiddenCharacter [
	<gtExample>
	| anEditor |
	anEditor := self editorWithLastHiddenCharacter.
	anEditor insertString: String lf at: anEditor text size.
	self assert: anEditor text asString equals: self simpleString, String lf.
	^ anEditor
]

{ #category : #'examples - editing' }
AlbTextEditorExamples class >> insertLineFeedStringAfterSecondHiddenCharacter [
	<gtExample>
	| anEditor |
	anEditor := self editorWithSecondHiddenCharacter.
	anEditor insertString: String lf at: 2.
	self assert: anEditor text asString equals: 'Alb', String lf, 'ick'.
	^ anEditor
]

{ #category : #'examples - editing' }
AlbTextEditorExamples class >> insertLineFeedStringBeforeSecondHiddenCharacter [
	<gtExample>
	| anEditor |
	anEditor := self editorWithSecondHiddenCharacter.
	anEditor insertString: String lf at: 1.
	self assert: anEditor text asString equals: 'B', String lf, 'rick'.
	^ anEditor
]

{ #category : #'examples - comparison' }
AlbTextEditorExamples class >> loremIpsum [
	^ self loremIpsum: 1000000
]

{ #category : #'examples - comparison' }
AlbTextEditorExamples class >> loremIpsum: aLength [

	loremIpsum ifNil: [ loremIpsum := Dictionary new ].
	^ loremIpsum
			at: aLength asString asSymbol
			ifAbsentPut: [ String loremIpsum: aLength ]
]

{ #category : #'examples - editing' }
AlbTextEditorExamples class >> newBeReplaceTextAttribute [

	^ AlbTextAdornmentDynamicAttribute new
		beReplace;
		stencil: [ BlElement new 
			extent: 10@10; 
			background: Color lightGray ];
		yourself
]

{ #category : #'instance creation' }
AlbTextEditorExamples class >> newEditor [

	^ AlbTextEditor new 
]

{ #category : #'instance creation' }
AlbTextEditorExamples class >> newElement [
	
	^ AlbEditorElement new
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ];
		yourself
]

{ #category : #'instance creation' }
AlbTextEditorExamples class >> newMethodText [
	
	^ (Integer >> #bitAnd:) sourceCode asRopedText
]

{ #category : #'instance creation' }
AlbTextEditorExamples class >> newText [
	
	^ (String loremIpsum: 2000000) asRopedText
]

{ #category : #'instance creation' }
AlbTextEditorExamples class >> newThreeLineText [
	
	^ ('first' , String cr , 'second' , String cr , 'third') asRopedText
]

{ #category : #'examples - editing' }
AlbTextEditorExamples class >> simpleString [

	^ 'Album'
]

{ #category : #'examples - embedded' }
AlbTextEditorExamples >> newElement [
	
	^ AlbEditorElement new
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ];
		yourself
]
