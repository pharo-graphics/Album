Class {
	#name : 'AlbTextHideAttribute',
	#superclass : 'AlbTextAdornmentAttribute',
	#category : 'Album-Attributes',
	#package : 'Album',
	#tag : 'Attributes'
}

{ #category : 'accessing' }
AlbTextHideAttribute >> doAffect: aTTextEditorTextualPiece in: anEditorElement [
	"Return an element that should affect (either append or replace) a provided text piece"
	<return: #SequenceableCollection of: #BlElement>

	^ #()
]

{ #category : 'initialization' }
AlbTextHideAttribute >> initialize [
	super initialize.
	
	self beReplace
]
