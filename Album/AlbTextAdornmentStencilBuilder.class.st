Class {
	#name : #AlbTextAdornmentStencilBuilder,
	#superclass : #BrStencilBuilder,
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
	<return: #BrEditorElement>

	^ editorElement
]

{ #category : #accessing }
AlbTextAdornmentStencilBuilder >> editor: aBrEditorElement [
	editorElement := aBrEditorElement
]

{ #category : #'api - instantiation' }
AlbTextAdornmentStencilBuilder >> paramsOn: aStencilExecutor [
	aStencilExecutor
		push: self segmentPiece;
		push: self editor
]

{ #category : #accessing }
AlbTextAdornmentStencilBuilder >> segmentPiece [
	<return: #TBrTextEditorTextualPiece>
	
	^ segmentPiece
]

{ #category : #accessing }
AlbTextAdornmentStencilBuilder >> segmentPiece: aTBrTextEditorTextualPiece [
	segmentPiece := aTBrTextEditorTextualPiece
]
