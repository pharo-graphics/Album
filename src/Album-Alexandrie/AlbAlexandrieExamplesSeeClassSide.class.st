Class {
	#name : #AlbAlexandrieExamplesSeeClassSide,
	#superclass : #Object,
	#category : #'Album-Alexandrie'
}

{ #category : #'instance creation' }
AlbAlexandrieExamplesSeeClassSide class >> alexandrieEditorFor: aText [

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

{ #category : #'instance creation' }
AlbAlexandrieExamplesSeeClassSide class >> alexandrieFixedMeasurer [
	^ BATextElementMockedMeasurer new
		ascent: self ascent;
		descent: self descent;
		glyphWidth: self glyphWidth;
		glyphHeight: self glyphHeight
]

{ #category : #'instance creation' }
AlbAlexandrieExamplesSeeClassSide class >> ascent [
	^ -20
]

{ #category : #'instance creation' }
AlbAlexandrieExamplesSeeClassSide class >> descent [
	^ 20
]

{ #category : #'instance creation' }
AlbAlexandrieExamplesSeeClassSide class >> example_AlexandrieFixedMeasurer0 [
	| element text |
	text := ('1234567890' asRopedText
		       fontSize: 16;
		       fontName: 'Helvetica Neue').
	element := text asElement.
	element measurer: self alexandrieFixedMeasurer.
	element openInOblSpace
]

{ #category : #'instance creation' }
AlbAlexandrieExamplesSeeClassSide class >> example_AlexandrieixedMeasurer [
	" have to understand this ..."
	| anEditor |
	anEditor := self alexandrieEditorFor: 'Hello'.
	anEditor withLineNumbers.
	anEditor openInOBlSpace 

]

{ #category : #'instance creation' }
AlbAlexandrieExamplesSeeClassSide class >> example_SpartaFixedMeasurer [
	" have to understand this ..."
	| anEditor |
	anEditor := self spartaEditorFor: 'Hello'.
	anEditor openInOBlSpace 

]

{ #category : #'instance creation' }
AlbAlexandrieExamplesSeeClassSide class >> example_SpartaFixedMeasurer0 [
	| element text |
	text := ('1234567890' asRopedText
		       fontSize: 16;
		       fontName: 'Helvetica Neue').
	element := text asElement.
	element measurer: self spartaFixedMeasurer.
	element openInOblSpace
]

{ #category : #'instance creation' }
AlbAlexandrieExamplesSeeClassSide class >> glyphHeight [
	^ self ascent abs + self descent
]

{ #category : #'instance creation' }
AlbAlexandrieExamplesSeeClassSide class >> glyphWidth [
	^ 30
]

{ #category : #'instance creation' }
AlbAlexandrieExamplesSeeClassSide class >> lineSpacing [
	^ 5
]

{ #category : #accessing }
AlbAlexandrieExamplesSeeClassSide class >> methodText [
	^ self  class sourceCodeAt: #example_CodeEditorWithRBStylerWithDresser
]

{ #category : #'instance creation' }
AlbAlexandrieExamplesSeeClassSide class >> paragraphMargin [
	^ BlInsets all: 15
]

{ #category : #'instance creation' }
AlbAlexandrieExamplesSeeClassSide class >> spartaEditorFor: aText [

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
		aTextElement measurer: self spartaFixedMeasurer.
		aTextElement measurer textOffset: aTAlbTextEditorTextualPiece textStart.
		aTextElement ].


	^ anEditor
]

{ #category : #'instance creation' }
AlbAlexandrieExamplesSeeClassSide class >> spartaFixedMeasurer [
	^ BlSpartaTextElementMockedMeasurer new
		ascent: self ascent;
		descent: self descent;
		glyphWidth: self glyphWidth;
		glyphHeight: self glyphHeight
]

{ #category : #'instance creation' }
AlbAlexandrieExamplesSeeClassSide class >> wordPadding [
	^ BlInsets top: 3 bottom: 3
]
