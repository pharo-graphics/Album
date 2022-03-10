Class {
	#name : #AlbTextReplacingAttribute,
	#superclass : #AlbTextAdornmentAttribute,
	#instVars : [
		'replacement',
		'embellishment',
		'padding',
		'margin',
		'originalString',
		'replacementString'
	],
	#category : #'Album-Editor-Attributes'
}

{ #category : #accessing }
AlbTextReplacingAttribute >> doAffect: aTTextEditorTextualPiece in: anEditorElement [
	"Return an element that should affect (either append or replace) a provided text piece"
	<return: #SequenceableCollection of: #BlElement>
	| aReplacementTextElement |

	aReplacementTextElement := (anEditorElement editor segmentBuilder wordStencilBuilder
		wordPadding: padding + aTTextEditorTextualPiece wordPadding;
		wordMargin: margin + aTTextEditorTextualPiece wordMargin;
		shouldUsePool: false;
		segmentPiece: (self replaceTextInPiece: aTTextEditorTextualPiece)) asElement.

	aReplacementTextElement removeEventHandler: BrTextWordPieceTextChangeHandler uniqueInstance.
	aReplacementTextElement when: BrTextEditorTextChangedRequest do: [ :anEvent |
		| aHiddenSegmentPiece |
		aHiddenSegmentPiece := self replaceTextInPiece: anEvent segmentPiece.
		anEvent currentTarget segmentPiece: aHiddenSegmentPiece
	].

	embellishment cull: aReplacementTextElement cull: aTTextEditorTextualPiece.
	
	^ {
		aReplacementTextElement.
		BlElement new size: 0@0
	}
]

{ #category : #'api - attribute' }
AlbTextReplacingAttribute >> embellishment [
	^ embellishment
]

{ #category : #'api - attribute' }
AlbTextReplacingAttribute >> embellishment: anObject [
	embellishment := anObject
]

{ #category : #initialization }
AlbTextReplacingAttribute >> initialize [
	super initialize.
	
	replacement := AlbTextReplacingAttributeWithCharacterStrategy new character: $*.
	embellishment := [ :aTextPieceElement :aTTextEditorTextualPiece | ].
	padding := BlInsets empty.
	margin := BlInsets empty
]

{ #category : #accessing }
AlbTextReplacingAttribute >> margin [
	^ margin
]

{ #category : #accessing }
AlbTextReplacingAttribute >> margin: anObject [
	margin := anObject
]

{ #category : #'api - attribute' }
AlbTextReplacingAttribute >> padding [
	<return: #BlInsets>

	^ padding
]

{ #category : #'api - attribute' }
AlbTextReplacingAttribute >> padding: anObject [
	padding := anObject
]

{ #category : #private }
AlbTextReplacingAttribute >> replaceTextInPiece: aTTextEditorTextualPiece [
	| aNewText anOriginalText |
	
	anOriginalText := aTTextEditorTextualPiece text.
	aNewText := (self swapString: anOriginalText characters asString) asRopedText.
	
	self
		assert: [ anOriginalText size = aNewText size ]
		description: [ 'Replacement text must be the same size' ].
	
	anOriginalText
		attributesDo: [ :theAttributes :anIndex | aNewText attributes: theAttributes from: anIndex to: anIndex ].

	^ aTTextEditorTextualPiece copyWithText: aNewText
]

{ #category : #accessing }
AlbTextReplacingAttribute >> replacement [
	<return: #AlbTextReplacingAttributeStrategy>

	^ replacement
]

{ #category : #accessing }
AlbTextReplacingAttribute >> replacement: aTextReplacingAttributeStrategy [
	replacement := aTextReplacingAttributeStrategy
]

{ #category : #private }
AlbTextReplacingAttribute >> swapString: aString [
	<return: #String>
	
	(originalString = aString and: [ replacementString isNotNil ])
		ifTrue: [ ^ replacementString ].
		
	originalString := aString.
	replacementString := replacement swapString: aString.
	
	^ replacementString
]

{ #category : #'api - attribute' }
AlbTextReplacingAttribute >> withCharacter: aCharacter [
	self replacement: (AlbTextReplacingAttributeWithCharacterStrategy new character: aCharacter)
]

{ #category : #'api - attribute' }
AlbTextReplacingAttribute >> withRandomizing [
	self replacement: (AlbTextReplacingAttributeWithRandomizingStrategy new)
]
