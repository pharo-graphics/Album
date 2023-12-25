"
I am an attribute which when applied on a text visually replaces some parts of it with other items (not neccessarily character).

See `AlbTextEditorAdornmentsExamples`
"
Class {
	#name : #AlbTextAdornmentAttribute,
	#superclass : #BlTextAttribute,
	#instVars : [
		'shouldAppend',
		'renderingStrategy'
	],
	#category : 'Album-Attributes'
}

{ #category : #accessing }
AlbTextAdornmentAttribute >> affect: aTTextEditorTextualPiece in: anEditorElement [
	"Return an element that should affect (either append or replace) a provided text piece"
	<return: #SequenceableCollection of: #BlElement>
	
	^ self renderingStrategy affect: aTTextEditorTextualPiece in: anEditorElement
]

{ #category : #accessing }
AlbTextAdornmentAttribute >> beAppend [
	shouldAppend := true
]

{ #category : #accessing }
AlbTextAdornmentAttribute >> beLazy [
	self renderingStrategy: AlbTextAdornmentAttributeTaskItRenderingStrategy new.
]

{ #category : #accessing }
AlbTextAdornmentAttribute >> beReplace [
	shouldAppend := false
]

{ #category : #accessing }
AlbTextAdornmentAttribute >> beSync [
	self renderingStrategy: AlbTextAdornmentAttributeSyncRenderingStrategy new.
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
	
	shouldAppend := false.
	self renderingStrategy: AlbTextAdornmentAttributeSyncRenderingStrategy new.
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

{ #category : #accessing }
AlbTextAdornmentAttribute >> renderingStrategy [
	<return: #AlbTextAdornmentAttributeRenderingStrategy>
	^ renderingStrategy
]

{ #category : #accessing }
AlbTextAdornmentAttribute >> renderingStrategy: aTextAdornmentAttributeRenderingStrategy [
	self 
		assert: [ aTextAdornmentAttributeRenderingStrategy isNotNil ] 
		description: [ 'Text attribute rendering strategy must be non-nil' ].
	aTextAdornmentAttributeRenderingStrategy attribute: self.
	renderingStrategy := aTextAdornmentAttributeRenderingStrategy
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
