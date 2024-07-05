Class {
	#name : #AlbExamplesSeeClassSide,
	#superclass : #Object,
	#classVars : [
		'BigString'
	],
	#category : #'Album-Examples-TRY-HERE'
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
AlbExamplesSeeClassSide class >> embeddedFontsText [

	"
AeFontSlant: normal italic oblique.
AeFontWeight: black bold extraBlack extraBold extraLight light medium normal semiBold semiLight thin
AeFontStretch: condensed expanded extraCondensed extraExpanded normal semiCondensed semiExpanded ultraCondensed ultraExpanded 
"

	| aManager allSlants allWeights allStreches text allChars |
	allChars := 'azertyuiopqsdfghjklmwxcvbn' , String cr , 'AZERTYUIOPQSDFGHJKLMWXCVBN' , String cr , '1234567890'
	            , String cr , '@&é"''[(§è!çà)]-#°_¨*%£+/*.?' , String cr , '~^$`ù=:;,~|'.
	"AeFontManager resetGlobalInstance."
	aManager := AeFontManager globalInstance .
	allSlants := { 
		             BlFontSlant normal.
		             BlFontSlant italic.
		             BlFontSlant oblique }.
	allWeights := { 
		              BlFontWeight normal.
		              BlFontWeight light.
		              BlFontWeight extraLight.
		              BlFontWeight medium.
		              BlFontWeight bold.
		              BlFontWeight semiBold.
		              BlFontWeight extraBold.
		              BlFontWeight black.
		              BlFontWeight extraBlack.
		              BlFontWeight thin }.
	allStreches := { 
		               BlFontStretch normal.
		               BlFontStretch condensed.
		               BlFontStretch semiCondensed.
		               BlFontStretch extraCondensed.
		               BlFontStretch ultraCondensed.
		               BlFontStretch expanded.
		               BlFontStretch semiExpanded.
		               BlFontStretch extraExpanded.
		               BlFontStretch ultraExpanded }.

	text := '' asRopedText.
	aManager familyNames do: [ :fname | 
		allSlants do: [ :slant | 
			allWeights do: [ :weight | 
				allStreches do: [ :strech | 
					(aManager
						 detectFamilyName: fname
						 slant: (AeFontSlant perform: slant name asSymbol)
						 weight: (AeFontWeight perform: weight name asSymbol)
						 stretch: (AeFontStretch perform: strech name asSymbol)
						 ifNone: [  ]) in: [ :face | 
						face ifNotNil: [ 
							| fontBuilder t |
							fontBuilder := BlTextFontAndStyleBuilder new.
							fontBuilder familyName: fname.
							fontBuilder fontSize: 18.
							fontBuilder fontStretch: strech.
							fontBuilder fontWeight: weight.
							fontBuilder fontSlant: slant.
							t := allChars copy asRopedText.
							fontBuilder font applyOnText: t.
							text := text, (String cr , String cr , String cr , fname , ' slant: ' , slant name , ' weight: ' , weight name
							         , ' strech: ' , strech name , ' ' , String cr , String cr) asRopedText , t ] ] ] ] ] ].
	^ text
]

