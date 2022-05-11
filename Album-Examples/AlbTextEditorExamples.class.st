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

{ #category : #cleanup }
AlbTextEditorExamples class >> cleanUp [
	super cleanUp.
	
	loremIpsum := nil 
]

{ #category : #'examples - comparison' }
AlbTextEditorExamples class >> exampleEditor [
	| space editorElement editor text |
	editorElement := AlbEditorElement new.
	editorElement
		constraintsDo:
			[ :c | 
			c horizontal matchParent.
			c vertical matchParent ].
	editor := AlbTextEditor new.
	text := self loremIpsum asRopedText.
	editor text: text.
	editorElement editor: editor.
	space := OblSpace new.
	space extent: self extent.
	space root addChild: editorElement.
	space show
]

{ #category : #examples }
AlbTextEditorExamples class >> exampleMethodTextOpen [
	| space editorElement |

	editorElement := (self >> #elementOnMethodWithSyntaxHighlighting) gtExample returnValue.
	editorElement editor text attributes: {
		(BlFontSizeAttribute size: 18) beNotOverwritableByStyler.
	}.
	editorElement editor text attributes: {
		AlbTextHoverStylableAttribute new beNotOverwritableByStyler.
		AlbTextClickAttribute new beNotOverwritableByStyler
	} from: 39 to: 42.
	editorElement constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical matchParent ].

	space := OblSpace new.
	space extent: 800@400.
	space root addChild: editorElement.
	space show.
]

{ #category : #examples }
AlbTextEditorExamples class >> exampleMethodTextOpenEmbedElement [
	| space editorElement |

	editorElement := (self >> #elementWithMethod) gtExample returnValue.
	editorElement editor text attributes: {
		BlFontSizeAttribute size: 18.
	}.
	editorElement editor text attributes: {
		AlbTextAdornmentDynamicAttribute new stencil: [ BlElement new size: 70 @ 50; background: Color red; yourself ]
	} from: 30 to: 30.
	editorElement constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical matchParent ].

	space := OblSpace new.
	space extent: 800@400.
	space root addChild: editorElement.
	space show.
]

{ #category : #examples }
AlbTextEditorExamples class >> exampleTextOpen [
	| space editorElement |
	
	editorElement := (self >> #elementWithEditor) gtExample returnValue.
	editorElement editor text attributes: {
		BlFontSizeAttribute size: 18.
		BlFontFamilyAttribute named: 'Helvetica Neue'.
	}.
	editorElement constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical matchParent ].
	
	space := OblSpace new.
	space root addChild: editorElement.
	space root addEventHandler:
			(BlEventHandler
				on: BlDoubleClickEvent
				do: [ :evt | BlElementSelection on: evt target ]).
	space show
]

{ #category : #'examples - comparison' }
AlbTextEditorExamples class >> extent [
	^ 600@400
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

{ #category : #examples }
AlbTextEditorExamples >> adormentDynamicAttribute [
	<gtExample>
	
	^ self newElement editor: self editorWithAdormentDynamicAttribute
]

{ #category : #'examples - editing' }
AlbTextEditorExamples >> brickString [
	<gtExample>
	^ 'Album'
]

{ #category : #examples }
AlbTextEditorExamples >> editorWithAdormentDynamicAttribute [
	<gtExample>
	| editor text |
	text := self newThreeLineText.
	editor := self newEditor text: text.
	editor text
		attributes: { 
			AlbTextAdornmentDynamicAttribute new 
				stencil: [ 
					BlElement new 
						size: 70 @ 50; 
						margin: (BlInsets all: 5);
						background: Color red ] }
		from: 1
		to: text size.
	^ editor
]

{ #category : #examples }
AlbTextEditorExamples >> editorWithAdormentDynamicAttributeReturningEmptyCollection [
	<gtExample>
	| editor text |
	text := self newThreeLineText.
	editor := self newEditor text: text.
	editor text
		attributes: { 
			AlbTextAdornmentDynamicAttribute new 
				stencil: [ #() ] }
		from: 1
		to: text size.
	^ editor
]

{ #category : #examples }
AlbTextEditorExamples >> editorWithAdormentDynamicAttributeReturningTwoElements [
	<gtExample>
	| editor text |
	text := self newThreeLineText.
	editor := self newEditor text: text.
	editor text
		attributes: { 
			AlbTextAdornmentDynamicAttribute new 
				stencil: [ 
					{ BlElement new 
						size: 70 @ 50; 
						margin: (BlInsets all: 5);
						background: Color red.
					BlElement new 
						size: 70 @ 50; 
						margin: (BlInsets all: 5);
						background: Color green } ] }
		from: 1
		to: text size.
	^ editor
]

{ #category : #'examples - editing' }
AlbTextEditorExamples >> editorWithAlbumText [
	<gtExample>
	| anEditor aText |
	anEditor := self newEditor.
	aText := self brickString asRopedText.
	anEditor text: aText.
	self assert: anEditor text equals: aText.
	^ anEditor
]

{ #category : #'examples - editing' }
AlbTextEditorExamples >> editorWithLastHiddenCharacter [
	<gtExample>
	| anEditor |
	anEditor := self editorWithAlbumText.
	(anEditor text from: anEditor text size to: anEditor text size)
		attribute: self newBeReplaceTextAttribute.
	self assert: anEditor text asString equals: self brickString.
	^ anEditor
]

{ #category : #'examples - editor' }
AlbTextEditorExamples >> editorWithMethod [
	<gtExample>
	^ self newEditor text: self newMethodText
]

{ #category : #'examples - editing' }
AlbTextEditorExamples >> editorWithSecondHiddenCharacter [
	<gtExample>
	| anEditor |
	anEditor := self editorWithAlbumText.
	(anEditor text from: 2 to: 2)
		attribute: self newBeReplaceTextAttribute.
	self assert: anEditor text asString equals: self brickString.
	^ anEditor
]

{ #category : #examples }
AlbTextEditorExamples >> editorWithText [
	<gtExample>
	^ self newEditor text: self newText
]

{ #category : #examples }
AlbTextEditorExamples >> elementOnMethodWithSyntaxHighlighting [
	<gtExample>
	| element styler text editor |
	text := self newMethodText.
	element := self newElement.
	editor := self newEditor.
	styler := AlbRBTextStyler new.
	styler classOrMetaClass: Object.
	editor styler: styler.
	editor text: text.
	element editor: editor.
	^ element
]

{ #category : #examples }
AlbTextEditorExamples >> elementWithEditor [
	<gtExample>
	
	^ self newElement editor: self editorWithText
]

{ #category : #examples }
AlbTextEditorExamples >> elementWithEmptyEditor [
	<gtExample>
	
	^ self newElement editor: (self newEditor text: (' ' asRopedText fontSize: 16; monospace))
]

{ #category : #examples }
AlbTextEditorExamples >> elementWithMethod [
	<gtExample>
	
	^ self newElement editor: self editorWithMethod
]

{ #category : #'instance creation' }
AlbTextEditorExamples >> fullDrawOn: aCanvas [
	"Draw the full Morphic structure on the given Canvas"

	self visible ifFalse: [^ self].
	(aCanvas isVisible: self fullBounds) ifFalse:[^self].
	
	(self hasProperty: #errorOnDraw) ifTrue:[^self drawErrorOn: aCanvas].
	
	[
		"Note: At some point we should generalize this into some sort of 
		multi-canvas so that we can cross-optimize some drawing operations."
		"Pass 1: Draw eventual drop-shadow"
		self hasDropShadow ifTrue: [ self drawDropShadowOn: aCanvas ].

		"Pass 2: Draw receiver itself"
		
		aCanvas roundCornersOf: self during:[
			(aCanvas isVisible: self bounds) ifTrue:[aCanvas drawMorph: self].
			self drawSubmorphsOn: aCanvas.
			self drawDropHighlightOn: aCanvas.
			self drawMouseDownHighlightOn: aCanvas]
		
	] on: Error do: [:err |
		self setProperty: #errorOnDraw toValue: true.
		self setProperty: #drawError toValue: err freeze.
		^ self drawErrorOn: aCanvas
	]
]

{ #category : #'examples - editing' }
AlbTextEditorExamples >> insertAStringAfterLastHiddenCharacter [
	<gtExample>
	| anEditor |
	anEditor := self editorWithLastHiddenCharacter.
	anEditor insertString: '_' at: anEditor text size.
	self assert: anEditor text asString equals: self brickString, '_'.
	^ anEditor
]

{ #category : #'examples - editing' }
AlbTextEditorExamples >> insertAStringAfterSecondHiddenCharacter [
	<gtExample>
	| anEditor |
	anEditor := self editorWithSecondHiddenCharacter.
	anEditor insertString: '_' at: 2.
	self assert: anEditor text asString equals: 'Alb_ick'.
	^ anEditor
]

{ #category : #'examples - editing' }
AlbTextEditorExamples >> insertLineFeedString [
	<gtExample>
	| anEditor |
	anEditor := self editorWithAlbumText.
	anEditor insertString: String lf at: anEditor text size.
	self assert: anEditor text asString equals: self brickString, String lf.
	^ anEditor
]

{ #category : #'examples - editing' }
AlbTextEditorExamples >> insertLineFeedStringAfterLastHiddenCharacter [
	<gtExample>
	| anEditor |
	anEditor := self editorWithLastHiddenCharacter.
	anEditor insertString: String lf at: anEditor text size.
	self assert: anEditor text asString equals: self brickString, String lf.
	^ anEditor
]

{ #category : #'examples - editing' }
AlbTextEditorExamples >> insertLineFeedStringAfterSecondHiddenCharacter [
	<gtExample>
	| anEditor |
	anEditor := self editorWithSecondHiddenCharacter.
	anEditor insertString: String lf at: 2.
	self assert: anEditor text asString equals: 'Alb', String lf, 'ick'.
	^ anEditor
]

{ #category : #'examples - editing' }
AlbTextEditorExamples >> insertLineFeedStringBeforeSecondHiddenCharacter [
	<gtExample>
	| anEditor |
	anEditor := self editorWithSecondHiddenCharacter.
	anEditor insertString: String lf at: 1.
	self assert: anEditor text asString equals: 'B', String lf, 'rick'.
	^ anEditor
]

{ #category : #'examples - editing' }
AlbTextEditorExamples >> newBeReplaceTextAttribute [
	<gtExample>
	^ AlbTextAdornmentDynamicAttribute new
		beReplace;
		stencil: [ BlElement new 
			size: 10@10; 
			background: Color lightGray ]
]

{ #category : #'instance creation' }
AlbTextEditorExamples >> newEditor [
	<gtExample>

	^ AlbTextEditor new beLineBased
]

{ #category : #'instance creation' }
AlbTextEditorExamples >> newElement [
	<gtExample>
	
	^ AlbEditorElement new
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ];
		yourself
]

{ #category : #'instance creation' }
AlbTextEditorExamples >> newMethodText [
	<gtExample>
	
	^ (AlbTextEditorExamples >> #fullDrawOn:) sourceCode asRopedText
]

{ #category : #'instance creation' }
AlbTextEditorExamples >> newText [
	<gtExample>
	
	^ (String loremIpsum: 2000000) asRopedText
]

{ #category : #'instance creation' }
AlbTextEditorExamples >> newThreeLineText [
	<gtExample>
	
	^ ('first' , String cr , 'second' , String cr , 'third') asRopedText
]
