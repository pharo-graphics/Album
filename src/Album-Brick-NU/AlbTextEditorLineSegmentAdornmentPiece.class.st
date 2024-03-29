"
I special type of a segment piece that creates an element based on adornment attribute.

I am created by TextEditorAttributedLineSegment - a segment that supports adornment attributes
"
Class {
	#name : #AlbTextEditorLineSegmentAdornmentPiece,
	#superclass : #AlbTextEditorAbstractSegmentPiece,
	#instVars : [
		'adornmentAttribute',
		'isVirtual'
	],
	#category : #'Album-Brick-NU-Model-Segment-Text-Line'
}

{ #category : #comparing }
AlbTextEditorLineSegmentAdornmentPiece >> = anotherObject [
	self == anotherObject
		ifTrue: [ ^ true ].
	(anotherObject isKindOf: self class)
		ifFalse: [ ^ false ].
	
	^ anotherObject text = self text
		and: [ anotherObject adornmentAttribute = self adornmentAttribute ]
]

{ #category : #accessing }
AlbTextEditorLineSegmentAdornmentPiece >> adornmentAttribute [
	<return: #AlbTextAdornmentAttribute>

	^ adornmentAttribute
]

{ #category : #accessing }
AlbTextEditorLineSegmentAdornmentPiece >> adornmentAttribute: aTextAdornmentAttribute [

	self
		assert: [ aTextAdornmentAttribute isNotNil ]
		description: [ 'Adornment attribute must not be nil' ].

	adornmentAttribute := aTextAdornmentAttribute
]

{ #category : #'instance creation' }
AlbTextEditorLineSegmentAdornmentPiece >> createElement: anEditorElement [
	| theAdornmentElements |

	theAdornmentElements := (self adornmentAttribute affect: self in: anEditorElement) asOrderedCollection.
	theAdornmentElements ifEmpty: [
		theAdornmentElements := OrderedCollection with: (BlElement new size: 0@0) ]. 
	theAdornmentElements do: [ :eachElement |
		eachElement mouseCursor ifNil: [ eachElement mouseCursor: BlCursor default ].
		eachElement userData at: #editorAdornment put: true.
		self adornmentAttribute isFocusable
			ifFalse: [ eachElement focusability: BlFocusabilityNone new ] ].
	
	theAdornmentElements withIndexDo: [ :eachAdornmentElement :eachIndex |
		| aCharLength |
		
		aCharLength := self isVirtual
			ifTrue: [ 0 ]
			ifFalse: [ eachIndex = theAdornmentElements size
				ifTrue: [ self textLength ]
				ifFalse: [ 0 ] ].
		
		eachAdornmentElement userData at: #editorCharLength put: aCharLength.
		eachAdornmentElement userData at: #editorTextPiece put: self ].
	
	^ theAdornmentElements
]

{ #category : #comparing }
AlbTextEditorLineSegmentAdornmentPiece >> hash [
	^ (self class hash bitXor: self text hash) bitXor: self adornmentAttribute hash
]

{ #category : #initialization }
AlbTextEditorLineSegmentAdornmentPiece >> initialize [
	super initialize.

	"means I do not count for representing an actual text"
	isVirtual := true
]

{ #category : #accessing }
AlbTextEditorLineSegmentAdornmentPiece >> isVirtual [
	^ isVirtual
]

{ #category : #'api - cursor' }
AlbTextEditorLineSegmentAdornmentPiece >> screenToCursor: aTransformation of: anEditorElement in: aPieceElement [
	super screenToCursor: aTransformation of: anEditorElement in: aPieceElement.
	
	aTransformation hasResult
		ifFalse: [ aTransformation transformed: self textEnd ]
]

{ #category : #accessing }
AlbTextEditorLineSegmentAdornmentPiece >> virtual: aBoolean [
	isVirtual := aBoolean
]
