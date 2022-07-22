Class {
	#name : #AlbExamplesSeeClassSide,
	#superclass : #Object,
	#category : #'Album-SandBox'
}

{ #category : #'instance creation' }
AlbExamplesSeeClassSide class >> ascent [
	^ -20
]

{ #category : #'instance creation' }
AlbExamplesSeeClassSide class >> descent [
	^ 20
]

{ #category : #'instance creation' }
AlbExamplesSeeClassSide class >> editorFor: aText [

	<return: #AlbEditor>
	| anEditor aRopedText |
	aRopedText := aText asRopedText
		              lineSpacing: self lineSpacing;
		              paragraphMargin: self paragraphMargin;
		              wordPadding: self wordPadding.

	anEditor := AlbEditor new.
	anEditor padding: BlInsets empty.
	anEditor fitContent.
	anEditor text: aRopedText.

	"BlDevCrossover on: anEditor."

	"anEditor editor  beLineBased."
	anEditor editor segmentBuilder wordStencil: [ :aTAlbTextEditorTextualPiece | 
		| aTextElement |
		aTextElement := AlbTextWordPieceStencilBuilder editable
			                segmentPiece: aTAlbTextEditorTextualPiece;
			                asElement.
		aTextElement measurer: self fixedMeasurer.
		aTextElement measurer textOffset: aTAlbTextEditorTextualPiece textStart.
		aTextElement ].


	^ anEditor
]

{ #category : #'editor examples' }
AlbExamplesSeeClassSide class >> example_CodeEditorWithRBStylerWithClickAndHoverAttributes [

	| text styler editorElement space |
	self flag: 'does not work, no change when cursor hover and click (even in GalmourousToolki)'.
	text := self methodText asRopedText fontSize: 12;
		 fontName: 'Source Code Pro'.

	styler := AlbRBTextStyler new.
	styler classOrMetaClass: self class.

	editorElement := AlbEditor new 
		dresser: AlbTextAreaDresser new;
		styler: styler;
		text: text.

	editorElement withLineNumbers.

	editorElement editor text attributes: {
		(BlFontSizeAttribute size: 18) beNotOverwritableByStyler.
	}.
	
	editorElement editorText attributes: {
		AlbTextHoverStylableAttribute new attribute: (BlTextDecorationAttribute new underline color: Color blue); beNotOverwritableByStyler.
		AlbTextClickAttribute new action: [:a :b :c :d | self inform: d asString]; beNotOverwritableByStyler
	} from: 1 to: 10.
	
	editorElement constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical matchParent ].

	space := BlSpace new.
	space extent: 800@400.
	space root addChild: editorElement.
	space show
	
	
]

{ #category : #'editor examples' }
AlbExamplesSeeClassSide class >> example_CodeEditorWithRBStylerWithDresser [

	| text styler editorElement space |

	text := self methodText asRopedText fontSize: 16;
		 fontName: 'Source Code Pro'.

	styler := AlbRBTextStyler new.
	styler classOrMetaClass: self class.

	editorElement := AlbEditor new 
		dresser: AlbTextAreaDresser new;
		styler: styler;
		text: text.

	editorElement clipChildren: false.
	editorElement withLineNumbers.
	"editorElement inspect."
	editorElement editor
		addEditorShortcut:
			(BlShortcutWithAction new
				combination: BlKeyCombination primaryR;
				action: [ :aShortcutEvent | self inform: 'shortcut catched' ]).

	space := OBlSpace new.
	space root addChild: editorElement.
	space title: 'editor'.
	space show.
	
	
]

{ #category : #'editor examples' }
AlbExamplesSeeClassSide class >> example_EditorAsTextAreaWithDresser [

	| ed space |

	ed := AlbEditor new dresser: AlbTextAreaDresser.
	ed constraintsDo: [ :c | 
		c vertical resizer: BlLayoutResizer fitContent. 
		c horizontal resizer: BlLayoutResizer matchParent].
	ed text: String loremIpsum.
	space := OBlSpace new.
	space root addChild: ed.
	space title: 'editor'.
	space show.

	^ed
]

{ #category : #'editor examples' }
AlbExamplesSeeClassSide class >> example_EditorAsTextAreaWithHighlight [

	| ed space text |
	ed := AlbEditor new.
	text := 'ABCD' asRopedText.
	text attribute: (BlTextBackgroundAttribute paint: (Color blue alpha: 0.3)) from: 1 to: 1.
	text attribute: (BlTextBackgroundAttribute paint: (Color yellow alpha: 0.5)) from: 2 to: 2.
	text attribute: (BlTextBackgroundAttribute paint: (Color red alpha: 0.3)) from: 3 to: 3.
	text
		fontSize: 24;
		fontName: 'Helvetica Neue'.
	ed text: text.
	space := BlSpace new.
	space root addChild: ed.
	space title: 'editor'.
	"ed inspect."

	space show.
	^ ed
]

{ #category : #'editor examples' }
AlbExamplesSeeClassSide class >> example_EditorAsTextAreaWithoutAnyDresser [

	| ed space |
	ed := AlbEditor new.
	"ed withLineNumbers."
	ed text: (String loremIpsum asRopedText
			 "fontSize: 16;
			 fontName: 'Helvetica Neue'").
	space := BlSpace new.
	space root addChild: ed.
	space title: 'editor'.
	"ed inspect."

	space show.
	^ ed
]

{ #category : #'editor examples' }
AlbExamplesSeeClassSide class >> example_EditorWithBigText [

	| ed |
	"The insertion bogue arise around 342225"
	ed := ((String loremIpsum: 10000) asRopedText
		       fontSize: 16;
		       fontName: 'Helvetica Neue') onAlbum.
	ed constraintsDo: [ :c | 
		"c vertical resizer: BlLayoutResizer fitContent. "
		"c horizontal resizer: BlLayoutResizer fitContent"].
	"ed inspect."
	ed withLineNumbers.
	ed openInOblSpace
]

{ #category : #'editor examples' }
AlbExamplesSeeClassSide class >> example_EditorWithDynamicAttribute [

	| cache attribute text ed space |

	cache := Dictionary new.
	
	attribute := AlbTextAdornmentDynamicAttribute new
		beAppend;
		withCache: cache key: #key;
		stencil: [  {  
			BlElement new
				background: (Color gray alpha: 0.4);
				size: 20@100.
				BlElement new
				background: (Color red alpha: 0.4);
				size: 20@10. } ].

	text := 'Hello >' asRopedText attribute: attribute.
	ed := AlbEditor new "dresser: AlbTextAreaDresser new".
	ed constraintsDo: [ :c | 
		c vertical resizer: BlLayoutResizer fitContent. 
		c horizontal resizer: BlLayoutResizer matchParent].

	ed text: text.
	"ed inspect."
	space := OBlSpace new.
	space root addChild: ed.
	space title: 'editor'.
	space show.
	^ text
]

{ #category : #'instance creation' }
AlbExamplesSeeClassSide class >> example_FixedMeasurer [
	" have to understand this ..."
	| anEditor |
	anEditor := self editorFor: 'Hello'.
	anEditor openInOBlSpace 

]

{ #category : #'instance creation' }
AlbExamplesSeeClassSide class >> example_FixedMeasurer0 [
	| element text |
	text := ('1234567890' asRopedText
		       fontSize: 16;
		       fontName: 'Helvetica Neue').
	element := text asElement.
	element measurer: self fixedMeasurer.
	element openInOblSpace
]

{ #category : #'editor examples' }
AlbExamplesSeeClassSide class >> example_RopedTextWithDifferentFontSize [


	((' ( Monospace 40 ) ' asRopedText
		  fontSize: 40;
		  monospace) , (' Default font and size' asRopedText "attributes: {(BlTextHighlightAttribute paint: (Color red) veryMuchLighter )}")) onAlbum withLineNumbers;"inspect" openInOblSpace
]

{ #category : #elements }
AlbExamplesSeeClassSide class >> example_elements_sandbox [

	| sp root child1 child2 |
	root := BlElement new background: Color cyan.
	child1 := BlElement new background: Color yellow.
	child2 := BlElement new background: Color gray.
	root layout: BlFlowLayout new.
	root addChild: child1.
	root addChild: child2.
	root constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical matchParent ].
	sp := OBlSpace new.
	sp addChild: root.
	sp show
]

{ #category : #'instance creation' }
AlbExamplesSeeClassSide class >> fixedMeasurer [
	^ BlTextElementMockedMeasurer new
		ascent: self ascent;
		descent: self descent;
		glyphWidth: self glyphWidth;
		glyphHeight: self glyphHeight
]

{ #category : #'instance creation' }
AlbExamplesSeeClassSide class >> glyphHeight [
	^ self ascent abs + self descent
]

{ #category : #'instance creation' }
AlbExamplesSeeClassSide class >> glyphWidth [
	^ 30
]

{ #category : #'instance creation' }
AlbExamplesSeeClassSide class >> lineSpacing [
	^ 5
]

{ #category : #accessing }
AlbExamplesSeeClassSide class >> methodText [
	^ self  class sourceCodeAt: #example_CodeEditorWithRBStylerWithDresser
]

{ #category : #'instance creation' }
AlbExamplesSeeClassSide class >> paragraphMargin [
	^ BlInsets all: 15
]

{ #category : #'instance creation' }
AlbExamplesSeeClassSide class >> wordPadding [
	^ BlInsets top: 3 bottom: 3
]
