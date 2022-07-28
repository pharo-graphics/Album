Extension { #name : #AlbExamplesSeeClassSide }

{ #category : #'*Album-Alexandrie' }
AlbExamplesSeeClassSide class >> alexandrieEditorFor: aText [

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
		aTextElement measurer: self alexandrieFixedMeasurer.
		aTextElement measurer textOffset: aTAlbTextEditorTextualPiece textStart.
		aTextElement ].


	^ anEditor
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
