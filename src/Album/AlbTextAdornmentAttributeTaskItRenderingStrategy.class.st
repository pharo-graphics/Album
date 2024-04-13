Class {
	#name : #AlbTextAdornmentAttributeTaskItRenderingStrategy,
	#superclass : #AlbTextAdornmentAttributeRenderingStrategy,
	#category : #'Album-Attributes - Support'
}

{ #category : #accessing }
AlbTextAdornmentAttributeTaskItRenderingStrategy >> affect: aTTextEditorTextualPiece in: anEditorElement [
	"Return an element that should affect (either append or replace) a provided text piece"
	<return: #BlElement>

self flag: 'TODO: understand withGlamorousPreview.'.
	^ BlLazyElement new
		"withGlamorousPreview;"
		in: [ :theElement | self attribute initializeLazyElement: theElement ];
		elementBuilder: [ self attribute doAffect: aTTextEditorTextualPiece in: anEditorElement ]
]
