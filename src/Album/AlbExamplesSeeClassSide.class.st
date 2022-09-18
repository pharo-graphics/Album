Class {
	#name : #AlbExamplesSeeClassSide,
	#superclass : #Object,
	#classVars : [
		'BigString'
	],
	#category : #'Album-SandBox'
}

{ #category : #accessing }
AlbExamplesSeeClassSide class >> ascent [
	^ -20
]

{ #category : #'editor examples' }
AlbExamplesSeeClassSide class >> bigString [
	"1000000000 is 1Go, ~200 000 pages in LibreOffice - 3 600 000 lines on TextMaker "
	^ BigString ifNil: [ BigString := String loremIpsum: 1000000000 ]
]

{ #category : #'editor examples' }
AlbExamplesSeeClassSide class >> bigStringFromFile [
	" self bigStringFromFile "

	| fref stream |
	fref := 'bigFile.txt' asFileReference.
	fref exists ifFalse: [ self inform: fref fullName, ' does''nt exists' ].
	stream := fref readStream.
	BigString := stream contents.
	stream close
]

{ #category : #'editor examples' }
AlbExamplesSeeClassSide class >> bigStringToFile [
	" self bigStringToFile "

	| fref stream |
	fref := 'bigFile.txt' asFileReference.
	fref deleteIfAbsent: [  ].
	stream := fref writeStream.
	stream nextPutAll: self bigString.
	stream close
]

{ #category : #'editor examples' }
AlbExamplesSeeClassSide class >> cleanUp [ 
	super cleanUp.
	BigString := nil
]

{ #category : #accessing }
AlbExamplesSeeClassSide class >> descent [
	^ 20
]

{ #category : #'editor examples' }
AlbExamplesSeeClassSide class >> example_CodeEditorWithRBStylerWithDresser [

	| text styler editorElement space |

	text := self methodText asRopedText fontName: 'Source Sans Pro'; fontSize: 20.

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
"editorElement inspect."
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
	"ed inspect."

	space show.
	^ ed
]

{ #category : #'editor examples' }
AlbExamplesSeeClassSide class >> example_EditorPharoChangesText [

	| ed  |
	" ~4300 pages on LibreOffice, ~8000000 characters "
	ed := Smalltalk changesFile readStream contents onAlbum.
	"ed recycler inspect."
	ed withLineNumbers.
	ed openInOblSpace
]

{ #category : #'editor examples' }
AlbExamplesSeeClassSide class >> example_EditorWithBigText [

	| ed |
	"The insertion bogue arise around 342225"
	ed := self bigString asRopedText onAlbum.
	"ed constraintsDo: [ :c | 
		c vertical resizer: BlLayoutResizer fitContent. 
		c horizontal resizer: BlLayoutResizer fitContent]."
	"ed inspect."
	ed withLineNumbers.
	ed openInOblSpace
]

{ #category : #'editor examples' }
AlbExamplesSeeClassSide class >> example_EditorWithDynamicAttribute [
"
broken in GlamorousToolKit but what to do with that ?
| cache attribute text ed space |

	cache := Dictionary new.
	
	attribute := BrTextAdornmentDynamicAttribute new
	""beSync;
		beAppend;""
		withCache: cache key: #key;
		stencil: [  {  
			BlElement new
				background: (Color gray alpha: 0.4);
				size: 20@100.
			BlElement new
				background: (Color red alpha: 0.4);
				size: 20@10. } ].

	text := 'Hello >' asRopedText attribute: attribute.
	ed := BrEditor new aptitude: BrGlamorousRegularEditorAptitude new.
	ed constraintsDo: [ :c | 
		c vertical resizer: BlLayoutResizer fitContent. 
		c horizontal resizer: BlLayoutResizer matchParent].

	ed text: text.
	""ed inspect.""
	space := BlSpace new.
	space root addChild: ed.
	space title: 'editor'.
	space show.
	^ text
"
	| cache attribute text ed space |

	cache := Dictionary new.
	
	attribute := AlbTextAdornmentDynamicAttribute new
		beSync;
		"beAppend;"
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
AlbExamplesSeeClassSide class >> example_EditorWithReplacingAdornment [


	| aText ed |

	aText := ('Hello', String cr, 'World') asRopedText fontSize: 20.
	(aText from: 4 to: 4)
		replacingAdornment: [ BlElement new size: 20@6; background: Color red ].
	ed := aText onAlbum.
	ed withLineNumbers.
	ed openInOblSpace
]

{ #category : #'editor examples' }
AlbExamplesSeeClassSide class >> example_EditorWithSegNumbers [

	| ed t |
	"The insertion bogue arise around 342225"
	"100000000 is ~20 000 pages in LibreOffice - 360 000 lines on TextMaker "
	t := String streamContents: [ :stream | 
		1 to: 400000 do: [ :l | 
			stream << l asString << ': 1234567890'; lf ] ].
	ed := (t asRopedText
		       fontSize: 16;
		       fontName: 'Helvetica Neue') onAlbum.
	ed withLineNumbers.
	ed openInOblSpace
]

{ #category : #elements }
AlbExamplesSeeClassSide class >> example_ExperimentForMultilineLabel [

	| element r |
	r := Random new.
	element := BlElement new
		           layout: (AlbLineFlowLayout new lineSpacing: 5);
		           constraintsDo: [ :c | 
			           c horizontal matchParent.
			           c vertical fitContent ];
		           addChildren:
			           (20 timesCollect: [ ((String loremIpsum: (r nextIntegerBetween: 2 and: 40)), String tab) asRopedText asElement ]).
	element openInOBlSpace
]

{ #category : #'editor examples' }
AlbExamplesSeeClassSide class >> example_RopedTextWithDifferentFontSize [

	(' Default font and size' asRopedText
	 , (' ( Monospace 40 ) ' asRopedText fontSize: 40; monospace) 
	 , ' Default font and size' asRopedText) onAlbum
		withLineNumbers;
		"inspect"openInOblSpace "attributes: {(BlTextHighlightAttribute paint: (Color red) veryMuchLighter )}"
]

{ #category : #elements }
AlbExamplesSeeClassSide class >> example_ScaledElement [

	| content scalable |
	content := BlElement new
		           size: 20 @ 20;
		           background: Color red.

	scalable := BlScalableElement new.
	
	scalable scaleStrategy: (BlScalableFixedStrategy zoom: 3). "set custom zoom level"
	"scalable scaleStrategy: BlScalableFitWidthStrategy new." "Fit horizontally"
	"scalable scaleStrategy: BlScalableFitHeightStrategy new. ""Fit vertically""
	scalable scaleStrategy: BlScalableFitAllStrategy new. ""Fit vertically and horizontally at the same time"""
	scalable constraintsDo: [ :c | 
		c horizontal matchParent.
		c vertical matchParent ].

	scalable contentElement: content.
	scalable openInOBlSpace
]

{ #category : #elements }
AlbExamplesSeeClassSide class >> example_TextFlowWithAnimatedZoomableElements [

	| element |
	element := BlElement new
		           layout: (AlbLineFlowLayout new lineSpacing: 10);
		           constraintsDo: [ :c | 
			           c horizontal matchParent.
			           c vertical matchParent ];
		           addChildren: (20 timesCollect: [ 
					            | e zoomable anim |
					            anim := BlSequentialAnimation withAll: { 
								                    (BlTransformAnimation new
									                     absolute;
									                     duration: 1 seconds;
									                     in: [ :elem | 
										                     elem transform
											                     scaleBy: 10@10;
											                     apply ];
									                     yourself).
								                    (BlTransformAnimation new
									                     absolute;
									                     duration: 2 seconds;
									                     in: [ :elem | 
										                     elem transform
											                     scaleBy: 0.5 asPoint;
											                     apply ];
									                     yourself) }.
					            anim beInfinite.
					            e := BlElement new
						                 size: 10 @ 10;
						                 margin: (BlInsets all: 1);
						                 background: (Color random alpha: 0.5).
					            zoomable := BlZoomableElement new.
					            zoomable constraintsDo: [ :c | 
						            c horizontal fitContent.
						            c vertical fitContent ].
					            zoomable zoomLevel: 10.
					            zoomable border: (BlBorder paint: Color gray width: 1).
					            zoomable addChild: e.
					            e addAnimation: anim.
					            zoomable ]).
	element openInNewSpace
]

{ #category : #elements }
AlbExamplesSeeClassSide class >> example_TextFlowWithBlElements [

	| element |
	element := BlElement new
		           layout: (AlbLineFlowLayout new lineSpacing: 10);
		           constraintsDo: [ :c | 
			           c horizontal matchParent.
			           c vertical matchParent ];
		           addChildren: (20 timesCollect: [ 
					            | anAnimation |
					            anAnimation := BlSequentialAnimation new.
					            anAnimation add:
							            (BlTransformAnimation scale: 2) absolute.
					            anAnimation add:
							            (BlTransformAnimation scale: 0.5) absolute.
					            anAnimation beInfinite.
					            BlElement new
						            size: 50 @ 20;
						            margin: (BlInsets all: 4);
						            background: (Color random alpha: 0.5);
						            addAnimation: anAnimation ]).
	element openInOBlSpace
]

{ #category : #'editor examples' }
AlbExamplesSeeClassSide class >> example_WithClickAndHoverAttributes [

	| text styler editorElement space clickText hoverText |
	self flag: 'Works, but should be revised because the implementaion of these attributes in Album is really crappy'.
	clickText := '	<Clik here>'.
	hoverText := '<<<Mouse over here >>>'.
	text := (clickText , ' ' , hoverText) asRopedText.
	editorElement := AlbEditor new text: text.

	"editorElement editorText
		attributes: { 
				(BlTextBackgroundAttribute new paint: Color lightBlue).
				(AlbTextEventHandlerAttribute new when: BlClickEvent do: [ :anEvent | self inform: anEvent asString. anEvent consumed: true ]) }
		from: 3
		to: 11."

"	editorElement editorText
		attributes: { 
				(BlTextBackgroundAttribute new paint: Color yellow).
				(AlbTextEventHandlerAttribute new
					 when: BlMouseEnterEvent do: [ :anEvent | self inform: anEvent asString. anEvent consumed: true ];
					 when: BlMouseLeaveEvent do: [ :anEvent | self inform: anEvent asString. anEvent consumed: true ]) }
		from: 17
		to: 30."

	space := BlSpace new.
	space root addChild: editorElement.
	space show
]

{ #category : #'editor examples' }
AlbExamplesSeeClassSide class >> example_WithCrLfOnly [

	| ed space |
	ed := AlbEditor new text: String crlf.
	ed editor segmentCollector inspect.
	ed withLineNumbers.
	space := BlSpace new.
	space root addChild: ed.
	space show
]

{ #category : #'editor examples' }
AlbExamplesSeeClassSide class >> example_WithCrOnly [

	| ed space |
	ed := AlbEditor new text: String cr.
	ed editor segmentCollector inspect.
	ed withLineNumbers.
	space := BlSpace new.
	space root addChild: ed.
	space show
]

{ #category : #'editor examples' }
AlbExamplesSeeClassSide class >> example_WithCrWithCrLf [

	| ed space |
	ed := AlbEditor new text: 'Before Cr', String cr, 'Before CrLf', String crlf, 'After'.
	ed withLineNumbers.
	space := BlSpace new.
	space root addChild: ed.
	space show
]

{ #category : #'editor examples' }
AlbExamplesSeeClassSide class >> example_WithEmptyText [

	| ed space |
	ed := AlbEditor new.
	space := BlSpace new.
	space root addChild: ed.
	space show
]

{ #category : #'editor examples' }
AlbExamplesSeeClassSide class >> example_WithHelloWorld [

	| ed space text editor |
	text := ('Hello World') asRopedText fontSize: 40.
	editor := AlbTextEditor new text: text.
	ed := AlbEditor new.
	ed withLineNumbers.
	ed editor: editor.
	space := BlSpace new.
	space root addChild: ed.
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
