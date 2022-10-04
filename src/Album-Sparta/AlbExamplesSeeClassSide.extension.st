Extension { #name : #AlbExamplesSeeClassSide }

{ #category : #'*Album-Sparta' }
AlbExamplesSeeClassSide class >> example_SpartaFixedMeasurer [
	" have to understand this ..."
	| anEditor host |
	anEditor := self spartaEditorFor: 'Hello'.
	host := BlMorphicWindowHost new.
	BlSpace new
		addChild: anEditor;
		host: host;
		title: host asString;
		extent: 200 asPoint;
		show.
]

{ #category : #'*Album-Sparta' }
AlbExamplesSeeClassSide class >> example_SpartaFixedMeasurer0 [
	| element text host |
	text := ('1234567890' asRopedText
		       fontSize: 16;
		       fontName: 'Helvetica Neue').
	element := text asElement.
	element measurer: self spartaFixedMeasurer.
	host := BlMorphicWindowHost new.
	BlSpace new
		addChild: element;
		host: host;
		title: host asString;
		extent: 200 asPoint;
		show.
]

{ #category : #'*Album-Sparta' }
AlbExamplesSeeClassSide class >> spartaEditorFor: aText [

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

	"BlDevCrossover on: anEditor."

	"anEditor editor  beLineBased."
	anEditor editor wordStencil: [ :aTAlbTextEditorTextualPiece | 
		| aTextElement |
		aTextElement := AlbTextWordPieceStencilBuilder editable
			                segmentPiece: aTAlbTextEditorTextualPiece;
			                asElement.
		aTextElement measurer: self spartaFixedMeasurer.
		aTextElement measurer textOffset: aTAlbTextEditorTextualPiece textStart.
		aTextElement ].


	^ anEditor
]

{ #category : #'*Album-Sparta' }
AlbExamplesSeeClassSide class >> spartaFixedMeasurer [
	^ BlSpartaTextElementMockedMeasurer new
		ascent: self ascent;
		descent: self descent;
		glyphWidth: self glyphWidth;
		glyphHeight: self glyphHeight
]
