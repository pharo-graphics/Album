Class {
	#name : #AlbTextAdornmentAttributeSyncRenderingStrategy,
	#superclass : #AlbTextAdornmentAttributeRenderingStrategy,
	#category : 'Album-Attributes - Support'
}

{ #category : #accessing }
AlbTextAdornmentAttributeSyncRenderingStrategy >> affect: aTTextEditorTextualPiece in: anEditorElement [
	"Return an element that should affect (either append or replace) a provided text piece"
	<return: #BlElement>
	^ self attribute doAffect: aTTextEditorTextualPiece in: anEditorElement
]
