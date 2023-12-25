Class {
	#name : #AlbTextExpandButtonAttribute,
	#superclass : #AlbTextAdornmentAttribute,
	#instVars : [
		'isExpanded',
		'attributesCreatingBlock',
		'createdAttributes'
	],
	#category : 'Album-Attributes'
}

{ #category : #private }
AlbTextExpandButtonAttribute >> applyExpandedOrCollapsedAttributesOn: aTTextEditorTextualPiece in: aTextEditor [
	"Add attributes if expanded and remove if collapsed"
	| aText |
	
	aText := aTTextEditorTextualPiece text.
	"we should not forget to remove already created attributes"
	aText clearAttributes: [ :aTextAttribute | self createdAttributes includes: aTextAttribute ].
	
	isExpanded
		ifTrue: [ self createAttributesAffect: aText in: aTextEditor ]
]

{ #category : #accessing }
AlbTextExpandButtonAttribute >> attributesCreatingBlock [
	^ attributesCreatingBlock
]

{ #category : #accessing }
AlbTextExpandButtonAttribute >> attributesCreatingBlock: aBlock [
	attributesCreatingBlock := aBlock
]

{ #category : #private }
AlbTextExpandButtonAttribute >> createAttributesAffect: aText in: aTextEditor [
	createdAttributes := (attributesCreatingBlock
		cull: aText
		cull: aTextEditor) asOrderedCollection.
	aText attributes: createdAttributes
]

{ #category : #accessing }
AlbTextExpandButtonAttribute >> createdAttributes [
	^ createdAttributes
]

{ #category : #accessing }
AlbTextExpandButtonAttribute >> createdAttributes: aCollection [
	createdAttributes := aCollection
]

{ #category : #initialization }
AlbTextExpandButtonAttribute >> initialize [
	super initialize.
	
	self beAppend.
	
	attributesCreatingBlock := [ OrderedCollection new ].
	isExpanded := false.
	createdAttributes := OrderedCollection new
]

{ #category : #accessing }
AlbTextExpandButtonAttribute >> isExpanded [
	^ isExpanded
]

{ #category : #accessing }
AlbTextExpandButtonAttribute >> isExpanded: aBoolean [
	isExpanded := aBoolean
]

{ #category : #private }
AlbTextExpandButtonAttribute >> toggleExpandedOrCollapsedAttributesOn: aTTextEditorTextualPiece in: aTextEditor [
	self isExpanded: isExpanded not.
	self applyExpandedOrCollapsedAttributesOn: aTTextEditorTextualPiece in: aTextEditor
]
