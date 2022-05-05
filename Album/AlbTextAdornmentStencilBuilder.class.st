Class {
	#name : #AlbTextAdornmentStencilBuilder,
	#superclass : #AlbStencilBuilder,
	#instVars : [
		'editorElement',
		'segmentPiece'
	],
	#category : #'Album-UI-Stencils'
}

{ #category : #'api - instantiation' }
AlbTextAdornmentStencilBuilder >> buildDefault [
	^ BlElement new
		size: 20@20;
		background: Color red
]

{ #category : #accessing }
AlbTextAdornmentStencilBuilder >> editor [
	<return: #AlbEditorElement>

	^ editorElement
]

{ #category : #accessing }
AlbTextAdornmentStencilBuilder >> editor: aEditorElement [
	editorElement := aEditorElement
]

{ #category : #'api - instantiation' }
AlbTextAdornmentStencilBuilder >> paramsOn: aStencilExecutor [
	aStencilExecutor
		push: self segmentPiece;
		push: self editor
]

{ #category : #accessing }
AlbTextAdornmentStencilBuilder >> segmentPiece [
	<return: #TAlbTextEditorTextualPiece>
	
	^ segmentPiece
]

{ #category : #accessing }
AlbTextAdornmentStencilBuilder >> segmentPiece: aTTextEditorTextualPiece [
	segmentPiece := aTTextEditorTextualPiece
]
