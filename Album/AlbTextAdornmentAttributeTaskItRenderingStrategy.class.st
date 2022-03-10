Class {
	#name : #AlbTextAdornmentAttributeTaskItRenderingStrategy,
	#superclass : #AlbTextAdornmentAttributeRenderingStrategy,
	#category : #'Album-Editor-Attributes - Support'
}

{ #category : #accessing }
AlbTextAdornmentAttributeTaskItRenderingStrategy >> affect: aTTextEditorTextualPiece in: anEditorElement [
	"Return an element that should affect (either append or replace) a provided text piece"
	<return: #BlElement>

	^ BlLazyElement new
		withGlamorousPreview;
		in: [ :theElement | self attribute initializeLazyElement: theElement ];
		elementBuilder: [ self attribute doAffect: aTTextEditorTextualPiece in: anEditorElement ]
]
