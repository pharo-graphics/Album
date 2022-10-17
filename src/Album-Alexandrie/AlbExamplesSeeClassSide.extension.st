Extension { #name : #AlbExamplesSeeClassSide }

{ #category : #'*Album-Alexandrie' }
AlbExamplesSeeClassSide class >> alexandrieEditorFor: aText [

	<return: #AlbEditorElement>
	| anEditor aRopedText |
	aRopedText := aText asRopedText
		              lineSpacing: self lineSpacing;
		              paragraphMargin: self paragraphMargin;
		              wordPadding: self wordPadding.

	anEditor := AlbEditorElement new.
	anEditor padding: BlInsets empty.
	anEditor fitContent.
	anEditor text: aRopedText.	
	anEditor viewModel wordStencil measurer: self alexandrieFixedMeasurer.

	^ anEditor
]

{ #category : #'*Album-Alexandrie' }
AlbExamplesSeeClassSide class >> alexandrieFixedMeasurer [
	^ BATextElementMockedMeasurer new
		ascent: self ascent;
		descent: self descent;
		glyphWidth: self glyphWidth;
		glyphHeight: self glyphHeight
]

{ #category : #'*Album-Alexandrie' }
AlbExamplesSeeClassSide class >> example_AlexandrieFixedMeasurer0 [

	| element text host |
	text := '1234567890' asRopedText
		        fontSize: 16;
		        fontName: 'Helvetica Neue'.
	element := text asElement.
	element measurer: self alexandrieFixedMeasurer.
	host := BAMorphicWindowHost new.
	BlSpace new
		addChild: element;
		host: host;
		title: host asString;
		extent: 200 asPoint;
		show.
]

{ #category : #'*Album-Alexandrie' }
AlbExamplesSeeClassSide class >> example_AlexandrieFixedMeasurer1 [

	| root space text host |
	root := BlElement new constraintsDo: [ :c | 
		        c vertical matchParent.
		        c horizontal matchParent ].

	root layout: BlLinearLayout vertical.

	text := 'CGTAACAAGGTTTCCGTAGGTGAACCTGCGGAAGGATCATTGTTGAGACAACAGAATATATGATCGAGTG
AATCTGGAGGACCTGTGGTAACTCAGCTCGTCGTGGCACTGCTTTTGTCGTGACCCTGCTTTGTTGTTGG
GCCTCCTCAAGAGCTTTCATGGCAGGTTTGAACTTTAGTACGGTGCAGTTTGCGCCAAGTCATATAAAGC
ATCACTGATGAATGACATTATTGTCAGAAAAAATCAGAGGGGCAGTATGCTACTGAGCATGCCAGTGAAT
TTTTATGACTCTCGCAACGGATATCTTGGCTCTAACATCGATGAAGAACGCAGCTAAATGCGATAAGTGG
TGTGAATTGCAGAATCCCGTGAACCATCGAGTCTTTGAACGCAAGTTGCGCTCGAGGCCATCAGGCTAAG
GGCACGCCTGCCTGGGCGTCGTGTGTTGCGTCTCTCCTACCAATGCTTGCTTGGCATATCGCTAAGCTGG
CATTATACGGATGTGAATGATTGGCCCCTTGTGCCTAGGTGCGGTGGGTCTAAGGATTGTTGCTTTGATG
GGTAGGAATGTGGCACGAGGTGGAGAATGCTAACAGTCATAAGGCTGCTATTTGAATCCCCCATGTTGTT
GTATTTTTTCGAACCTACACAAGAACCTAATTGAACCCCAATGGAGCTAAAATAACCATTGGGCAGTTGA
TTTCCATTCAGATGCGACCCCAGGTCAGGCGGGGCCACCCGCTGAGTTGAGGC'.
	text linesDo: [ :l | 
		| elem |
		elem := (l asRopedText fontSize: 16) asElement.
		elem measurer: (BATextElementMockedMeasurer new).
		root addChild: elem ].

	host := BAMorphicWindowHost new.
	space := BlSpace new
		         addChild: root;
		         host: host;
		         title: host asString;
		         extent: 800 asPoint.
	space show
]

{ #category : #'*Album-Alexandrie' }
AlbExamplesSeeClassSide class >> example_AlexandrieixedMeasurer [

	" have to understand this ..."

	| anEditor host |
	anEditor := self alexandrieEditorFor: 'Hello'.
	host := BAMorphicWindowHost new.
	BlSpace new
		addChild: anEditor;
		host: host;
		title: host asString;
		extent: 200 asPoint;
		show
]
