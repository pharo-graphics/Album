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

{ #category : #'editor examples' }
AlbExamplesSeeClassSide class >> example_CodeEditorWithRBStylerWithDresser [

	| text styler editorElement space |

	text := self methodText asRopedText.

	styler := AlbRBTextStyler new.
	styler classOrMetaClass: self class.

	editorElement := AlbEditor new 
		dresser: AlbTextAreaDresser new;
		styler: styler;
		text: text.
	"editorElement editor useTaskItStylerStrategy."
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
	^ ed
]

{ #category : #'editor examples' }
AlbExamplesSeeClassSide class >> example_EditorAsTextAreaWithoutAnyDresser [

	| ed space |

	ed := AlbEditor new.
	ed text: String loremIpsum.
	space := OBlSpace new.
	space root addChild: ed.
	space title: 'editor'.
	space show.
	"ed inspect."
	^ ed
]

{ #category : #'editor examples' }
AlbExamplesSeeClassSide class >> example_EditorWithBigText [
	(String loremIpsum: 10000000) onAlbum openInOblSpace
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

{ #category : #'editor examples' }
AlbExamplesSeeClassSide class >> example_RopedTextWithDifferentFontSize [


	((' Monospace 40 ' asRopedText
		  fontSize: 40;
		  monospace) , (' Default font and size' asRopedText "attributes: {(BlTextHighlightAttribute paint: (Color red) veryMuchLighter )}")) onAlbum inspect "openInOblSpace"
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
