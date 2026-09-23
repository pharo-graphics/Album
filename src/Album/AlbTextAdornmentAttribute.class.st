"
I am an attribute which when applied on a text visually replaces some parts of it with other items (not neccessarily character).

See `AlbTextEditorAdornmentsExamples`
"
Class {
	#name : #AlbTextAdornmentAttribute,
	#superclass : #BlTextAttribute,
	#instVars : [
		'shouldAppend'
	],
	#category : #'Album-Attributes'
}

{ #category : #accessing }
AlbTextAdornmentAttribute >> affect: aTTextEditorTextualPiece in: anEditorElement [
	"Return an element that should affect (either append or replace) a provided text piece"
	<return: #SequenceableCollection of: #BlElement>
	
	^ self doAffect: aTTextEditorTextualPiece in: anEditorElement
]

{ #category : #accessing }
AlbTextAdornmentAttribute >> beAppend [
	shouldAppend := true
]

{ #category : #accessing }
AlbTextAdornmentAttribute >> beReplace [
	shouldAppend := false
]

{ #category : #accessing }
AlbTextAdornmentAttribute >> doAffect: aTTextEditorTextualPiece in: anEditorElement [
	"Return an element that should affect (either append or replace) a provided text piece"
	<return: #SequenceableCollection of: #BlElement>

	^ self subclassResponsibility
]

{ #category : #initialization }
AlbTextAdornmentAttribute >> initialize [
	super initialize.
	
	shouldAppend := false
]

{ #category : #initialization }
AlbTextAdornmentAttribute >> initializeLazyElement: aBlLazyElement [
	"Subclasses can initialize the element"
]

{ #category : #testing }
AlbTextAdornmentAttribute >> isAdornment [
	"Return true if attribute influences text structure, for examples if it replaces one or more characters
	with any amount of other arbitrary items, false otherwise"
	<return: #Boolean>

	^ true
]

{ #category : #testing }
AlbTextAdornmentAttribute >> isFocusable [
	"Return true if an element (but not its children) created by the adornment attribute can be focused"
	<return: #Boolean>

	^ false
]

{ #category : #testing }
AlbTextAdornmentAttribute >> isStyle [
	"I am not a text style related attribute"

	^ false
]

{ #category : #testing }
AlbTextAdornmentAttribute >> mayHaveExternalReferences [
	"Answer if this attribute can have references to some external objects like AST nodes or computation results"

	^ true
]

{ #category : #testing }
AlbTextAdornmentAttribute >> shouldAppend [
	^ shouldAppend
]

{ #category : #testing }
AlbTextAdornmentAttribute >> shouldReplace [
	^ shouldAppend not
]

{ #category : #printing }
AlbTextAdornmentAttribute >> storeOn: aStream [
	super storeOn: aStream.
	
	aStream nextPutAll: ' '.
	aStream nextPutAll: (shouldAppend
		ifTrue: [ #beAppend ]
		ifFalse: [ #beReplace ]) asString
]

{ #category : #comparing }
AlbTextAdornmentAttribute >> type [
	^ self
]
