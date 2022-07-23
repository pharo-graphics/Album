Class {
	#name : #AlbTextEditorParagraphSegmentAdornmentPiece,
	#superclass : #AlbTextEditorParagraphSegmentPiece,
	#instVars : [
		'adornmentAttribute',
		'isVirtual'
	],
	#category : #'Album-Brick-NU-Model Segment Paragraph'
}

{ #category : #comparing }
AlbTextEditorParagraphSegmentAdornmentPiece >> = anotherObject [
	self == anotherObject
		ifTrue: [ ^ true ].
	(anotherObject isKindOf: self class)
		ifFalse: [ ^ false ].
	
	^ anotherObject text = self text
		and: [ anotherObject adornmentAttribute = self adornmentAttribute ]
]

{ #category : #accessing }
AlbTextEditorParagraphSegmentAdornmentPiece >> adornmentAttribute [
	<return: #BrTextAdornmentAttribute>

	^ adornmentAttribute
]

{ #category : #accessing }
AlbTextEditorParagraphSegmentAdornmentPiece >> adornmentAttribute: aBrTextAdornmentAttribute [

	self
		assert: [ aBrTextAdornmentAttribute isNotNil ]
		description: [ 'Adornment attribute must not be nil' ].

	adornmentAttribute := aBrTextAdornmentAttribute
]

{ #category : #'instance creation' }
AlbTextEditorParagraphSegmentAdornmentPiece >> createElement: anEditorElement [
	| theAdornmentElements |

	theAdornmentElements := (self adornmentAttribute affect: self in: anEditorElement) asOrderedCollection.
	theAdornmentElements ifEmpty: [
		theAdornmentElements := OrderedCollection with: (BlElement new size: 0@0) ]. 
	theAdornmentElements do: [ :eachElement |
		eachElement mouseCursor ifNil: [ eachElement mouseCursor: BlCursor default ].
		eachElement userData at: #editorAdornment put: true.
		self adornmentAttribute isFocusable
			ifFalse: [ eachElement focusability: BlFocusabilityNone new ] ].

	self assert: [ self isVirtual or: [
			"only replacement attribute can be non-virtual"
			self isVirtual not and: [ self adornmentAttribute shouldReplace ] ] ]
		description: [ 'Only replacement attribute can be non-virtual' ].
	
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
AlbTextEditorParagraphSegmentAdornmentPiece >> hash [
	^ (self class hash bitXor: self text hash) bitXor: self adornmentAttribute hash
]

{ #category : #initialization }
AlbTextEditorParagraphSegmentAdornmentPiece >> initialize [
	super initialize.

	"means I do not count for representing an actual text"
	isVirtual := true
]

{ #category : #accessing }
AlbTextEditorParagraphSegmentAdornmentPiece >> isVirtual [
	^ isVirtual
]

{ #category : #accessing }
AlbTextEditorParagraphSegmentAdornmentPiece >> virtual: aBoolean [
	self
		assert: [ aBoolean or: [
			"only replacement attribute can be non-virtual"
			aBoolean not and: [ self adornmentAttribute shouldReplace ] ] ]
		description: [ 'Only replacement attribute can be non-virtual' ].

	isVirtual := aBoolean
]
