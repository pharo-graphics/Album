"
I add utility methods related to fixed text measurer
"
Trait {
	#name : #TAlbTextEditorFixedMeasurerExamples,
	#category : #'Album-Examples-Editor'
}

{ #category : #'private - font metrics' }
TAlbTextEditorFixedMeasurerExamples >> ascent [
	^ -20
]

{ #category : #'private - font metrics' }
TAlbTextEditorFixedMeasurerExamples >> descent [
	^ 20
]

{ #category : #'instance creation' }
TAlbTextEditorFixedMeasurerExamples >> editorFor: aText [
	<return: #AlbEditorElement>
	| anEditor aRopedText |

	aRopedText := aText asRopedText lineSpacing: self lineSpacing; paragraphMargin: self paragraphMargin; wordPadding: self wordPadding.

	anEditor := AlbEditorElement new.
	anEditor padding: BlInsets empty.
	anEditor fitContent.
	anEditor text: aRopedText.
	
	BlDevCrossover on: anEditor.
	
	anEditor editor 
		wordStencil: [ :aTAlbTextEditorTextualPiece |
			| aTextElement |
			aTextElement := AlbTextWordPieceStencil editable
				segmentPiece: aTAlbTextEditorTextualPiece;
				asElement.
			aTextElement measurer: self fixedMeasurer.
			aTextElement measurer textOffset: aTAlbTextEditorTextualPiece textStart.
			aTextElement ].
	
	anEditor requestFocus.
	anEditor forceLayout.

	^ anEditor
]

{ #category : #'private - instance creation' }
TAlbTextEditorFixedMeasurerExamples >> fixedMeasurer [
	^ BlSpartaTextElementMockedMeasurer new
		ascent: self ascent;
		descent: self descent;
		glyphWidth: self glyphWidth;
		glyphHeight: self glyphHeight
]

{ #category : #'private - font metrics' }
TAlbTextEditorFixedMeasurerExamples >> glyphHeight [
	^ self ascent abs + self descent
]

{ #category : #'private - font metrics' }
TAlbTextEditorFixedMeasurerExamples >> glyphWidth [
	^ 30
]

{ #category : #'private - font metrics' }
TAlbTextEditorFixedMeasurerExamples >> lineSpacing [
	^ 5
]

{ #category : #'private - font metrics' }
TAlbTextEditorFixedMeasurerExamples >> paragraphMargin [
	^ BlInsets all: 15
]

{ #category : #'private - font metrics' }
TAlbTextEditorFixedMeasurerExamples >> wordPadding [
	^ BlInsets top: 3 bottom: 3
]
