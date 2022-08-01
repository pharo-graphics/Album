Class {
	#name : #AlbExamplesSeeClassSide,
	#superclass : #Object,
	#category : #'Album-SandBox'
}

{ #category : #accessing }
AlbExamplesSeeClassSide class >> ascent [
	^ -20
]

{ #category : #accessing }
AlbExamplesSeeClassSide class >> descent [
	^ 20
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
	text := ('AB', String tab, String tab, 'CD') asRopedText.
	text attribute: (BlTextBackgroundAttribute paint: (Color blue alpha: 0.3)) from: 1 to: 1.
	text attribute: (BlTextBackgroundAttribute paint: (Color yellow alpha: 0.5)) from: 3 to: 6.
	text attribute: (BlTextBackgroundAttribute paint: (Color yellow alpha: 0.5)) from: 2 to: 2.
	text attribute: (BlTextBackgroundAttribute paint: (Color red alpha: 0.3)) from: 3 to: 3.
	text
		fontSize: 24;
		fontName: 'Helvetica Neue'.
	ed text: text.
		"ed inspect."

	space := BlSpace new.
	space root addChild: ed.
	space title: 'editor'.

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
	ed inspect.

	space show.
	^ ed
]

{ #category : #'editor examples' }
AlbExamplesSeeClassSide class >> example_EditorWithBigText [

	| ed |
	"The insertion bogue arise around 342225"
	ed := ((String loremIpsum: 10000000) asRopedText
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

{ #category : #'editor examples' }
AlbExamplesSeeClassSide class >> example_RopedTextWithDifferentFontSize [


	((' ( Monospace 40 ) ' asRopedText
		  fontSize: 40;
		  monospace) , (' Default font and size' asRopedText "attributes: {(BlTextHighlightAttribute paint: (Color red) veryMuchLighter )}")) onAlbum withLineNumbers;"inspect" openInOblSpace
]

{ #category : #'editor examples' }
AlbExamplesSeeClassSide class >> example_WithClickAndHoverAttributes [

	| text styler editorElement space clickText hoverText |
	self flag: 'Works, but should be revised because the implementaion of these attributes in Album is really crappy'.
	clickText := 'Clik here'.
	hoverText := 'Mouse over here'.
	text := (clickText , ' ' , hoverText) asRopedText.
	editorElement := AlbEditor new text: text.

	editorElement editorText
		attributes: { 
				(BlTextBackgroundAttribute new paint: Color lightBlue).
				(AlbTextClickAttribute new action: [ :a :b :c :d | 
					 self inform: a asString , ' ' , b asString , ' ' , c asString , ' ' , d asString ]) }
		from: 1
		to: 9.

	editorElement editorText
		attributes: { 
				(BlTextBackgroundAttribute new paint: Color yellow).
				(AlbTextHoverAttribute new
					 enterAction: [ :a :b :c :d | 
						 self inform: 'ENTER : ' , a asString , ' ' , b asString , ' ' , c asString , ' ' , d asString ];
					 leaveAction: [ :a :b :c :d | 
						 self inform: 'LEAVE : ' , a asString , ' ' , b asString , ' ' , c asString , ' ' , d asString ]) }
		from: 11
		to: 25.

	space := BlSpace new.
	space root addChild: editorElement.
	space show
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
