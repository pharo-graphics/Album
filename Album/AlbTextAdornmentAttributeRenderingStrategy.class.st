Class {
	#name : #AlbTextAdornmentAttributeRenderingStrategy,
	#superclass : #Object,
	#traits : 'TBlDebug',
	#classTraits : 'TBlDebug classTrait',
	#instVars : [
		'attribute'
	],
	#category : #'Album-Editor-Attributes - Support'
}

{ #category : #accessing }
AlbTextAdornmentAttributeRenderingStrategy >> affect: aTTextEditorTextualPiece in: anEditorElement [
	"Return an element that should affect (either append or replace) a provided text piece"
	<return: #BlElement>
	^ self subclassResponsibility 
]

{ #category : #accessing }
AlbTextAdornmentAttributeRenderingStrategy >> attribute [
	<return: #AlbTextAdornmentAttribute>
	^ attribute
]

{ #category : #accessing }
AlbTextAdornmentAttributeRenderingStrategy >> attribute: aTextAdornmentAttribute [
	self 
		assert: [ aTextAdornmentAttribute isNotNil ] 
		description: [ 'Attribute must be non-nil' ].
	attribute := aTextAdornmentAttribute
]