{ #category : #'editor examples' }
AlbExamplesSeeClassSide class >> example_EditorAsTextAreaWithHighlight [

	| ed space text |
	ed := AlbEditorElement new.
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
AlbExamplesSeeClassSide class >> example_EditorAsTextAreaWithSubtextElement [

	| ed space text size start |
	ed := AlbEditorElement new.
	text := String loremIpsum asRopedText.
	text fontSize: 24.
	ed text: text.
	size := 10.
	start := 1.
	1 to: 25 do: [ :pos |
		| deco |
		deco := (AlbSubtextElement editorElement: ed)
			        interval: (start to: start + size);
			        yourself.
		deco addEventHandler: AlbSubtextElementEventHandler new.
		deco background: (Color random alpha: 0.4).
		deco border: BlBorder empty.
		deco addEventHandler: (BlEventHandler
				 on: BlClickEvent
				 do: [ :event | event currentTarget removeFromParent ]).
		deco addEventHandler: (BlEventHandler
				 on: BlMouseEnterEvent
				 do: [ :event |
					 event currentTarget border:
						 (BlBorder paint: Color black width: 1) ]).
		deco addEventHandler: (BlEventHandler
				 on: BlMouseLeaveEvent
				 do: [ :event | event currentTarget border: BlBorder empty ]).
		ed frontLayer addChild: deco.
		start := start + size + 5 ].

	space := BlSpace new.
	space root addChild: ed.
	space title: 'editor'.
	space extent: 400 @ 200.
	space show.
	^ ed
]

{ #category : #'editor examples' }
AlbExamplesSeeClassSide class >> example_EditorAsTextAreaWithoutAnyDresser [

	| ed space |
	ed := AlbEditorElement new.
	"ed withLineNumbers."
	ed text: (String loremIpsum asRopedText).
	space := BlSpace new.
	space root addChild: ed.
	space title: 'editor'.
	"ed inspect."

	space show.
	^ ed
]

{ #category : #'editor examples' }
AlbExamplesSeeClassSide class >> example_EditorPharoChangesText [

	| ed vscrollBar space text |
	" ~4300 pages on LibreOffice, ~8000000 characters "
	text := Smalltalk changesFile readStream contents asRopedText.
	ed := AlbEditorElement new .
	ed text: text.
	ed withRowNumbers; withoutCacheLimit.
	vscrollBar := BlVerticalScrollbarElement new.
	vscrollBar constraintsDo: [ :c |
			c ignoreByLayout.
			c margin: (BlInsets right: 2).
			c ignored horizontal alignRight.
			c ignored vertical alignBottom]. 
	vscrollBar attachTo: ed infinite.
	space := BlSpace new.
	space root addChild: ed.
	space root addChild: vscrollBar.
	space show.

]

{ #category : #'editor examples' }
AlbExamplesSeeClassSide class >> example_EditorWithAllFonts [
	"
AeFontSlant: normal italic oblique.
AeFontWeight: black bold extraBlack extraBold extraLight light medium normal semiBold semiLight thin
AeFontStretch: condensed expanded extraCondensed extraExpanded normal semiCondensed semiExpanded ultraCondensed ultraExpanded 
"

	| aManager allSlants allWeights allStreches root text child allChars vscrollBar |
	allChars := 'azertyuiopqsdfghjklmwxcvbn' , String cr
	            , 'AZERTYUIOPQSDFGHJKLMWXCVBN' , String cr , '1234567890'
	            , String cr , '@&é"''(§è!çà)-#°_¨*%£+/.?' , String cr
	            , '€^$`ù=:;,~|'.
	AeFontManager resetGlobalInstance.
	aManager := AeFontManager globalInstance.
	aManager scanEmbeddedFonts.
	aManager scanDefaultDirectories.
	allSlants := {
		             BlFontSlant normal.
		             BlFontSlant italic.
		             BlFontSlant oblique }.
	allWeights := {
		              BlFontWeight normal.
		              BlFontWeight light.
		              BlFontWeight extraLight.
		              BlFontWeight medium.
		              BlFontWeight bold.
		              BlFontWeight semiBold.
		              BlFontWeight extraBold.
		              BlFontWeight black.
		              BlFontWeight extraBlack.
		              BlFontWeight thin }.
	allStreches := {
		               BlFontStretch normal.
		               BlFontStretch condensed.
		               BlFontStretch semiCondensed.
		               BlFontStretch extraCondensed.
		               BlFontStretch ultraCondensed.
		               BlFontStretch expanded.
		               BlFontStretch semiExpanded.
		               BlFontStretch extraExpanded.
		               BlFontStretch ultraExpanded }.

	root := BlElement new constraintsDo: [ :c |
		        c vertical matchParent.
		        c horizontal matchParent ].
	text := '' asRopedText.
	aManager familyNames do: [ :fname |
		allSlants do: [ :slant |
			allWeights do: [ :weight |
				allStreches do: [ :strech |
					(aManager
						 detectFamilyName: fname
						 slant: (AeFontSlant perform: slant name asSymbol)
						 weight: (AeFontWeight perform: weight name asSymbol)
						 stretch: (AeFontStretch perform: strech name asSymbol)
						 ifNone: [  ]) in: [ :face |
						face ifNotNil: [
							| fontBuilder t |
							fontBuilder := BlTextFontAndStyleBuilder new.
							fontBuilder familyName: fname.
							fontBuilder fontSize: 18.
							fontBuilder fontStretch: strech.
							fontBuilder fontWeight: weight.
							fontBuilder fontSlant: slant.
							t := allChars copy asRopedText.
							fontBuilder font applyOnText: t.
							text append:
								(String cr , String cr , String cr , fname , ' slant: '
								 , slant name , ' weight: ' , weight name , ' strech: '
								 , strech name , ' ' , String cr , String cr) asRopedText.
							text append: t ] ] ] ] ] ].
	child := text onAlbum.
	vscrollBar := BlVerticalScrollbarElement new.
	vscrollBar constraintsDo: [ :c |
		c ignoreByLayout.
		c margin: (BlInsets right: 2).
		c ignored horizontal alignRight.
		c ignored vertical alignBottom ].
	vscrollBar attachTo: child infinite.
	root addChild: child.
	root addChild: vscrollBar.
	root openInSpace
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
	ed withRowNumbers.
	ed openInSpace
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
	ed := AlbEditorElement new "dresser: AlbTextAreaDresser new".
	ed constraintsDo: [ :c | 
		c vertical resizer: BlLayoutResizer fitContent. 
		c horizontal resizer: BlLayoutResizer matchParent].

	ed text: text.
	"ed inspect."
	space := BlSpace new.
	space root addChild: ed.
	space title: 'editor'.
	space show.
	^ text
]

{ #category : #'editor examples' }
AlbExamplesSeeClassSide class >> example_EditorWithEmbeddedFonts [

	"
AeFontSlant: normal italic oblique.
AeFontWeight: black bold extraBlack extraBold extraLight light medium normal semiBold semiLight thin
AeFontStretch: condensed expanded extraCondensed extraExpanded normal semiCondensed semiExpanded ultraCondensed ultraExpanded 
"

	| root text child |
	root := BlElement new constraintsDo: [ :c | 
		        c vertical matchParent.
		        c horizontal matchParent ].
	text := self embeddedFontsText.
	child := text onAlbum.
	root addChild: child.
	root openInOBlSpace
]

{ #category : #'editor examples' }
AlbExamplesSeeClassSide class >> example_EditorWithLorem [

	| ed space hscrollBar |

	ed := AlbEditorElement new.
	ed constraintsDo: [ :c | 
		c vertical resizer: BlLayoutResizer matchParent. 
		c horizontal resizer: BlLayoutResizer matchParent].
	ed text: ((String loremIpsum: 100000) asRopedText "fontName: 'Source Code Pro'").
	
	hscrollBar := BlHorizontalScrollbarElement new.
	hscrollBar constraintsDo: [ :c |
			c ignoreByLayout.
			c margin: (BlInsets bottom: 2).
			c ignored vertical alignBottom]. 
	hscrollBar attachTo: ed infinite.
	ed inspect.
	space := BlSpace new.
	space root addChild: ed.
	space root addChild: hscrollBar.
	space show.
	^ed
]

{ #category : #'editor examples' }
AlbExamplesSeeClassSide class >> example_EditorWithReplacingAdornment [

	| aText ed |
	aText := ('Hello' , String cr , 'World') asRopedText fontSize: 20.
	(aText from: 4 to: 4) replacingAdornment: [
		BlElement new
			size: 20 @ 6;
			background: Color red ].
	ed := aText onAlbum.
	ed withRowNumbers.
	ed openInSpace
]

{ #category : #'editor examples' }
AlbExamplesSeeClassSide class >> example_EditorWithSegNumbers [

	| ed t |
	"The insertion bogue arise around 342225""100000000 is ~20 000 pages in LibreOffice - 360 000 lines on TextMaker "
	t := String streamContents: [ :stream |
		     1 to: 400000 do: [ :l |
			     (stream << l asString)
				     << ': 1234567890';
				     lf ] ].
	ed := (t asRopedText fontSize: 16) onAlbum.
	ed withRowNumbers.
	ed openInSpace
]

{ #category : #'editor examples' }
AlbExamplesSeeClassSide class >> example_EditorWithTGCA [

	| ed tgca tgcaText colorIndex vscrollBar space |
	colorIndex := IdentityDictionary new.
	colorIndex at: $T put: (Color red alpha: 0.4).
	colorIndex at: $G put: (Color blue alpha: 0.4).
	colorIndex at: $C put: (Color green alpha: 0.4).
	colorIndex at: $A put: (Color yellow alpha: 0.4).

	"The insertion bogue arise around 342225"
	tgca := self tgcaString.
	tgcaText := '' asRopedText  fontSize: 25.
	tgca linesDo: [ :l | 
		| lrt |
		lrt := l asRopedText.
		l withIndexDo: [ :c :idx | 
			(colorIndex at: c ifAbsent: [  ]) in: [ :color | 
				color ifNotNil: [ lrt attribute: (BlTextBackgroundAttribute paint: color) from: idx to: idx ] ] ].
		tgcaText append: ((lrt , String cr asRopedText) fontName: 'Source Code Pro'; fontSize: 20)].

	ed := tgcaText onAlbum.
	ed withRowNumbers.
	ed withoutSoftLine.
	
	vscrollBar := BlVerticalScrollbarElement new.
	vscrollBar constraintsDo: [ :c |
			c ignoreByLayout.
			c margin: (BlInsets right: 2).
			c ignored horizontal alignRight.
			c ignored vertical alignBottom]. 
	vscrollBar attachTo: ed infinite.
	space := BlSpace new.
	space root addChild: ed.
	space root addChild: vscrollBar.
	space show.
	
	
]

{ #category : #'editor examples' }
AlbExamplesSeeClassSide class >> example_RopedTextWithDifferentFontSize [

	(' Default font and size' asRopedText
	 , (' ( Source code pro 40 bold ) ' asRopedText
			  fontSize: 40;
			  fontName: 'Source code pro';
			  bold) , (' Default font 30' asRopedText fontSize: 30)) onAlbum
		withRowNumbers;
		openInSpace
]

{ #category : #'editor examples' }
AlbExamplesSeeClassSide class >> example_WithClickAndHoverAttributes [

	| text styler editorElement space clickText hoverText |
	self flag: 'Works, but should be revised because the implementaion of these attributes in Album is really crappy'.
	clickText := '	<Clik here>'.
	hoverText := '<<<Mouse over here >>>'.
	text := (clickText , ' ' , hoverText) asRopedText.
	editorElement := AlbEditorElement new text: text.

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
	ed := AlbEditorElement new text: String crlf.
	ed editor segmentCollector inspect.
	ed withRowNumbers.
	space := BlSpace new.
	space root addChild: ed.
	space show
]

{ #category : #'editor examples' }
AlbExamplesSeeClassSide class >> example_WithCrOnly [

	| ed space |
	ed := AlbEditorElement new text: String cr.
	ed editor segmentCollector inspect.
	ed withRowNumbers.
	space := BlSpace new.
	space root addChild: ed.
	space show
]

{ #category : #'editor examples' }
AlbExamplesSeeClassSide class >> example_WithCrWithCrLf [

	| ed space |
	ed := AlbEditorElement new text: 'Before Cr', String cr, 'Before CrLf', String crlf, 'After'.
	ed withRowNumbers.
	space := BlSpace new.
	space root addChild: ed.
	space show
]

{ #category : #'editor examples' }
AlbExamplesSeeClassSide class >> example_WithEmptyText [

	| ed space |
	ed := AlbEditorElement new.
	space := BlSpace new.
	space root addChild: ed.
	space show
]

{ #category : #'editor examples' }
AlbExamplesSeeClassSide class >> example_WithEmptyTextFitContents [

	| ed space |
self flag: 'does not work'.
	ed := AlbEditorElement new.
	ed text: 'bla bla'.
	"ed constraintsDo: [ :c | 
		c horizontal fitContent.
		c vertical fitContent ]."
	ed fitContent.
	space := BlSpace new.
	space root addChild: ed.
	space show
]

{ #category : #'editor examples' }
AlbExamplesSeeClassSide class >> example_WithHelloWorld [

	| ed space text |
	text := 'Hello World' asRopedText fontSize: 40.
	ed := AlbEditorElement new.
	ed withRowNumbers.
	ed text: text.
	space := BlSpace new.
	space root addChild: ed.
	space show
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

{ #category : #'instance creation' }
AlbExamplesSeeClassSide class >> paragraphMargin [
	^ BlInsets all: 15
]

{ #category : #'editor examples' }
AlbExamplesSeeClassSide class >> tgcaString [
	^ 'ATTAAAGGTTTATACCTTCCCAGGTAACAAACCAACCAACTTTCGATCTCTTGTAGATCTGTTCTCTAAACGAACTT
AACATAGCAGTGGTGTTACCCGTGAACTCATGCGTGAGCTTAACGGAGGGGCATACACTCGCTATGTCGATAACAAC
TTCTGTGGCCCTGATGTAAAATCTGTGTGGCTGTCACTCGGCTGCATGCTTAGTGCACTCACGCAGTATAATTAATA
ACTAATTACTGTCGTTGACAGGACACGAGTAACTCGTCTATCTTCTGCAGGCTGCTTACGGTTTCGTCCGTGTTGCA
GCCGATCATCAGCACATCTAGGTTTCGTCCGGGTGTGACCGAAAGGTAAGATGGAGAGCCTTGTCCCTGGTTTCAAC
GAGAAAACACACGTCCAACTCAGTTTGCCTGTTTTACAGGTTCGCGACGTGCTCGTACGTGGCTTTGGAGACTCCGT
GGAGGAGGTCTTATCAGAGGCACGTCAACATCTTAAAGATGGCACTTGTGGCTTAGTAGAAGTTGAAAAAGGCGTTT
ATTAAAGGTTTATACCTTCCCAGGTAACAAACCAACCAACTTTCGATCTCTTGTAGATCTGTTCTCTAAACGAACTT
AACATAGCAGTGGTGTTACCCGTGAACTCATGCGTGAGCTTAACGGAGGGGCATACACTCGCTATGTCGATAACAAC
TTCTGTGGCCCTGATGTAAAATCTGTGTGGCTGTCACTCGGCTGCATGCTTAGTGCACTCACGCAGTATAATTAATA
ACTAATTACTGTCGTTGACAGGACACGAGTAACTCGTCTATCTTCTGCAGGCTGCTTACGGTTTCGTCCGTGTTGCA
GCCGATCATCAGCACATCTAGGTTTCGTCCGGGTGTGACCGAAAGGTAAGATGGAGAGCCTTGTCCCTGGTTTCAAC
GAGAAAACACACGTCCAACTCAGTTTGCCTGTTTTACAGGTTCGCGACGTGCTCGTACGTGGCTTTGGAGACTCCGT
GGAGGAGGTCTTATCAGAGGCACGTCAACATCTTAAAGATGGCACTTGTGGCTTAGTAGAAGTTGAAAAAGGCGTTT
ATTAAAGGTTTATACCTTCCCAGGTAACAAACCAACCAACTTTCGATCTCTTGTAGATCTGTTCTCTAAACGAACTT
AACATAGCAGTGGTGTTACCCGTGAACTCATGCGTGAGCTTAACGGAGGGGCATACACTCGCTATGTCGATAACAAC
TTCTGTGGCCCTGATGTAAAATCTGTGTGGCTGTCACTCGGCTGCATGCTTAGTGCACTCACGCAGTATAATTAATA
ACTAATTACTGTCGTTGACAGGACACGAGTAACTCGTCTATCTTCTGCAGGCTGCTTACGGTTTCGTCCGTGTTGCA
GCCGATCATCAGCACATCTAGGTTTCGTCCGGGTGTGACCGAAAGGTAAGATGGAGAGCCTTGTCCCTGGTTTCAAC
GAGAAAACACACGTCCAACTCAGTTTGCCTGTTTTACAGGTTCGCGACGTGCTCGTACGTGGCTTTGGAGACTCCGT
GGAGGAGGTCTTATCAGAGGCACGTCAACATCTTAAAGATGGCACTTGTGGCTTAGTAGAAGTTGAAAAAGGCGTTT
ATTAAAGGTTTATACCTTCCCAGGTAACAAACCAACCAACTTTCGATCTCTTGTAGATCTGTTCTCTAAACGAACTT
AACATAGCAGTGGTGTTACCCGTGAACTCATGCGTGAGCTTAACGGAGGGGCATACACTCGCTATGTCGATAACAAC
TTCTGTGGCCCTGATGTAAAATCTGTGTGGCTGTCACTCGGCTGCATGCTTAGTGCACTCACGCAGTATAATTAATA
ACTAATTACTGTCGTTGACAGGACACGAGTAACTCGTCTATCTTCTGCAGGCTGCTTACGGTTTCGTCCGTGTTGCA
GCCGATCATCAGCACATCTAGGTTTCGTCCGGGTGTGACCGAAAGGTAAGATGGAGAGCCTTGTCCCTGGTTTCAAC
GAGAAAACACACGTCCAACTCAGTTTGCCTGTTTTACAGGTTCGCGACGTGCTCGTACGTGGCTTTGGAGACTCCGT
GGAGGAGGTCTTATCAGAGGCACGTCAACATCTTAAAGATGGCACTTGTGGCTTAGTAGAAGTTGAAAAAGGCGTTT
ATTAAAGGTTTATACCTTCCCAGGTAACAAACCAACCAACTTTCGATCTCTTGTAGATCTGTTCTCTAAACGAACTT
AACATAGCAGTGGTGTTACCCGTGAACTCATGCGTGAGCTTAACGGAGGGGCATACACTCGCTATGTCGATAACAAC
TTCTGTGGCCCTGATGTAAAATCTGTGTGGCTGTCACTCGGCTGCATGCTTAGTGCACTCACGCAGTATAATTAATA
ACTAATTACTGTCGTTGACAGGACACGAGTAACTCGTCTATCTTCTGCAGGCTGCTTACGGTTTCGTCCGTGTTGCA
GCCGATCATCAGCACATCTAGGTTTCGTCCGGGTGTGACCGAAAGGTAAGATGGAGAGCCTTGTCCCTGGTTTCAAC
GAGAAAACACACGTCCAACTCAGTTTGCCTGTTTTACAGGTTCGCGACGTGCTCGTACGTGGCTTTGGAGACTCCGT
GGAGGAGGTCTTATCAGAGGCACGTCAACATCTTAAAGATGGCACTTGTGGCTTAGTAGAAGTTGAAAAAGGCGTTT
ATTAAAGGTTTATACCTTCCCAGGTAACAAACCAACCAACTTTCGATCTCTTGTAGATCTGTTCTCTAAACGAACTT
AACATAGCAGTGGTGTTACCCGTGAACTCATGCGTGAGCTTAACGGAGGGGCATACACTCGCTATGTCGATAACAAC
TTCTGTGGCCCTGATGTAAAATCTGTGTGGCTGTCACTCGGCTGCATGCTTAGTGCACTCACGCAGTATAATTAATA
ACTAATTACTGTCGTTGACAGGACACGAGTAACTCGTCTATCTTCTGCAGGCTGCTTACGGTTTCGTCCGTGTTGCA
GCCGATCATCAGCACATCTAGGTTTCGTCCGGGTGTGACCGAAAGGTAAGATGGAGAGCCTTGTCCCTGGTTTCAAC
GAGAAAACACACGTCCAACTCAGTTTGCCTGTTTTACAGGTTCGCGACGTGCTCGTACGTGGCTTTGGAGACTCCGT
GGAGGAGGTCTTATCAGAGGCACGTCAACATCTTAAAGATGGCACTTGTGGCTTAGTAGAAGTTGAAAAAGGCGTTT
ATTAAAGGTTTATACCTTCCCAGGTAACAAACCAACCAACTTTCGATCTCTTGTAGATCTGTTCTCTAAACGAACTT
AACATAGCAGTGGTGTTACCCGTGAACTCATGCGTGAGCTTAACGGAGGGGCATACACTCGCTATGTCGATAACAAC
TTCTGTGGCCCTGATGTAAAATCTGTGTGGCTGTCACTCGGCTGCATGCTTAGTGCACTCACGCAGTATAATTAATA
ACTAATTACTGTCGTTGACAGGACACGAGTAACTCGTCTATCTTCTGCAGGCTGCTTACGGTTTCGTCCGTGTTGCA
GCCGATCATCAGCACATCTAGGTTTCGTCCGGGTGTGACCGAAAGGTAAGATGGAGAGCCTTGTCCCTGGTTTCAAC
GAGAAAACACACGTCCAACTCAGTTTGCCTGTTTTACAGGTTCGCGACGTGCTCGTACGTGGCTTTGGAGACTCCGT
GGAGGAGGTCTTATCAGAGGCACGTCAACATCTTAAAGATGGCACTTGTGGCTTAGTAGAAGTTGAAAAAGGCGTTT
ATTAAAGGTTTATACCTTCCCAGGTAACAAACCAACCAACTTTCGATCTCTTGTAGATCTGTTCTCTAAACGAACTT
AACATAGCAGTGGTGTTACCCGTGAACTCATGCGTGAGCTTAACGGAGGGGCATACACTCGCTATGTCGATAACAAC
TTCTGTGGCCCTGATGTAAAATCTGTGTGGCTGTCACTCGGCTGCATGCTTAGTGCACTCACGCAGTATAATTAATA
ACTAATTACTGTCGTTGACAGGACACGAGTAACTCGTCTATCTTCTGCAGGCTGCTTACGGTTTCGTCCGTGTTGCA
GCCGATCATCAGCACATCTAGGTTTCGTCCGGGTGTGACCGAAAGGTAAGATGGAGAGCCTTGTCCCTGGTTTCAAC
GAGAAAACACACGTCCAACTCAGTTTGCCTGTTTTACAGGTTCGCGACGTGCTCGTACGTGGCTTTGGAGACTCCGT
GGAGGAGGTCTTATCAGAGGCACGTCAACATCTTAAAGATGGCACTTGTGGCTTAGTAGAAGTTGAAAAAGGCGTTT
ATTAAAGGTTTATACCTTCCCAGGTAACAAACCAACCAACTTTCGATCTCTTGTAGATCTGTTCTCTAAACGAACTT
AACATAGCAGTGGTGTTACCCGTGAACTCATGCGTGAGCTTAACGGAGGGGCATACACTCGCTATGTCGATAACAAC
TTCTGTGGCCCTGATGTAAAATCTGTGTGGCTGTCACTCGGCTGCATGCTTAGTGCACTCACGCAGTATAATTAATA
ACTAATTACTGTCGTTGACAGGACACGAGTAACTCGTCTATCTTCTGCAGGCTGCTTACGGTTTCGTCCGTGTTGCA
GCCGATCATCAGCACATCTAGGTTTCGTCCGGGTGTGACCGAAAGGTAAGATGGAGAGCCTTGTCCCTGGTTTCAAC
GAGAAAACACACGTCCAACTCAGTTTGCCTGTTTTACAGGTTCGCGACGTGCTCGTACGTGGCTTTGGAGACTCCGT
GGAGGAGGTCTTATCAGAGGCACGTCAACATCTTAAAGATGGCACTTGTGGCTTAGTAGAAGTTGAAAAAGGCGTTT
ATTAAAGGTTTATACCTTCCCAGGTAACAAACCAACCAACTTTCGATCTCTTGTAGATCTGTTCTCTAAACGAACTT
AACATAGCAGTGGTGTTACCCGTGAACTCATGCGTGAGCTTAACGGAGGGGCATACACTCGCTATGTCGATAACAAC
TTCTGTGGCCCTGATGTAAAATCTGTGTGGCTGTCACTCGGCTGCATGCTTAGTGCACTCACGCAGTATAATTAATA
ACTAATTACTGTCGTTGACAGGACACGAGTAACTCGTCTATCTTCTGCAGGCTGCTTACGGTTTCGTCCGTGTTGCA
GCCGATCATCAGCACATCTAGGTTTCGTCCGGGTGTGACCGAAAGGTAAGATGGAGAGCCTTGTCCCTGGTTTCAAC
GAGAAAACACACGTCCAACTCAGTTTGCCTGTTTTACAGGTTCGCGACGTGCTCGTACGTGGCTTTGGAGACTCCGT
GGAGGAGGTCTTATCAGAGGCACGTCAACATCTTAAAGATGGCACTTGTGGCTTAGTAGAAGTTGAAAAAGGCGTTT'
]

{ #category : #'instance creation' }
AlbExamplesSeeClassSide class >> wordPadding [
	^ BlInsets top: 3 bottom: 3
]

{ #category : #'see class side' }
AlbExamplesSeeClassSide >> seeClassSide [
]
